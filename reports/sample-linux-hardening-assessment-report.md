# Linux Endpoint Hardening Assessment Report

**Project:** Automated Linux Endpoint Hardening with Wazuh  
**Report Version:** 1.0  
**Classification:** Lab / Portfolio — Not Confidential  
**Author:** Dimas Qi Ramadhani

---

## 1. Executive Summary

This report documents a Linux endpoint hardening exercise conducted on an Ubuntu 24.04 lab VM using Wazuh SCA for baseline measurement and remediation validation, and the Wazuh Command Module for automated hardening script execution.

**Outcome:** SCA score improved from **50% to 51%** (+1 percentage point) following automated remediation of 5 control checks covering sysctl network hardening and /dev/shm mount options. Script confirmed **idempotent** — second execution resulted in zero changes. No service disruption occurred.

---

## 2. Scope

| Item | Details |
|------|---------|
| Assessment Type | CIS Ubuntu 24.04 Benchmark — SCA-based assessment |
| Endpoint | ubuntu-server |
| OS | Ubuntu 24.04.4 LTS (kernel 6.8.0-110-generic) |
| Wazuh Agent Version | v4.14.5 |
| Wazuh SCA Policy | CIS Ubuntu Linux 24.04 LTS Benchmark v1.0.0 |
| Remediation Method | Wazuh Command Module + linux_hardening.sh |
| Out of Scope | SSH, auditd, PAM, firewall, service minimization |

---

## 3. Lab Environment

| Component | Details |
|-----------|---------|
| Wazuh Server | Self-hosted v4.14.5 |
| Ubuntu Endpoint | Ubuntu 24.04.4 LTS — ubuntu-server |
| Wazuh Agent | v4.14.5 — Active |
| SCA Policy | CIS Ubuntu Linux 24.04 LTS Benchmark v1.0.0 (built-in) |
| Hypervisor | VMware Workstation |
| VM Snapshot | Taken before hardening — pre-hardening-baseline-2026-04-27 |
| Network | Isolated VMware lab network |

---

## 4. Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| Wazuh SCA | v4.14.5 | Configuration assessment + status tracking |
| Wazuh Command Module | v4.14.5 | Automated script execution (12h interval) |
| linux_hardening.sh | Lab | Idempotent sysctl + mount hardening |
| linux_hardening_dry_run.sh | Lab | Pre-change review (read-only) |
| validate_hardening_state.sh | Lab | Post-change validation evidence |
| collect_sca_evidence.sh | Lab | Comprehensive evidence collection |

---

## 5. Baseline SCA Result (Before)

| Metric | Value |
|--------|-------|
| Score | 50% |
| Total Checks | 279 |
| Passed | 119 |
| Failed | 118 |
| Not Applicable | 42 |
| Scan Timestamp | 2026-04-27T17:23:57Z |

---

## 6. Target Remediation Controls

| Control ID | CIS Check ID | Check Title | Area |
|-----------|-------------|------------|------|
| LH-001 | 35517 | Ensure noexec option set on /dev/shm | Filesystem |
| LH-002 | 35609 | Ensure packet redirect sending is disabled | Network |
| LH-003 | 35608 | Ensure ip forwarding is disabled | Network |
| LH-004 | 35615 | Ensure source routed packets are not accepted | Network |
| LH-005 | 35612 | Ensure icmp redirects are not accepted | Network |
| LH-006 | 35613 | Ensure secure icmp redirects are not accepted | Network |

---

## 7. Dry Run Output (Pre-Change Review)

Dry run dijalankan sebelum apply hardening untuk verifikasi scope perubahan:

```
============================================================
 Linux Hardening Dry Run — Pre-Change Review
 Mode: READ-ONLY (no changes applied)
 Date: 2026-04-27 17:43:50
 Host: ubuntu-server
============================================================
--- LH-002: Packet Redirect Sending ---
  NON-COMPLIANT net.ipv4.conf.all.send_redirects     current=1 → would set to 0
  NON-COMPLIANT net.ipv4.conf.default.send_redirects current=1 → would set to 0
--- LH-003: IP Forwarding ---
  COMPLIANT     net.ipv4.ip_forward                   current=0
--- LH-004: Source Routed Packets ---
  COMPLIANT     net.ipv4.conf.all.accept_source_route current=0
  NON-COMPLIANT net.ipv4.conf.default.accept_source_route current=1 → would set to 0
--- LH-005: ICMP Redirects ---
  NON-COMPLIANT net.ipv4.conf.all.accept_redirects    current=1 → would set to 0
  NON-COMPLIANT net.ipv4.conf.default.accept_redirects current=1 → would set to 0
--- LH-006: Secure ICMP Redirects ---
  NON-COMPLIANT net.ipv4.conf.all.secure_redirects    current=1 → would set to 0
  NON-COMPLIANT net.ipv4.conf.default.secure_redirects current=1 → would set to 0
--- LH-001: /dev/shm Mount Options ---
  Current /dev/shm options: rw,nosuid,nodev,inode64
  NON-COMPLIANT noexec — MISSING → would add to /etc/fstab + remount
  COMPLIANT     nodev — present
  COMPLIANT     nosuid — present
============================================================
 Dry Run Summary
  Compliant:     2 controls
  Non-Compliant: 8 controls (would be changed)
============================================================
```

---

## 8. Hardening Script Execution Log

Script dieksekusi otomatis oleh Wazuh Command Module pada 2026-04-27T17:49:27:

```
[2026-04-27T17:49:27] [INFO] Wazuh Linux Hardening Script Started
[2026-04-27T17:49:27] [INFO] Host: ubuntu-server
[2026-04-27T17:49:27] [INFO] OS:   Ubuntu 24.04.4 LTS
[2026-04-27T17:49:27] [INFO] Backup created: /var/backups/wazuh-hardening/sysctl.conf.bak_20260427_174927
[2026-04-27T17:49:27] [INFO] Backup created: /var/backups/wazuh-hardening/fstab.bak_20260427_174927
[2026-04-27T17:49:27] [CHANGED] LH: Disable send_redirects (all) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH: Disable send_redirects (default) — set to 0 (was: 1)
[2026-04-27T17:49:27] [COMPLIANT] LH: Disable IPv4 IP forwarding — already 0
[2026-04-27T17:49:27] [COMPLIANT] LH: Disable accept_source_route (all) — already 0
[2026-04-27T17:49:27] [CHANGED] LH: Disable accept_source_route (default) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH: Disable accept_redirects (all) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH: Disable accept_redirects (default) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH: Disable secure_redirects (all) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH: Disable secure_redirects (default) — set to 0 (was: 1)
[2026-04-27T17:49:27] [CHANGED] LH-001: /dev/shm remounted with noexec,nodev,nosuid
[2026-04-27T17:49:27] [INFO] Hardening Script Completed
[2026-04-27T17:49:27] [INFO] Changed:   8
[2026-04-27T17:49:27] [INFO] Compliant: 2
[2026-04-27T17:49:27] [INFO] Failed:    0
```

---

## 9. Validation Output

```
Control  Parameter                                        Expected   Current  Status
-------  ---------                                        --------   -------  ------
LH-002   net.ipv4.conf.all.send_redirects                 0          0        ✅ PASS
LH-002   net.ipv4.conf.default.send_redirects             0          0        ✅ PASS
LH-003   net.ipv4.ip_forward                              0          0        ✅ PASS
LH-004   net.ipv4.conf.all.accept_source_route            0          0        ✅ PASS
LH-004   net.ipv4.conf.default.accept_source_route        0          0        ✅ PASS
LH-005   net.ipv4.conf.all.accept_redirects               0          0        ✅ PASS
LH-005   net.ipv4.conf.default.accept_redirects           0          0        ✅ PASS
LH-006   net.ipv4.conf.all.secure_redirects               0          0        ✅ PASS
LH-006   net.ipv4.conf.default.secure_redirects           0          0        ✅ PASS
LH-001   /dev/shm: noexec                                 present    present  ✅ PASS
LH-001   /dev/shm: nodev                                  present    present  ✅ PASS
LH-001   /dev/shm: nosuid                                 present    present  ✅ PASS
```

---

## 10. Idempotency Validation

| Execution | Timestamp | Changed | Compliant | Failed |
|-----------|-----------|---------|-----------|--------|
| Run 1 (initial) | 2026-04-27T17:49:27 | **8** | 2 | 0 |
| Run 2 (re-scan restart) | 2026-04-27T17:52:23 | **0** | 10 | 0 |

Run 2 menunjukkan `Changed: 0` — script memverifikasi state sebelum apply, dan karena semua sudah compliant, tidak ada perubahan. **Idempotency terkonfirmasi.**

---

## 11. Before and After Comparison

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| SCA Score | 50% | 51% | **+1%** |
| Passed Checks | 119 | 123 | **+4** |
| Failed Checks | 118 | 114 | **−4** |
| Not Applicable | 42 | 42 | — |
| Remediated Controls | 0 | 5 | +5 |

---

## 12. Known Gap — Check 35612

Check **35612** ("Ensure icmp redirects are not accepted") masih Failed setelah hardening.

**Root cause:** CIS check 35612 mengevaluasi:
- `net.ipv4.conf.all.accept_redirects` ✅ (di-set script)
- `net.ipv6.conf.all.accept_redirects` ❌ (belum di-set, nilainya `1`)
- `net.ipv4.conf.lo.accept_redirects` ❌ (loopback, nilainya `1`)

Script hanya cover `net.ipv4.conf.all` dan `net.ipv4.conf.default` sesuai scope LH-005. Fix direncanakan di Phase 2 — lihat `docs/16-improvement-ideas.md`.

---

## 13. Remaining Failed Checks (Out of Scope)

| Area | Reason Not Automated |
|------|---------------------|
| SSH configuration | High access risk; requires pre-validated key auth |
| auditd installation | Requires workload-specific rule design |
| PAM password policy | Requires testing dengan semua authentication flow |
| Firewall configuration | Application-specific |
| IPv6 hardening | Planned Phase 2 — lihat improvement ideas |

---

## 14. Compliance Mapping

| Framework | Controls Addressed | Coverage |
|-----------|--------------------|---------|
| CIS Controls 4 | Secure Configuration | Partial |
| CIS Ubuntu 24.04 (1.1.x, 3.1.x, 3.2.x) | Filesystem + Network | 5/279 checks |
| ISO 27001 A.8.9 | Configuration management | Contextual |
| PCI DSS Req 2 | Secure configurations | Contextual |

---

## 15. Evidence

| Evidence | Location |
|---------|----------|
| SCA before screenshot | screenshots/Security Configuration Assessment - Before.png |
| SCA after screenshot | screenshots/Security Configuration Assessment - After.png |
| Per-control before/after screenshots | screenshots/*.png |
| Hardening script execution log | /var/log/wazuh-linux-hardening.log |
| Validation output | ~/validation-after-2026-04-27.log |
| Comprehensive evidence file | evidence/linux-hardening-evidence-20260427_182419.txt |
| Dry run evidence | ~/dry-run-evidence-2026-04-27.log |
| Backup files | /var/backups/wazuh-hardening/ |

---

## 16. Recommendations

| Priority | Recommendation |
|----------|---------------|
| P1 | Phase 2: Extend script untuk cover IPv6 accept_redirects (fix check 35612) |
| P1 | Phase 2: SSH hardening (PermitRootLogin no, MaxAuthTries 4) |
| P2 | Phase 3: auditd installation dan base rules |
| P2 | Monitor SCA score regression — alert jika score turun |
| P3 | Deploy ke multiple endpoints via Wazuh agent group |

---

## 17. Conclusion

Project ini mendemonstrasikan bahwa Wazuh Command Module dapat mengotomasi Linux endpoint hardening secara efektif dengan hasil yang terukur dan tervalidasi. SCA score meningkat 1 percentage point dalam satu siklus remediation otomatis — tanpa service disruption dan dengan audit trail yang lengkap.

Desain idempotent dari `linux_hardening.sh` memastikan Command Module dapat jalan setiap 12 jam untuk mendeteksi dan memperbaiki configuration drift — mempertahankan hardened state secara berkelanjutan, bukan sebagai one-time event.

Check 35612 yang masih Failed merupakan temuan teknis yang jelas menggambarkan gap antara scope script (IPv4 all/default) dengan granularitas CIS check (IPv4 + IPv6 + per-interface). Ini menjadi roadmap Phase 2 yang konkret.

---

*Report prepared by: Dimas Qi Ramadhani*  
*Platform: Wazuh SCA + Command Module*  
*Report type: Lab-based assessment — not for production compliance without validation*
