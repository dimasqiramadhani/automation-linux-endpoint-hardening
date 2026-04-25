# Active Response / Command Module Script — Permission Notes

## Script Location

```
/var/ossec/active-response/bin/linux_hardening.sh
```

This is the standard location for scripts executed by the Wazuh Agent's Command Module. The `active-response/bin/` path is already known to Wazuh and is designed for this purpose.

---

## Required Ownership and Permission

```bash
sudo chown root:wazuh /var/ossec/active-response/bin/linux_hardening.sh
sudo chmod 750 /var/ossec/active-response/bin/linux_hardening.sh
```

Expected output from `ls -la`:
```
-rwxr-x--- 1 root wazuh 8420 Jan 15 10:00 linux_hardening.sh
```

---

## Permission Explanation

| Component | Value | Reason |
|-----------|-------|--------|
| Owner | `root` | Only root can write/modify the script |
| Group | `wazuh` | Wazuh Agent process (runs as wazuh or root) needs execute |
| User bits | `rwx` (7) | Root can read, write, execute |
| Group bits | `r-x` (5) | Wazuh group can read and execute — not modify |
| Other bits | `---` (0) | No other user can access the script |

---

## Why This Matters

The Wazuh Command Module executes this script automatically with elevated privileges. If the script were:

- **World-readable or world-writable** — any user could read the hardening logic or replace it with malicious code
- **Owned by a non-root user** — that user could modify what the script does
- **Group-writable** — any member of the wazuh group could inject code that runs as root

The `root:wazuh 750` combination ensures:
1. Only root controls the script content
2. The Wazuh process can run it (needed for Command Module to function)
3. No other user has any access

---

## Verification

```bash
ls -la /var/ossec/active-response/bin/linux_hardening.sh
stat /var/ossec/active-response/bin/linux_hardening.sh
```

Expected:
```
File: /var/ossec/active-response/bin/linux_hardening.sh
Access: (0750/-rwxr-x---)
Uid: (0/root)
Gid: (<wazuh_gid>/wazuh)
```
