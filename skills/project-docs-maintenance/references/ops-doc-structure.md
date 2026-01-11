# Ops Documentation Structure

Use this to choose an ops doc layout by project complexity.

## Quick scope check
- Services: 1 (S), 2-4 (M), 5+ (L)
- Runtimes: 1 (S), 2 (M), 3+ (L)
- Environments: 1 (S), 2 (M), 3+ (L)
- On-call load: occasional (S), weekly (M), daily/24x7 (L)
- Operational procedures: <=3 (S), 4-7 (M), 8+ (L)

## S (small) layout
- docs/ops/README.md
- docs/ops/runbook.md
- docs/ops/troubleshooting.md
- Optional: docs/ops/alerts.md

## M (medium) layout
- S layout, plus:
- docs/ops/handoff.md
- docs/ops/alerts.md
- docs/ops/envs.md
- docs/ops/runbooks/<procedure>.md
- docs/ops/checklists/<procedure>.md

## L (large) layout
- M layout, plus:
- docs/ops/runbooks/<service-or-domain>/<procedure>.md
- docs/ops/checklists/<service-or-domain>/<procedure>.md
- docs/ops/ownership.md
- Optional: docs/ops/incidents/ or docs/ops/incident-notes.md

## Split rules
- Split runbooks/ when procedures diverge by service, runtime, or environment.
- Split checklists/ when steps differ by risk tier or deployment strategy.
- Add alerts.md when you have multiple dashboards or >5 alerts.
- Add envs.md when defaults, limits, or feature flags differ by environment.
- Add ownership.md when on-call rotation, escalation paths, or paging rules exist.

## Boundaries
- runbook.md: how to operate, deploy, recover.
- troubleshooting.md: how to diagnose and mitigate.
- handoff.md: shift change and readiness.
- alerts.md: metrics, thresholds, dashboards.
