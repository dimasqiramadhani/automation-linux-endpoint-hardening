# 15 — Security Considerations

## 1. Hardening Impact on System Behavior

Some hardening controls affect network behavior at the kernel level. Before applying:

| Control | Potential Impact |
|---------|----------------|
| Disable IP forwarding | Breaks routing if this machine acts as a gateway |
| Disable ICMP redirects | May affect path optimization in complex networks |
| /dev/shm noexec | Breaks applications that execute code from shared memory |

**Always test in an isolated lab environment first.**

---

## 2. Change Control

Even in lab environments, documenting changes builds good habits:
- Record what was changed, when, by whom
- Record the original value (backup file provides this)
- Record the expected outcome and the validation result
- Record the rollback plan and rollback test result

In production: formal change request, system owner approval, maintenance window, and rollback rehearsal are all mandatory.

---

## 3. Automation Risk

The Wazuh Command Module runs the script automatically with elevated privileges. Risks:

| Risk | Mitigation |
|------|-----------|
| Script bug causes outage | Test thoroughly; use dry-run first |
| Script modifies unintended files | Limit scope; validate in code review |
| Script runs too frequently | Set conservative interval (12h minimum) |
| Script is tampered with | Strict permissions: root:wazuh 750 |

---

## 4. Script Permission Security

The hardening script must be owned and controlled by root:

```bash
chown root:wazuh /var/ossec/active-response/bin/linux_hardening.sh
chmod 750 /var/ossec/active-response/bin/linux_hardening.sh
```

- `root` owns the file — only root can modify it
- `wazuh` group can read and execute — needed for the agent to run it
- Others have no access — prevents unauthorized modification

---

## 5. SCA Score Limitations

A higher SCA score means closer alignment to the CIS benchmark — not that the system is fully secure:
- Some failed checks may have negligible risk in your specific context
- Some passed checks may have other bypass paths
- SCA is one input to a security program, not the complete picture

---

## 6. Production Readiness

This project is a PoC / lab exercise. Production deployment requires:

| Requirement | Detail |
|-------------|--------|
| Application testing | Verify workloads still function after each control |
| System owner approval | Documented sign-off |
| Security team review | Risk assessment per control |
| Change management | Approved change ticket |
| Maintenance window | Scheduled downtime if reboot required |
| Post-change monitoring | Watch for alerts after hardening |
