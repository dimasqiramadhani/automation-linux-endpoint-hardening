# 16 — Improvement Ideas

## Priority Roadmap

| Priority | Improvement | Effort | Impact |
|----------|-------------|--------|--------|
| High | Centralized config for 50+ endpoints via agent group | Low | High |
| High | Extend scope: SSH hardening, auditd, password policy | Medium | High |
| High | Automated drift alerting when SCA score drops | Medium | High |
| Medium | Ansible integration for orchestrated hardening | High | High |
| Medium | Compliance score trend dashboard (Grafana) | Medium | Medium |
| Low | GitHub Actions — YAML lint for SCA policies | Low | Medium |
| Low | Jira/ticketing automation for failed checks | High | Medium |

---

## 1. Agent Group Centralization

Deploy the Command Module config and hardening script to all Ubuntu servers via a Wazuh agent group:

```bash
# Create group
sudo /var/ossec/bin/agent_groups -a -g ubuntu_hardening

# Add agents
sudo /var/ossec/bin/agent_groups -a -i <agent_id> -g ubuntu_hardening

# Deploy config
cp wazuh/centralized-agent-config-snippet.xml \
   /var/ossec/etc/shared/ubuntu_hardening/agent.conf
```

---

## 2. Extended Hardening Scope

Additional controls to add in future phases:

| Phase | Controls |
|-------|---------|
| Phase 2 | SSH: PermitRootLogin no, MaxAuthTries 4, ClientAlive |
| Phase 3 | auditd rules for privileged command logging |
| Phase 4 | PAM password policy: minlen, complexity, history |
| Phase 5 | World-writable file scan and report |
| Phase 6 | SUID/SGID binary review |

---

## 3. SCA Score Drop Alerting

Create a custom Wazuh rule that fires when the SCA score decreases:
- Alert level: 8 (score drop detected)
- Trigger: `data.sca.score` current < `data.sca.score` previous
- Action: Notify SOC; trigger dry-run verification

---

## 4. OpenSCAP Comparison

Run OpenSCAP alongside Wazuh SCA to cross-validate findings:

```bash
sudo apt install openscap-scanner
oscap oval eval --report openscap-report.html cis-ubuntu24.oval.xml
```

Compare OpenSCAP findings with Wazuh SCA results to identify gaps in coverage.

---

## 5. Approval Workflow Before Remediation

In production, the Command Module should not apply changes automatically without approval:

```
SCA scan → failed checks identified
         → Jira ticket created per check
         → Change request approval
         → Approved ticket → trigger remediation
         → Validation scan → close ticket
```

This workflow transforms the lab automation into a production-grade change-managed hardening pipeline.
