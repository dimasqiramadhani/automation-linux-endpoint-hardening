# 14 — Troubleshooting

## Issue 1: Wazuh Agent Not Active

```bash
sudo systemctl status wazuh-agent
sudo systemctl restart wazuh-agent
# Check enrollment
sudo grep "Connected to" /var/ossec/logs/ossec.log | tail -5
```

---

## Issue 2: SCA Results Not Appearing

```bash
sudo grep -i "sca" /var/ossec/logs/ossec.log | tail -20
# Force rescan by restarting agent
sudo systemctl restart wazuh-agent
# Wait 30-60s then check Dashboard
```

---

## Issue 3: Command Module Not Running Script

```bash
# Check agent log for wodle execution
sudo grep "linux-hardening\|wodle\|command" /var/ossec/logs/ossec.log | tail -20
# Verify script exists and permissions are correct
ls -la /var/ossec/active-response/bin/linux_hardening.sh
# Expected: -rwxr-x--- 1 root wazuh
```

---

## Issue 4: Script Permission Error

```bash
# Fix ownership and permission
sudo chown root:wazuh /var/ossec/active-response/bin/linux_hardening.sh
sudo chmod 750 /var/ossec/active-response/bin/linux_hardening.sh
```

---

## Issue 5: sysctl Value Not Changed After Script

```bash
# Check if script ran as root
sudo head -5 /var/log/wazuh-linux-hardening.log
# Verify current value
sysctl net.ipv4.ip_forward
# Check if 99-wazuh-hardening.conf was created
ls -la /etc/sysctl.d/99-wazuh-hardening.conf
# Manually apply
sudo sysctl --system
```

---

## Issue 6: /dev/shm Mount Option Not Changing

The /dev/shm fstab entry change only takes full effect after remount or reboot:

```bash
# Check fstab entry
grep "shm\|tmpfs" /etc/fstab
# Remount without reboot
sudo mount -o remount /dev/shm
# Verify
mount | grep /dev/shm
```

---

## Issue 7: /etc/fstab Syntax Error

```bash
# Validate fstab before reboot
sudo findmnt --verify --verbose
# If error found, restore backup
sudo cp /etc/fstab.bak_wazuh_* /etc/fstab
```

---

## Issue 8: SCA Score Not Changing After Hardening

1. Verify sysctl values changed: `sudo bash scripts/validate_hardening_state.sh`
2. Restart Wazuh Agent to trigger `scan_on_start`
3. Wait for next scheduled SCA interval (default: 12h)
4. Check Dashboard time range — extend to last 24 hours
5. Check agent log: `sudo grep "sca" /var/ossec/logs/ossec.log | tail -20`

---

## Issue 9: Rollback Cannot Find Backup

```bash
ls -la /etc/sysctl.conf.bak_wazuh_*
ls -la /etc/fstab.bak_wazuh_*
# If no backup found — restore VM snapshot
# (This is why the snapshot step is mandatory before any hardening)
```

---

## Issue 10: Configuration Drift Returns After Reboot

Some sysctl settings may not persist if:
- The `/etc/sysctl.d/99-wazuh-hardening.conf` file was not created correctly
- Another configuration file sets the same key with higher priority

```bash
# Check if file exists and has correct content
cat /etc/sysctl.d/99-wazuh-hardening.conf
# Check sysctl.d load order
ls -la /etc/sysctl.d/
# The Command Module interval will re-apply if drift is detected
```
