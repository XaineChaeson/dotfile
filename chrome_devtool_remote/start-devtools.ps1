param(
  [int]$DevtoolsLocalPort = 9222,
  [int]$DevtoolsLanPort = 9223,
  [string]$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe",
  [string]$UserDataDir = "$env:TEMP\chrome-mcp-test",
  [string]$PortProxyListenAddress = "0.0.0.0",
  [string]$FirewallRemoteAddress = "LocalSubnet",
  [string]$StateFile = "$env:ProgramData\chrome-devtools-mcp\state.json",
  [switch]$Ephemeral
)

function Require-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = New-Object Security.Principal.WindowsPrincipal($id)
  if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Please run this script in an elevated (Administrator) PowerShell."
  }
}

function Get-ActiveLanIPv4s {
  $ips = Get-NetIPConfiguration |
    Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.IPv4Address -ne $null } |
    ForEach-Object { $_.IPv4Address | ForEach-Object { $_.IPAddress } } |
    Where-Object { $_ -and $_ -notlike "169.254.*" -and $_ -notlike "127.*" } |
    Sort-Object -Unique

  if (-not $ips) {
    $ips = Get-NetIPAddress -AddressFamily IPv4 |
      Where-Object { $_.IPAddress -and $_.IPAddress -notlike "169.254.*" -and $_.IPAddress -notlike "127.*" } |
      Select-Object -ExpandProperty IPAddress -Unique
  }

  return @($ips)
}

function Stop-ManagedChrome {
  param(
    [int]$Port,
    [string]$ManagedUserDataDir
  )

  $targets = Get-CimInstance Win32_Process -Filter "name = 'chrome.exe'" | Where-Object {
    $_.CommandLine -and (
      $_.CommandLine -like "*--remote-debugging-port=$Port*" -or
      $_.CommandLine -like "*--user-data-dir=$ManagedUserDataDir*" -or
      $_.CommandLine -like "*--user-data-dir=`"$ManagedUserDataDir`"*"
    )
  }

  foreach ($proc in $targets) {
    Write-Host ("   - stop managed chrome pid=" + $proc.ProcessId)
    Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
  }
}

function Remove-StalePortProxyEntries {
  param(
    [int]$ListenPort
  )

  $raw = & netsh interface portproxy show v4tov4
  $lines = $raw | Where-Object { $_ -match '^\s*\d+\.\d+\.\d+\.\d+\s+\d+\s+\d+\.\d+\.\d+\.\d+\s+\d+\s*$' }

  foreach ($line in $lines) {
    $parts = ($line -split '\s+') | Where-Object { $_ -ne "" }
    if ($parts.Count -lt 4) {
      continue
    }

    $listenAddress = $parts[0]
    $currentPort = [int]$parts[1]

    if ($currentPort -eq $ListenPort) {
      Write-Host "   - delete stale portproxy: $listenAddress`:$currentPort"
      & netsh interface portproxy delete v4tov4 listenaddress=$listenAddress listenport=$currentPort | Out-Null
    }
  }
}

function Write-StateFile {
  param(
    [string]$Path,
    [pscustomobject]$VersionInfo,
    [string[]]$LanIPs,
    [int]$LocalPort,
    [int]$LanPort,
    [string]$ListenAddress,
    [string]$RemoteAddress,
    [string]$ManagedUserDataDir,
    [string]$ManagedChromePath
  )

  $browserUrls = @("http://127.0.0.1:$LocalPort")
  $browserUrls += $LanIPs | ForEach-Object { "http://$($_):$LanPort" }

  $lanWsEndpoints = @()
  if ($VersionInfo.webSocketDebuggerUrl) {
    $browserWsUri = [uri]$VersionInfo.webSocketDebuggerUrl
    $browserWsPath = $browserWsUri.PathAndQuery
    $lanWsEndpoints = $LanIPs | ForEach-Object { "ws://$($_):$LanPort$browserWsPath" }
  }

  $payload = [ordered]@{
    schema_version = 1
    updated_at = (Get-Date).ToString("o")
    local_browser_url = "http://127.0.0.1:$LocalPort"
    lan_browser_urls = @($LanIPs | ForEach-Object { "http://$($_):$LanPort" })
    browser_urls = @($browserUrls | Select-Object -Unique)
    local_ws_endpoint = $VersionInfo.webSocketDebuggerUrl
    lan_ws_endpoints = @($lanWsEndpoints)
    listen_address = $ListenAddress
    firewall_remote_address = $RemoteAddress
    local_port = $LocalPort
    lan_port = $LanPort
    lan_ips = @($LanIPs)
    user_data_dir = $ManagedUserDataDir
    chrome_path = $ManagedChromePath
    browser_version = $VersionInfo.Browser
    protocol_version = $VersionInfo.'Protocol-Version'
  }

  $parent = Split-Path -Parent $Path
  if ($parent) {
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
  }

  $payload | ConvertTo-Json -Depth 6 | Set-Content -Path $Path -Encoding UTF8
}

Require-Admin

$lanIps = Get-ActiveLanIPv4s
if (-not $lanIps) {
  throw "Could not detect an active Windows LAN IPv4 address."
}

Write-Host "==> 0) Current target:"
Write-Host ("   - LAN IPs: " + ($lanIps -join ", "))
Write-Host ("   - Local DevTools: http://127.0.0.1:$DevtoolsLocalPort")
Write-Host ("   - LAN DevTools port: $DevtoolsLanPort")
Write-Host ("   - PortProxy listen address: $PortProxyListenAddress")
Write-Host ("   - Firewall remote address: $FirewallRemoteAddress")

Write-Host "==> 1) Restart managed Chrome (best effort)"
Stop-ManagedChrome -Port $DevtoolsLocalPort -ManagedUserDataDir $UserDataDir

Start-Process -FilePath $ChromePath -ArgumentList @(
  "--remote-debugging-port=$DevtoolsLocalPort",
  "--remote-debugging-address=127.0.0.1",
  "--remote-allow-origins=*",
  "--user-data-dir=$UserDataDir",
  "--no-first-run",
  "--no-default-browser-check",
  "about:blank"
)

Start-Sleep -Seconds 2

Write-Host "==> 2) Clean stale portproxy entries on listenport=$DevtoolsLanPort"
Remove-StalePortProxyEntries -ListenPort $DevtoolsLanPort

& netsh interface portproxy add v4tov4 `
  listenaddress=$PortProxyListenAddress listenport=$DevtoolsLanPort `
  connectaddress=127.0.0.1 connectport=$DevtoolsLocalPort | Out-Null

Write-Host "==> 3) Portproxy current:"
& netsh interface portproxy show all

$ruleName = "Allow-ChromeDevTools-$DevtoolsLanPort"
$legacyRuleNames = @(
  "TEMP-Allow-DevTools-$DevtoolsLanPort-from-VM",
  "Allow-DevTools-$DevtoolsLanPort-from-VM",
  $ruleName
)

Write-Host "==> 4) Recreate firewall rule: $ruleName"
foreach ($legacyName in $legacyRuleNames | Select-Object -Unique) {
  Get-NetFirewallRule -DisplayName $legacyName -ErrorAction SilentlyContinue | Remove-NetFirewallRule | Out-Null
}

New-NetFirewallRule `
  -DisplayName $ruleName `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort $DevtoolsLanPort `
  -RemoteAddress $FirewallRemoteAddress `
  -Action Allow `
  -Profile Any | Out-Null

Write-Host "==> 5) Firewall rule now:"
Get-NetFirewallRule -DisplayName $ruleName | Format-List DisplayName, Enabled, Profile, Direction, Action

Write-Host "==> 6) Health checks"
Write-Host "--- netstat ---"
& netstat -ano | findstr ":$DevtoolsLocalPort"
& netstat -ano | findstr ":$DevtoolsLanPort"

Write-Host "--- local devtools json/version ---"
try {
  $response = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 "http://127.0.0.1:$DevtoolsLocalPort/json/version"
  $versionInfo = $response.Content | ConvertFrom-Json
  Write-Host ("OK local devtools: " + $response.StatusCode)
  Write-Host ("   Browser: " + $versionInfo.Browser)
  Write-Host ("   WebSocket: " + $versionInfo.webSocketDebuggerUrl)
} catch {
  Write-Host "FAILED local devtools. Chrome may not have started correctly." -ForegroundColor Red
  throw
}

Write-Host "==> 7) Write state file"
Write-StateFile `
  -Path $StateFile `
  -VersionInfo $versionInfo `
  -LanIPs $lanIps `
  -LocalPort $DevtoolsLocalPort `
  -LanPort $DevtoolsLanPort `
  -ListenAddress $PortProxyListenAddress `
  -RemoteAddress $FirewallRemoteAddress `
  -ManagedUserDataDir $UserDataDir `
  -ManagedChromePath $ChromePath

Write-Host ("   State file: " + $StateFile)
Write-Host ""
Write-Host "DONE. Preferred browser URLs:"
Write-Host (" - http://127.0.0.1:$DevtoolsLocalPort")
foreach ($lanIp in $lanIps) {
  Write-Host (" - http://$($lanIp):$DevtoolsLanPort")
}

if ($Ephemeral) {
  Write-Host "Ephemeral mode requested: remember to clean portproxy and firewall on shutdown if you do not want the rule to persist." -ForegroundColor Yellow
}
