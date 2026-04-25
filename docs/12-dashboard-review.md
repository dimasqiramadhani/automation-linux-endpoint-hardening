# 12 — Dashboard Review

## Navigating SCA Results

```
Wazuh Dashboard
  → Endpoint Security
    → Configuration Assessment
      → Select agent: ubuntu-lab-01
        → Select policy: CIS Ubuntu Linux 24.04 LTS Benchmark
```

Review:
- **Score %** and trend
- **Passed / Failed / Not Applicable** counts
- **Per-check detail** — expand any check for rationale, remediation, compliance

---

## Dashboard Filters for Hardening Review

| Filter | Purpose |
|--------|---------|
| `rule.groups:sca` | All SCA events |
| `decoder.name:sca` | SCA decoder events |
| `data.sca.check.result:failed` | Currently failing checks |
| `data.sca.check.result:passed` | Currently passing checks |
| `data.sca.check.previous_result:failed` | Status changed events |
| `data.sca.check.title:*redirect*` | Redirect-related checks |
| `data.sca.check.title:*dev/shm*` | /dev/shm checks |
| `agent.name:ubuntu-lab-01` | Specific endpoint |

---

## What to Look For

### Status Changed Events (Most Important)

Filter: `data.sca.check.previous_result:failed`

These events confirm that:
1. A check was previously failing
2. The hardening script applied the fix
3. SCA re-scan detected the improvement
4. The compliance evidence trail is established

### Per-Check Detail Fields

| Field | Description |
|-------|-------------|
| `data.sca.check.title` | Check name |
| `data.sca.check.result` | Current: passed/failed |
| `data.sca.check.previous_result` | Previous result |
| `data.sca.check.rationale` | Why this matters |
| `data.sca.check.remediation` | How to fix (or what was fixed) |
| `data.sca.check.compliance` | Framework references |
