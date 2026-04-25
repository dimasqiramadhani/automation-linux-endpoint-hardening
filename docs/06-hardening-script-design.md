# 06 — Hardening Script Design

## Design Principles

| Principle | Implementation |
|-----------|---------------|
| **Idempotent** | Each control checks current state before applying change |
| **Non-destructive** | No user deletion, no service shutdown, no aggressive SSH changes |
| **Auditable** | Every action logged to `/var/log/wazuh-linux-hardening.log` |
| **Backed up** | Configuration files backed up before modification |
| **Validated** | After applying each change, script verifies the result |
| **Safe to fail** | Individual control failures don't abort the entire script |
| **Transparent** | Summary at end shows what changed, what was skipped, what failed |

---

## Script Structure

```bash
linux_hardening.sh
├── Root check — exit if not root
├── Log setup — timestamped log file
├── Backup — /etc/sysctl.conf, /etc/fstab
├── sysctl hardening (LH-002 through LH-006)
│   ├── Check current value
│   ├── If already correct → log "already compliant"
│   └── If incorrect → apply + log "changed"
├── Write to /etc/sysctl.d/99-wazuh-hardening.conf
├── sysctl --system (apply changes immediately)
├── /dev/shm hardening (LH-001)
│   ├── Check current mount options
│   ├── If already has noexec,nodev,nosuid → skip
│   └── If missing → update /etc/fstab entry
└── Summary — print changed/skipped/failed counts
```

---

## What the Script Does NOT Do

The following are intentionally out of scope for this lab script:

| Out of Scope | Reason |
|-------------|--------|
| SSH configuration changes | High risk of locking out access |
| Firewall rule modifications | Requires application context |
| User/group management | Destructive potential |
| Service disabling | May break application workloads |
| PAM configuration | High risk; requires testing |
| Kernel module blacklisting | Requires reboot; risky in automation |
