# Chrome DevTools MCP Runbook
**适用架构：Ubuntu VM（无浏览器）+ Windows Chrome + Codex MCP**

---

## 0. 目标与原则

**目标**
- 在 **Ubuntu VM** 上运行 Codex
- 通过 **Chrome DevTools MCP** 远程控制 **Windows 主机上的 Chrome**
- Ubuntu 上不安装浏览器或 GUI
- 网络、代理、配置 **可诊断、可复原、可清理**

**设计原则**
- Chrome 仅监听 `127.0.0.1`（最小暴露）
- Windows 用 `portproxy` 精确转发到 LAN
- 防火墙只放行 **Ubuntu VM IP**
- Ubuntu 内网控制流量 **不走代理**
- 所有状态都可以通过脚本/命令检查

---

## 1. 架构总览（逻辑）

```
Ubuntu VM (192.168.5.220)
├─ Codex
├─ chrome-devtools MCP (npx)
└─ HTTP / WebSocket (CDP)
   ↓
Windows LAN IP (192.168.5.120:9223)
├─ portproxy
└─ 127.0.0.1:9222
   └─ Chrome (remote debugging)
```

---

## 2. 固定参数（示例）

| 项目 | 值 |
|---|---|
| Ubuntu VM IP | `192.168.5.220` |
| Windows LAN IP | `192.168.5.120` |
| Chrome DevTools 本地端口 | `9222` |
| Windows 对外端口 | `9223` |
| Ubuntu → Windows 访问 | `http://192.168.5.120:9223` |

---

## 3. 启动顺序（标准流程）

### Step 1：代理健康（NAS / 代理机）
> **这是最容易被忽略，也是最常见根因**

```bash
curl -x http://127.0.0.1:20171 https://www.google.com -I
```

- 返回 200/301 → 代理真实可用
- RST / refused → 代理内核未启动（先修这个）

### Step 2：Windows 启动 Chrome（DevTools）

```powershell
chrome.exe ^
  --remote-debugging-port=9222 ^
  --remote-debugging-address=127.0.0.1 ^
  --user-data-dir=%TEMP%\chrome-mcp-test
```

校验（Windows 本机）：

```
http://127.0.0.1:9222/json/version
```

### Step 3：Windows 端口转发（portproxy）

```powershell
netsh interface portproxy add v4tov4 `
  listenaddress=192.168.5.120 listenport=9223 `
  connectaddress=127.0.0.1 connectport=9222
```

校验：

```powershell
netsh interface portproxy show all
```

期望：

```
192.168.5.120  9223  127.0.0.1  9222
```

### Step 4：Windows 防火墙（只放行 VM）

```powershell
New-NetFirewallRule `
  -DisplayName "Allow-DevTools-9223-from-VM" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 9223 `
  -RemoteAddress 192.168.5.220 `
  -Action Allow
```

### Step 5：Ubuntu VM 连通性验证（必须直连，不走代理）

```bash
curl --noproxy "*" http://192.168.5.120:9223/json/version
```

- 返回 JSON（含 `webSocketDebuggerUrl`）→ 链路 OK
- 卡住/超时 → Windows 防火墙或 portproxy

### Step 6：启动 Codex（隔离内网流量）

```bash
unset ALL_PROXY all_proxy
codex
```

在 Codex 中：

```bash
/mcp
```

应看到 chrome-devtools tools 列表。

---

## 4. Codex MCP 配置（最终态）

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = [
  "-y",
  "chrome-devtools-mcp@latest",
  "--browser-url=http://192.168.5.120:9223"
]
```

---

## 5. 三个“金标准”验收点

- Windows 本机：`http://127.0.0.1:9222/json/version` 可访问
- Ubuntu VM：`curl --noproxy "*" http://192.168.5.120:9223/json/version` 返回 JSON
- Codex：`/mcp` 显示 chrome-devtools；`new_page` / `navigate_page` / `take_screenshot` 可用

---

## 6. 常见故障速查（定位一眼准）

### A. Ubuntu → 9223 卡住
- Windows 防火墙规则丢失 / Profile 变化
- portproxy 指向错误 IP

```powershell
netsh interface portproxy show all
Get-NetFirewallRule | findstr 9223
```

### B. Ubuntu → 20171 connection refused
- 代理内核未启动（v2rayA/xray）
- UI 打开 ≠ 代理可用

```bash
curl -x http://127.0.0.1:20171 https://www.google.com -I
```

### C. Codex 工具存在，但调用浏览器动作卡
- Ubuntu 会话里 `ALL_PROXY` / `all_proxy` 影响内网 WebSocket

```bash
unset ALL_PROXY all_proxy
codex
```

### D. Chrome 被关 / 崩溃
- MCP 不会自动拉起 Chrome
- 表现为：工具在，但调用超时

解决：
- 重启 Chrome
- 重启 Codex（让 MCP 重连）

---

## 7. 配置清洁策略（强烈推荐）

**推荐做法**：每次开机运行 Windows 启动脚本
- 启动 Chrome
- 清理旧 portproxy
- 重建防火墙规则
- 不依赖历史状态

**原因**
- Windows 不会自动清理旧 IP 的 portproxy
- 防火墙“临时规则”很容易遗留
- 干净状态 = 可预测

---

## 8. 能否从 Ubuntu 远程“启动 Chrome”？

**不能**直接通过 DevTools / MCP。

原因：DevTools / CDP 只负责控制 **已运行** 的 Chrome，不负责进程生命周期。

**推荐方案**
- Windows 任务计划：开机自启 Chrome（推荐）
- Windows 启动脚本（手动/自动）
- 远程执行（WinRM / SSH / schtasks）

---

## 9. 最小自检清单（0 秒版）

- 代理 `curl -x 127.0.0.1:20171` 正常
- Chrome 正在跑（`9222` LISTEN）
- portproxy 正确：`9223 → 9222`
- 防火墙只放行 VM IP
- Ubuntu `curl --noproxy "*" :9223/json/version` OK
- Codex `/mcp` 工具可用

---

## 10. 一句话总结

Chrome DevTools MCP 的稳定性 = 代理活着 × Chrome 在跑 × 内网直连 × 配置可清
