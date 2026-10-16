# Chrome DevTools MCP Runbook
**适用架构：WSL / Ubuntu + Windows Chrome + Codex MCP**

---

## 0. 目标与最终形态

**目标**
- WSL / Ubuntu 中运行 Codex
- 实际浏览器固定使用 Windows 主机上的 Chrome
- 不再按机器手改 Windows IP、WSL IP、MCP `browserUrl`
- 同一套配置可在多台机器复用

**最终形态**
- Windows 用 `start-devtools.ps1` 启动一个专用 Chrome DevTools 实例
- Chrome 只监听 `127.0.0.1:9222`
- Windows 用 `portproxy` 把 `9223` 暴露到局域网
- 脚本自动写出状态文件：`C:\ProgramData\chrome-devtools-mcp\state.json`
- Codex MCP 不再直连 `--browserUrl=...`
- Codex 改为调用本地 wrapper，由 wrapper 自动读取状态并生成正确的 `--wsEndpoint`

---

## 1. 为什么不再把 `browserUrl` 写死到 `config.toml`

直接在 `config.toml` 里写死某台机器的：

```text
http://192.168.x.x:9223
```

有两个长期问题：

- 每台机器的 Windows LAN IP 都不同，必须手改
- 同一台机器里，WSL 本地最稳的入口通常是 `http://127.0.0.1:9222`

另外，`/json/version` 返回的 `webSocketDebuggerUrl` 在不同链路上可能是：

- 当前 LAN Host
- `127.0.0.1`
- 或其他 loopback 形式

所以长期方案改成：

- Windows 侧统一暴露固定端口并写状态文件
- WSL 侧 wrapper 自动读取状态文件和本地回退入口
- 如果拿到的是 loopback websocket，就按当前入口地址改写成可达的 `wsEndpoint`
- 最终把 `--wsEndpoint=...` 传给 `chrome-devtools-mcp`

---

## 2. 固定端口与约定

| 项目 | 默认值 |
|---|---|
| Chrome DevTools 本地端口 | `9222` |
| Windows 对外端口 | `9223` |
| Windows 状态文件 | `C:\ProgramData\chrome-devtools-mcp\state.json` |
| WSL 状态文件路径 | `/mnt/c/ProgramData/chrome-devtools-mcp/state.json` |
| Chrome 用户目录 | `%TEMP%\chrome-mcp-test` |

说明：
- `9222` 仅供 Windows 本机 / WSL 本机链路使用
- `9223` 供局域网入口使用
- 防火墙默认放行 `LocalSubnet`

---

## 3. Windows 启动脚本职责

`start-devtools.ps1` 现在负责：

1. 停掉之前由该脚本拉起的受管 Chrome 实例
2. 用以下关键参数重启 Chrome

```powershell
--remote-debugging-port=9222
--remote-debugging-address=127.0.0.1
--remote-allow-origins=*
--user-data-dir=%TEMP%\chrome-mcp-test
```

3. 清理旧的 `9223` portproxy
4. 重建统一规则：`0.0.0.0:9223 -> 127.0.0.1:9222`
5. 重建 Windows 防火墙规则：`Allow-ChromeDevTools-9223`
6. 自动探测当前 Windows 活跃 LAN IP
7. 写入状态文件，供 WSL wrapper 读取

---

## 4. Windows 状态文件内容

状态文件示例：

```json
{
  "schema_version": 1,
  "local_browser_url": "http://127.0.0.1:9222",
  "lan_browser_urls": [
    "http://192.168.5.120:9223"
  ],
  "browser_urls": [
    "http://127.0.0.1:9222",
    "http://192.168.5.120:9223"
  ],
  "local_ws_endpoint": "ws://127.0.0.1:9222/devtools/browser/...",
  "listen_address": "0.0.0.0",
  "firewall_remote_address": "LocalSubnet"
}
```

这份文件的作用是：
- 让 WSL 知道“这台 Windows 当前暴露了哪些入口”
- 避免在每台机器里手工写 `192.168.x.x`
- 让 Chrome 重启后新的 browser id 也能被重新发现

---

## 5. Codex MCP 长期配置

### 5.1 wrapper 路径

建议把 wrapper 部署到：

```bash
~/.codex/bin/chrome-devtools-mcp-launcher.sh
```

### 5.2 `~/.codex/config.toml`

```toml
[mcp_servers.chrome-devtools]
command = "/home/<user>/.codex/bin/chrome-devtools-mcp-launcher.sh"
args = []
```

说明：
- 不再把 `browserUrl` 写死到 `config.toml`
- wrapper 会优先读取环境变量，再读取 Windows 状态文件，最后回退到 `http://127.0.0.1:9222`
- wrapper 最终传的是 `--wsEndpoint`

---

## 6. wrapper 的解析顺序

wrapper 按以下顺序找 Chrome：

1. `CODEX_CHROME_WS_ENDPOINT`
2. `CODEX_CHROME_BROWSER_URL`
3. `CODEX_CHROME_BROWSER_URLS`
4. Windows 状态文件中的 `browser_urls`
5. `http://127.0.0.1:9222`

并且会做一件关键事：

- 如果 `/json/version` 返回的 `webSocketDebuggerUrl` 是 `127.0.0.1`
- 但当前入口不是 loopback
- wrapper 会把 websocket host/port 改写成当前入口的 host/port

这样局域网入口 `http://host:9223` 才能真正用于 MCP。

---

## 7. 标准使用流程

### Step 1：Windows 管理员 PowerShell 执行

```powershell
D:\python\start-devtools.ps1
```

### Step 2：WSL 中检查状态文件

```bash
python3 - <<'PY'
import json
from pathlib import Path

path = Path("/mnt/c/ProgramData/chrome-devtools-mcp/state.json")
print(json.loads(path.read_text(encoding="utf-8-sig")))
PY
```

### Step 3：重启 Codex

`chrome-devtools` MCP 的配置在 Codex 启动时加载。  
所以修改 `~/.codex/config.toml` 或 wrapper 后，需要重启 Codex 会话。

---

## 8. 验收标准

### Windows 本机

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:9222/json/version
```

### WSL 本机

```bash
curl -sS http://127.0.0.1:9222/json/version
```

### 局域网入口

从其他机器访问：

```bash
curl -sS http://<windows-lan-ip>:9223/json/version
```

### Codex

- `/mcp` 能看到 `chrome-devtools`
- `list_pages` 成功
- `new_page` 成功
- `take_snapshot` 成功

---

## 9. 常见故障

### A. `list_pages` / `new_page` 超时，HTTP 却正常

高概率是 Chrome 没带：

```text
--remote-allow-origins=*
```

或者 MCP 仍在走旧的 `--browserUrl` 配置。

### B. WSL 能访问 `127.0.0.1:9222`，但局域网机器不通 `9223`

优先检查：

```powershell
netsh interface portproxy show all
Get-NetFirewallRule -DisplayName "Allow-ChromeDevTools-9223"
```

### C. 改了 `config.toml`，当前会话还是旧行为

Codex 需要重启，MCP 服务不会热更新。

### D. 启动脚本把普通 Chrome 也关了

新脚本只会结束带 DevTools 标记或指定 `user-data-dir` 的受管实例，不会再全杀所有 Chrome。

---

## 10. 一句话总结

长期稳定方案不是“把 `browserUrl` 改成某台机器的 IP”，而是：

**Windows 统一暴露 Chrome DevTools，WSL wrapper 动态解析并改写为正确的 `wsEndpoint`。**
