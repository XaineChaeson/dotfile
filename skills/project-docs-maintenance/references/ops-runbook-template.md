# Ops Runbook

Use this for operational procedures and incident response.

## Service overview
- What the service does and critical dependencies.

## Startup and shutdown
### Inputs
- Runtime: <systemd|docker|k8s|binary>
- Artifact: <unit name|image|manifest|binary path>
- Config: <path/env/secret store>
- Health check: <url/command>
- Dependencies: <db/cache/queue/etc>

### Preflight
- [ ] Config and secrets present
- [ ] Dependencies reachable
- [ ] Ports and resources available
- [ ] Permissions and network policies OK

### Start
- If Runtime=systemd: <systemctl start ...>
- If Runtime=docker: <docker compose up ...> or <docker run ...>
- If Runtime=k8s: <kubectl apply ...> and <kubectl rollout status ...>
- If Runtime=binary: <./service --config ...>
- Remove unused branches.

### Verify
- Health check returns expected status
- Logs show "ready" marker
- Key metrics within expected range
- Smoke request succeeds

### Stop
- Stop traffic intake / drain connections
- Flush buffers/queues
- Stop process

### Verify stop
- Process gone, port closed
- Queues drained
- No new errors

### Failure handling
- Roll back to last known good artifact
- Clear partial resources
- Escalate if repeated failure

## Health checks
- Readiness and liveness checks.
- Key indicators.

## Monitoring and alerts
- Primary metrics and alert thresholds.

## Common incidents
### <incident type>
- Symptoms:
- Likely causes:
- Immediate actions:
- Escalation path:

## Backup and recovery
- Backup strategy.
- Restore procedure.

## Deployment and rollback
- Deploy steps.
- Rollback steps.

## Related docs
- Links to architecture, configs, and troubleshooting.
