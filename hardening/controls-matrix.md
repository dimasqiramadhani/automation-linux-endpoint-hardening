# Hardening Controls Matrix

> All controls are scoped for lab use. Test in isolated environments before production deployment.

| Control ID | Control Name | Benchmark Area | Remediation Method | Validation Command | Risk Level | Rollback Available |
|-----------|-------------|---------------|-------------------|------------------|-----------|-------------------|
| LH-001 | Harden /dev/shm with noexec,nodev,nosuid | CIS 1.1.x Filesystem | Update /etc/fstab + remount | `mount \| grep /dev/shm` | Low | ✅ Yes (fstab backup) |
| LH-002 | Disable packet redirect sending | CIS 3.1.x Network | sysctl + /etc/sysctl.d | `sysctl net.ipv4.conf.all.send_redirects` | Low | ✅ Yes (delete config file) |
| LH-003 | Disable IP forwarding | CIS 3.1.x Network | sysctl + /etc/sysctl.d | `sysctl net.ipv4.ip_forward` | Low* | ✅ Yes |
| LH-004 | Disable source routed packets | CIS 3.2.x Network | sysctl + /etc/sysctl.d | `sysctl net.ipv4.conf.all.accept_source_route` | Low | ✅ Yes |
| LH-005 | Disable ICMP redirects | CIS 3.2.x Network | sysctl + /etc/sysctl.d | `sysctl net.ipv4.conf.all.accept_redirects` | Low | ✅ Yes |
| LH-006 | Disable secure ICMP redirects | CIS 3.2.x Network | sysctl + /etc/sysctl.d | `sysctl net.ipv4.conf.all.secure_redirects` | Low | ✅ Yes |
| LH-007 | Maintain hardening execution log | Internal | Script log to /var/log | `tail /var/log/wazuh-linux-hardening.log` | None | N/A |
| LH-008 | Backup modified configuration files | Internal | Pre-change backup | `ls /var/backups/wazuh-hardening/` | None | N/A |

> \* LH-003 — Risk level is Low for standard endpoints. Do NOT apply if this machine acts as a network router or gateway.

---

## Controls Out of Scope (This Lab)

| Control | Reason |
|---------|--------|
| SSH configuration | High access risk; requires pre-validation of key auth |
| firewall rules | Application-specific |
| auditd rules | Workload-dependent; requires application context |
| PAM password policy | Requires testing with all authentication flows |
| Service disabling | Workload-dependent |
