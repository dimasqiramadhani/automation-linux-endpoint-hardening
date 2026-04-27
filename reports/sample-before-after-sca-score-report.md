# Before / After SCA Score Report

**Host:** ubuntu-server  
**Policy:** CIS Ubuntu Linux 24.04 LTS Benchmark v1.0.0  
**Hardening Method:** Wazuh Command Module + linux_hardening.sh  
**Wazuh Agent Version:** v4.14.5  
**OS:** Ubuntu 24.04.4 LTS (kernel 6.8.0-110-generic)  
**Execution Date:** Apr 27, 2026  
**Author:** Dimas Qi Ramadhani

---

## Score Summary

| Metric | Before | After | Delta |
|--------|--------|-------|-------|
| **SCA Score** | **50%** | **51%** | **+1%** |
| Passed Checks | 119 | 123 | +4 |
| Failed Checks | 118 | 114 | −4 |
| Not Applicable | 42 | 42 | — |
| Total Checks | 279 | 279 | — |
| Scan Timestamp (Before) | 2026-04-27T17:23:57Z | — | — |
| Scan Timestamp (After) | — | 2026-04-27T17:52:25Z | — |

---

## Checks Changed: Failed → Passed

| Check ID | Check Title | Before | After | Control |
|---------|------------|--------|-------|---------|
| 35517 | Ensure noexec option set on /dev/shm partition | failed | ✅ passed | LH-001 |
| 35609 | Ensure packet redirect sending is disabled | failed | ✅ passed | LH-002 |
| 35608 | Ensure ip forwarding is disabled | failed | ✅ passed | LH-003 |
| 35615 | Ensure source routed packets are not accepted | failed | ✅ passed | LH-004 |
| 35613 | Ensure secure icmp redirects are not accepted | failed | ✅ passed | LH-006 |

**Total improved: 5 checks from 5 control categories**

---

## Check Still Failed (Known Gap)

| Check ID | Check Title | Root Cause |
|---------|------------|------------|
| 35612 | Ensure icmp redirects are not accepted | CIS check mengevaluasi `net.ipv6.conf.*.accept_redirects` dan loopback `lo`. Script hanya handle `net.ipv4.conf.all` dan `net.ipv4.conf.default`. IPv6 dan per-interface scope direncanakan di Phase 2. |

---

## Idempotency Validation

Script dieksekusi dua kali — pertama saat agent start awal, kedua setelah restart untuk SCA re-scan:

| Execution | Timestamp | Changed | Compliant | Failed |
|-----------|-----------|---------|-----------|--------|
| Run 1 (initial) | 2026-04-27T17:49:27 | **8** | 2 | 0 |
| Run 2 (re-scan restart) | 2026-04-27T17:52:23 | **0** | 10 | 0 |

Run 2 menunjukkan `Changed: 0` — semua control sudah compliant, tidak ada perubahan yang dilakukan. Ini membuktikan script bersifat **idempotent**.

---

## Remediation Detail

Semua perubahan dilakukan oleh satu eksekusi `linux_hardening.sh` via Wazuh Command Module:

**sysctl changes (ditulis ke `/etc/sysctl.d/99-wazuh-hardening.conf`):**
```
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
```

> Note: `net.ipv4.ip_forward` dan `net.ipv4.conf.all.accept_source_route` sudah bernilai `0` di baseline — di-skip oleh idempotency check.

**/dev/shm mount (via `/etc/fstab` + remount):**
```
tmpfs   /dev/shm   tmpfs   defaults,noexec,nodev,nosuid   0 0
```

**Backup files created:**
```
/var/backups/wazuh-hardening/sysctl.conf.bak_20260427_174927
/var/backups/wazuh-hardening/fstab.bak_20260427_174927
```

---

## Screenshots Reference

### Deployment & Execution Evidence

| File | Deskripsi |
|------|-----------|
| `Wazuh Remote Command Enable.png` | Setting `wazuh_command.remote_commands=1` di `local_internal_options.conf` |
| `Hardening Script Deploy.png` | Script ter-deploy dengan permission `root:wazuh 750` |
| `Woodle Agent Ossec Config.png` | Wodle command block di `ossec.conf` |
| `Hardening Log Before.png` | Dry run output — 8 NON-COMPLIANT controls sebelum hardening |
| `Hardening Log.png` | Hardening log aktual — `Changed: 8, Failed: 0` |
| `Validasi Hardening Status.png` | validate_hardening_state.sh — semua 12 baris ✅ PASS |

### SCA Dashboard Before/After

| File | Deskripsi |
|------|-----------|
| `Security Configuration Assessment - Before.png` | Dashboard: 50% score, 119 passed, 118 failed |
| `Security Configuration Assessment - After.png` | Dashboard: 51% score, 123 passed, 114 failed |
| `Security Configuration Assessment - dev-shm Before.png` | /dev/shm: 35517 noexec Failed |
| `Security Configuration Assessment - dev-shm After.png` | /dev/shm: semua 4 checks Passed ✅ |
| `Security Configuration Assessment - icmp redirects Before.png` | ICMP redirects: 35609, 35612, 35613 — semua Failed |
| `Security Configuration Assessment - icmp redirects After.png` | 35609 Passed ✅, 35612 masih Failed (IPv6 gap), 35613 Passed ✅ |
| `Security Configuration Assessment - secure icmp Before.png` | secure icmp (35613): Failed |
| `Security Configuration Assessment - secure icmp After.png` | secure icmp (35613): Passed ✅ |
| `Security Configuration Assessment - send_redirects Before.png` | send_redirects (35609): Failed |
| `Security Configuration Assessment - send_redirects After.png` | send_redirects (35609): Passed ✅ |
| `Security Configuration Assessment - source routed Before.png` | source routed (35615): Failed |
| `Security Configuration Assessment - source routed After.png` | source routed (35615): Passed ✅ |

---

## Next Hardening Phase (Planned)

| Phase | Target | Estimated Score Gain |
|-------|--------|---------------------|
| Phase 2 | IPv6 accept_redirects + loopback (fix check 35612) | +1% |
| Phase 2 | SSH hardening (PermitRootLogin, MaxAuthTries) | +2–3% |
| Phase 3 | auditd installation + rules | +3–5% |
| Phase 4 | PAM password policy | +2–3% |

**Projected score after Phase 2:** ~54–56%

---

*Report generated by: Dimas Qi Ramadhani*  
*All values are actual lab results from isolated VMware lab environment*
