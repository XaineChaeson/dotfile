param(
  [string]$WinLanIP = "192.168.5.120",
  [string]$VmIP = "192.168.5.220",
  [int]$DevtoolsLocalPort = 9222,
  [int]$DevtoolsLanPort = 9223,
  [switch]$Ephemeral  # 加上 -Ephemeral 会启用“本次开机有效”的配套清理建议（见文末）
)

$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$UserDataDir = "$env:TEMP\chrome-mcp-test"

function Require-Admin {
  $id = [Security.Principal.WindowsIdentity]::GetCurrent()
  $p  = New-Object Security.Principal.WindowsPrincipal($id)
  if (-not $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Please run this script in an elevated (Administrator) PowerShell."
  }
}

Require-Admin

Write-Host "==> 0) Current target: WIN=$WinLanIP  VM=$VmIP  LANPORT=$DevtoolsLanPort  LOCALPORT=$DevtoolsLocalPort"

# -------------------------
# 1) Start Chrome (DevTools on localhost only)
# -------------------------
Write-Host "==> 1) Restart Chrome (best effort)"
Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Start-Process -FilePath $ChromePath -ArgumentList @(
  "--remote-debugging-port=$DevtoolsLocalPort",
  "--remote-debugging-address=127.0.0.1",
  "--user-data-dir=$UserDataDir"
)

Start-Sleep -Seconds 2

# -------------------------
# 2) Clean stale portproxy entries for the same listenport (9223), then add the desired one
# -------------------------
Write-Host "==> 2) Clean stale portproxy entries on listenport=$DevtoolsLanPort"
$raw = & netsh interface portproxy show v4tov4
# Parse lines like: "192.168.5.251   9223        127.0.0.1       9222"
$lines = $raw | Where-Object { $_ -match '^\s*\d+\.\d+\.\d+\.\d+\s+\d+\s+\d+\.\d+\.\d+\.\d+\s+\d+\s*$' }

foreach ($ln in $lines) {
  $parts = ($ln -split '\s+') | Where-Object { $_ -ne "" }
  $listenAddr = $parts[0]
  $listenPort = [int]$parts[1]
  if ($listenPort -eq $DevtoolsLanPort -and $listenAddr -ne $WinLanIP) {
    Write-Host "   - delete stale portproxy: $listenAddr`:$listenPort"
    & netsh interface portproxy delete v4tov4 listenaddress=$listenAddr listenport=$listenPort | Out-Null
  }
}

# Ensure desired mapping exists (replace if present)
& netsh interface portproxy delete v4tov4 listenaddress=$WinLanIP listenport=$DevtoolsLanPort | Out-Null
& netsh interface portproxy add v4tov4 `
  listenaddress=$WinLanIP listenport=$DevtoolsLanPort `
  connectaddress=127.0.0.1 connectport=$DevtoolsLocalPort | Out-Null

Write-Host "==> 3) Portproxy current:"
& netsh interface portproxy show all

# -------------------------
# 3) Firewall rules: keep only ONE canonical rule, remove TEMP/duplicates, then recreate cleanly
# -------------------------
$RuleName = "Allow-DevTools-$DevtoolsLanPort-from-VM"

Write-Host "==> 4) Clean firewall duplicates (TEMP/old) and recreate canonical rule: $RuleName"

# Remove old duplicates we know about (TEMP + previous canonical variants)
$toRemove = @(
  "TEMP-Allow-DevTools-$DevtoolsLanPort-from-VM",
  "Allow-DevTools-$DevtoolsLanPort-from-VM"
)
foreach ($rn in $toRemove) {
  Get-NetFirewallRule -DisplayName $rn -ErrorAction SilentlyContinue | Remove-NetFirewallRule | Out-Null
}

# Create canonical allow rule: only VM IP -> local port 9223
New-NetFirewallRule `
  -DisplayName $RuleName `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort $DevtoolsLanPort `
  -RemoteAddress $VmIP `
  -Action Allow `
  -Profile Any | Out-Null

Write-Host "==> 5) Firewall rule now:"
Get-NetFirewallRule -DisplayName $RuleName | Format-List DisplayName,Enabled,Profile,Direction,Action

# -------------------------
# 4) Health checks
# -------------------------
Write-Host "==> 6) Health checks"
Write-Host "--- netstat ---"
& netstat -ano | findstr $DevtoolsLocalPort
& netstat -ano | findstr $DevtoolsLanPort

Write-Host "--- local devtools json/version ---"
try {
  $resp = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 "http://127.0.0.1:$DevtoolsLocalPort/json/version"
  Write-Host ("OK local devtools: " + $resp.StatusCode)
} catch {
  Write-Host "FAILED local devtools. Chrome may not have started correctly." -ForegroundColor Red
  throw
}

Write-Host ""
Write-Host "DONE. Ubuntu should use: http://$WinLanIP`:$DevtoolsLanPort/json/version"
if ($Ephemeral) {
  Write-Host "Ephemeral mode requested: see the runbook section on Shutdown cleanup task." -ForegroundColor Yellow
}
