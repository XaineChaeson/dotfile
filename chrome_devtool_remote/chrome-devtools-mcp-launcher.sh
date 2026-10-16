#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${CODEX_CHROME_STATE_FILE:-/mnt/c/ProgramData/chrome-devtools-mcp/state.json}"
LOCAL_PORT="${CODEX_CHROME_LOCAL_PORT:-9222}"
LOG_FILE="${CODEX_CHROME_MCP_LOG_FILE:-/tmp/chrome-devtools-mcp-codex.log}"
NODE_BIN="${CODEX_CHROME_MCP_NODE:-node}"

find_mcp_entry() {
  if [[ -n "${CODEX_CHROME_MCP_ENTRY:-}" ]]; then
    printf '%s\n' "$CODEX_CHROME_MCP_ENTRY"
    return 0
  fi

  local entry=""
  if [[ -d "$HOME/.npm/_npx" ]]; then
    entry="$(
      find "$HOME/.npm/_npx" -path '*/node_modules/chrome-devtools-mcp/build/src/index.js' -printf '%T@ %p\n' 2>/dev/null |
        sort -nr |
        awk 'NR == 1 { $1 = ""; sub(/^ /, ""); print; exit }'
    )"
  fi

  if [[ -z "$entry" ]]; then
    printf 'Could not locate chrome-devtools-mcp entrypoint under %s/.npm/_npx\n' "$HOME" >&2
    return 1
  fi

  printf '%s\n' "$entry"
}

read_state_urls() {
  local state_path="$1"
  if [[ ! -f "$state_path" ]]; then
    return 0
  fi

  python3 - "$state_path" <<'PY'
import json
import pathlib
import sys

state_path = pathlib.Path(sys.argv[1])
try:
    data = json.loads(state_path.read_text(encoding="utf-8-sig"))
except Exception:
    sys.exit(0)

urls = []
for key in ("browser_urls", "lan_browser_urls"):
    value = data.get(key)
    if isinstance(value, list):
        for item in value:
            if isinstance(item, str) and item:
                urls.append(item)

local_url = data.get("local_browser_url")
if isinstance(local_url, str) and local_url:
    urls.insert(0, local_url)

seen = set()
for url in urls:
    if url in seen:
      continue
    seen.add(url)
    print(url)
PY
}

resolve_ws_endpoint() {
  local browser_url="$1"

  python3 - "$browser_url" <<'PY'
import json
import sys
import urllib.parse
import urllib.request


def is_loopback(hostname: str | None) -> bool:
    if not hostname:
        return False
    host = hostname.strip("[]").lower()
    return host == "localhost" or host == "::1" or host.startswith("127.")


browser_url = sys.argv[1].rstrip("/") + "/"
version_url = urllib.parse.urljoin(browser_url, "json/version")
with urllib.request.urlopen(version_url, timeout=2) as response:
    payload = json.load(response)

ws_endpoint = payload["webSocketDebuggerUrl"]
browser_parts = urllib.parse.urlparse(browser_url)
ws_parts = urllib.parse.urlparse(ws_endpoint)

should_rewrite = (
    is_loopback(ws_parts.hostname)
    and bool(browser_parts.hostname)
    and (
        not is_loopback(browser_parts.hostname)
        or (browser_parts.port and ws_parts.port and browser_parts.port != ws_parts.port)
    )
)

if should_rewrite:
    host = browser_parts.hostname or ""
    if ":" in host and not host.startswith("["):
        host = f"[{host}]"
    if browser_parts.port:
        host = f"{host}:{browser_parts.port}"
    scheme = "wss" if browser_parts.scheme == "https" else "ws"
    ws_endpoint = urllib.parse.urlunparse(
        (
            scheme,
            host,
            ws_parts.path,
            ws_parts.params,
            ws_parts.query,
            ws_parts.fragment,
        )
    )

print(ws_endpoint)
PY
}

declare -a CANDIDATE_URLS=()

add_candidate_url() {
  local url="$1"
  if [[ -z "$url" ]]; then
    return 0
  fi

  for existing in "${CANDIDATE_URLS[@]:-}"; do
    if [[ "$existing" == "$url" ]]; then
      return 0
    fi
  done

  CANDIDATE_URLS+=("$url")
}

if [[ -n "${CODEX_CHROME_BROWSER_URL:-}" ]]; then
  add_candidate_url "$CODEX_CHROME_BROWSER_URL"
fi

if [[ -n "${CODEX_CHROME_BROWSER_URLS:-}" ]]; then
  IFS=',' read -r -a EXTRA_BROWSER_URLS <<<"$CODEX_CHROME_BROWSER_URLS"
  for raw_url in "${EXTRA_BROWSER_URLS[@]}"; do
    trimmed_url="${raw_url#"${raw_url%%[![:space:]]*}"}"
    trimmed_url="${trimmed_url%"${trimmed_url##*[![:space:]]}"}"
    add_candidate_url "$trimmed_url"
  done
fi

while IFS= read -r state_url; do
  add_candidate_url "$state_url"
done < <(read_state_urls "$STATE_FILE")

add_candidate_url "http://127.0.0.1:${LOCAL_PORT}"

chosen_ws_endpoint="${CODEX_CHROME_WS_ENDPOINT:-}"
chosen_source="${CODEX_CHROME_WS_ENDPOINT:+env:CODEX_CHROME_WS_ENDPOINT}"

if [[ -z "$chosen_ws_endpoint" ]]; then
  for browser_url in "${CANDIDATE_URLS[@]}"; do
    if resolved_ws="$(resolve_ws_endpoint "$browser_url" 2>/dev/null)"; then
      chosen_ws_endpoint="$resolved_ws"
      chosen_source="$browser_url"
      break
    fi
  done
fi

if [[ -z "$chosen_ws_endpoint" ]]; then
  {
    echo "Could not resolve a reachable Chrome DevTools endpoint."
    echo "Checked browser URLs:"
    for browser_url in "${CANDIDATE_URLS[@]}"; do
      echo " - $browser_url"
    done
    echo "State file: $STATE_FILE"
  } >&2
  exit 1
fi

MCP_ENTRY="$(find_mcp_entry)"
echo "[chrome-devtools-mcp-launcher] using $chosen_source -> $chosen_ws_endpoint" >&2
exec "$NODE_BIN" "$MCP_ENTRY" "--wsEndpoint=$chosen_ws_endpoint" "--no-usage-statistics" "--logFile" "$LOG_FILE" "$@"
