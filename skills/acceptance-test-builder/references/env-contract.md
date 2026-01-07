# Environment Contract

## Required Inputs

- Environment name (dev/staging/prod):
- Base URL / RPC / API endpoint:
- Account credentials or auth method:
- Required headers or API tokens:
- Network access requirements:
- Any whitelisted IPs or rate limits:

## Secrets Handling

Provide secrets using one of these:
- Environment variables
- Prompt input during run
- Redacted values with a secure handoff mechanism

Never hardcode secrets into scripts.

## Config JSON Example

```json
{
  "ENV_NAME": "staging",
  "BASE_URL": "https://example.test",
  "RPC_URL": "https://rpc.example.test",
  "API_TOKEN": "<token>",
  "USERNAME": "<user>",
  "PASSWORD": "<password>"
}
```

## Optional Inputs

- Feature flags:
- Debug logging toggles:
- Dry-run or no-op modes:
- Mock/sandbox endpoints:

## Permissions Checklist

- Read-only actions allowed:
- Write actions allowed:
- Funds or balances available for transactions:
- UI login allowed:

## Contact for Access Issues

- Owner:
- Channel:
