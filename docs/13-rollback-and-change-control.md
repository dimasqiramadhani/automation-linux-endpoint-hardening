# 13 — Rollback and Change Control

## Rollback Strategy

Every hardening change has a defined rollback path:

| Change | Rollback Method |
|--------|---------------|
| sysctl changes (live) | `sysctl -w <key>=<original_value>` |
| /etc/sysctl.d/99-wazuh-hardening.conf | Delete file + `sysctl --system` |
| /etc/fstab update | Restore from backup; remount or reboot |
| All | Restore VM snapshot (fastest, most complete) |

---

## Using the Rollback Script

```bash
sudo bash scripts/linux_hardening_rollback.sh
```

The script:
1. Lists available backups
2. Asks for confirmation before restoring
3. Restores /etc/sysctl.d/99-wazuh-hardening.conf or removes it
4. Restores /etc/fstab from backup if available
5. Runs `sysctl --system` to re-apply the restored state
6. Prints rollback summary

---

## Change Control Principles

For lab purposes, documenting the following is sufficient:
- What was changed (control ID, sysctl key, file modified)
- When it was changed (timestamp from hardening log)
- What the original value was (from backup)
- What the new value is (from validation output)
- Rollback plan (backup file location)

For production, a formal change management process is required:
- Change request with scope, owner, risk assessment
- Approval from system owner and security team
- Scheduled maintenance window
- Tested rollback procedure
- Post-change verification

---

## Backup Locations

| File | Backup Location |
|------|----------------|
| `/etc/sysctl.conf` | `/etc/sysctl.conf.bak_wazuh_<timestamp>` |
| `/etc/fstab` | `/etc/fstab.bak_wazuh_<timestamp>` |
| `/etc/sysctl.d/99-wazuh-hardening.conf` | Created by script; delete to rollback |

---

## Catatan (Bahasa Indonesia)

Rollback adalah bagian penting dari setiap hardening project. Sebelum menjalankan script apapun di server nyata, pastikan: (1) snapshot VM sudah dibuat, (2) backup file konfigurasi tersedia, (3) ada cara untuk masuk ke server jika koneksi SSH terputus (console access). Di lab, rollback paling mudah dilakukan dengan restore snapshot VM.
