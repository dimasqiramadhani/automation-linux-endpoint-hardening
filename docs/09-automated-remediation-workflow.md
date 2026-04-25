# 09 — Automated Remediation Workflow

## Workflow Summary

```
systemd starts wazuh-agent
        ↓
Command Module fires (run_on_start: yes)
        ↓
linux_hardening.sh runs as root
        ↓
For each control:
  - Check current state
  - If already compliant → log "already compliant" → skip
  - If not compliant → apply change → log "changed"
        ↓
Write all sysctl changes to /etc/sysctl.d/99-wazuh-hardening.conf
        ↓
sysctl --system (apply immediately)
        ↓
Check /dev/shm mount options → update /etc/fstab if needed
        ↓
Print summary: N changed, N already compliant, N failed
        ↓
[Every 12 hours — interval fires again]
        ↓
Same script runs → if drift occurred, re-applies the setting
```

---

## Configuration Drift Correction

One of the most valuable aspects of scheduled Command Module execution is **automatic drift correction**:

If a sysctl setting is manually changed or reverted by a package update, the next Command Module interval will detect the drift and re-apply the correct value — without any analyst intervention.

```bash
# Example: someone manually reverts IP forwarding
sysctl -w net.ipv4.ip_forward=1

# 12 hours later, Command Module runs
# Script detects: current value (1) ≠ target value (0)
# Script re-applies: sysctl -w net.ipv4.ip_forward=0
# Log entry: "[CHANGED] net.ipv4.ip_forward set to 0 (was 1)"
```

---

## Viewing Command Module Execution

```bash
# On the endpoint — view raw hardening log
sudo tail -50 /var/log/wazuh-linux-hardening.log

# In Wazuh Manager — view command module output events
sudo grep "linux-hardening" /var/ossec/logs/ossec.log | tail -20

# In Wazuh Dashboard — filter command output events
# (if ignore_output: no is set, output appears as events)
# Filter: data.command:"linux-hardening"
```
