# 05 — Wazuh SCA and CIS Benchmark

## Wazuh Security Configuration Assessment

Wazuh SCA is a built-in module that evaluates endpoint configuration against a defined policy. Each policy contains checks written in YAML format that test file content, command output, process state, registry keys (Windows), or mount options.

### How SCA Works

```
[1] Wazuh Agent reads the SCA policy file at scan interval
[2] Each check evaluates a specific configuration condition
[3] Result: passed / failed / not_applicable
[4] SCA summary (score, counts) sent to Manager
[5] Status change events generated when result differs from previous scan
[6] Analyst reviews in Dashboard under Configuration Assessment
```

---

## CIS Ubuntu Linux 24.04 Benchmark

The **CIS (Center for Internet Security) Benchmark** for Ubuntu Linux provides detailed, prescriptive configuration guidance across multiple security domains. Wazuh ships with a built-in SCA policy that aligns with this benchmark.

| Domain | Example Checks |
|--------|---------------|
| Filesystem Configuration | /dev/shm mount options, /tmp restrictions |
| Network Configuration | IP forwarding, ICMP redirects, source routing |
| Logging and Auditing | auditd installation, log retention |
| Access, Authentication | SSH configuration, root login, password policy |
| System Maintenance | SUID/SGID files, world-writable files |

---

## Reading SCA Results

| Result | Meaning | Action |
|--------|---------|--------|
| `passed` | Configuration meets the check condition | Document as compliant |
| `failed` | Configuration does not meet the condition | Assess risk; remediate if safe |
| `not_applicable` | Check not relevant for this system | Review relevance |

---

## SCA Score Interpretation

The SCA score is:
```
score = (passed_checks / (total_checks - not_applicable_checks)) * 100
```

**Important caveats:**
- SCA score is a posture indicator, not a security guarantee
- A high score means configurations match the benchmark, not that the system is unbreachable
- Some failed checks may not be exploitable in context
- Some passed checks may have compensating controls bypassed by application-level issues

---

## Status Change Events

When a check changes between scans (e.g., failed → passed), Wazuh generates a **status changed** event with:
- `data.sca.check.previous_result: failed`
- `data.sca.check.result: passed`
- Full check detail (title, rationale, remediation, compliance)

These events are the primary compliance evidence that remediation was effective.
