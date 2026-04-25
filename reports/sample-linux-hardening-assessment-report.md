# Linux Endpoint Hardening Assessment Report

**Project:** Automated Linux Endpoint Hardening with Wazuh  
**Report Version:** 1.0  
**Classification:** Lab / Portfolio — Not Confidential  
**Author:** Dimas Qi Ramadhani  

---

## 1. Executive Summary

This report documents a Linux endpoint hardening exercise conducted on an Ubuntu 24.04 lab VM using Wazuh SCA for baseline measurement and remediation validation, and the Wazuh Command Module for automated hardening script execution.

**Outcome:** SCA score improved from **44% to 53%** (+9 percentage points) following automated remediation of 6 control categories covering sysctl network hardening and /dev/shm mount options. All 9 targeted sysctl checks and 3 mount option checks transitioned from `failed` to `passed`. No service disruption occurred.

---

## 2. Scope

| Item | Details |
|------|---------|
| Assessment Type | CIS Ubuntu 24.04 Benchmark — SCA-based assessment |
| Endpoint | ubuntu-lab-01 (dummy) |
| OS | Ubuntu 24.04.1 LTS |
| Wazuh SCA Policy | CIS Ubuntu Linux 24.04 LTS Benchmark |
| Remediation Method | Wazuh Command Module + linux_hardening.sh |
| Out of Scope | SSH, auditd, PAM, firewall, service minimization |

---

## 3. Lab Environment

| Component | Details |
|-----------|---------|
| Wazuh Server | OVA v4.x — wazuh-lab-manager (dummy) |
| Ubuntu Endpoint | Ubuntu 24.04 LTS — ubuntu-lab-01 (dummy) |
| Wazuh Agent | v4.x — Active |
| SCA Policy | CIS Ubuntu Linux 24.04 LTS Benchmark (built-in) |
| VM Snapshot | Taken before hardening at 07:00 UTC |

---

## 4. Tools Used

| Tool | Version | Purpose |
|------|---------|---------|
| Wazuh SCA | 4.x | Configuration assessment + status tracking |
| Wazuh Command Module | 4.x | Automated script execution |
| linux_hardening.sh | Lab | Idempotent sysctl + mount hardening |
| validate_hardening_state.sh | Lab | Validation evidence |
| collect_sca_evidence.sh | Lab | Evidence collection |

---

## 5. Baseline SCA Result (Before)

| Metric | Value |
|--------|-------|
| Score | 44% |
| Total Checks | 280 |
| Passed | 100 |
| Failed | 127 |
| Not Applicable | 53 |
| Scan Timestamp | 2026-04-24T08:00:00Z |

---

## 6. Selected Remediation Controls

| Control ID | CIS Check | Area |
|-----------|----------|------|
| LH-001 | Ensure noexec,nosuid,nodev on /dev/shm | Filesystem |
| LH-002 | Ensure packet redirect sending is disabled | Network |
| LH-003 | Ensure IP forwarding is disabled | Network |
| LH-004 | Ensure source routed packets are not accepted | Network |
| LH-005 | Ensure ICMP redirects are not accepted | Network |
| LH-006 | Ensure secure ICMP redirects are not accepted | Network |

---

## 7. Hardening Automation Method

- Script deployed: `/var/ossec/active-response/bin/linux_hardening.sh`
- Ownership: `root:wazuh` — Permission: `750`
- Wazuh Command Module configured with `run_on_start: yes`, `interval: 12h`
- Script ran at 08:05 UTC on agent restart
- Execution time: 2 seconds
- Exit code: 0 (success)
- Changed: 9 controls | Compliant: 0 (first run) | Failed: 0

---

## 8. Validation Result

```
Control  Parameter                                  Expected  Current  Status
-------  ---------                                  --------  -------  ------
LH-002   net.ipv4.conf.all.send_redirects           0         0        ✅ PASS
LH-002   net.ipv4.conf.default.send_redirects       0         0        ✅ PASS
LH-003   net.ipv4.ip_forward                        0         0        ✅ PASS
LH-004   net.ipv4.conf.all.accept_source_route      0         0        ✅ PASS
LH-004   net.ipv4.conf.default.accept_source_route  0         0        ✅ PASS
LH-005   net.ipv4.conf.all.accept_redirects         0         0        ✅ PASS
LH-005   net.ipv4.conf.default.accept_redirects     0         0        ✅ PASS
LH-006   net.ipv4.conf.all.secure_redirects         0         0        ✅ PASS
LH-006   net.ipv4.conf.default.secure_redirects     0         0        ✅ PASS

LH-001   /dev/shm: noexec                           present   present  ✅ PASS
LH-001   /dev/shm: nodev                            present   present  ✅ PASS
LH-001   /dev/shm: nosuid                           present   present  ✅ PASS
```

---

## 9. Before and After Comparison

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| SCA Score | 44% | 53% | **+9%** |
| Passed Checks | 100 | 135 | **+35** |
| Failed Checks | 127 | 92 | **−35** |
| Not Applicable | 53 | 53 | — |
| Remediated Controls | 0 | 6 | +6 |

---

## 10. Remaining Failed Checks

| Check | Reason Not Automated |
|-------|---------------------|
| SSH PermitRootLogin | Requires pre-validated key auth |
| auditd installation | Requires workload-specific rule design |
| PAM password policy | Requires testing with all auth flows |
| Firewall configuration | Application-specific |
| Various service settings | Workload-dependent |

These represent Phase 2 hardening candidates requiring additional assessment.

---

## 11. Compliance Mapping

| Framework | Controls Addressed | Coverage |
|-----------|--------------------|---------|
| CIS Controls 4 | Secure Configuration | Partial |
| CIS Ubuntu 24.04 (1.1.x, 3.1.x, 3.2.x) | Filesystem + Network | 6/280 checks |
| ISO 27001 A.8.9 | Configuration management | Contextual |
| PCI DSS Req 2 | Secure configurations | Contextual |

---

## 12. Evidence

| Evidence | Reference |
|---------|---------|
| SCA before result | samples/sample-sca-before-result.json |
| SCA after result | samples/sample-sca-after-result.json |
| Status change alert | samples/sample-sca-status-change-alert.json |
| Hardening script execution log | samples/sample-hardening-run-output.log |
| Command module log | samples/sample-command-module-log.log |
| Validation output | scripts/validate_hardening_state.sh output |
| Screenshots | screenshots/ |

---

## 13. Risk and Limitations

- Lab environment — single endpoint, not representative of production diversity
- 35 improved checks = ~13% of failed checks — significant remaining gap
- Script does not cover SSH, auditd, PAM, firewall — highest-risk areas
- Some sysctl settings may be reverted by package updates or VM configuration
- Command Module idempotency ensures drift is corrected on next 12h interval

---

## 14. Recommendations

| Priority | Recommendation |
|----------|---------------|
| P1 | Phase 2: SSH hardening (PermitRootLogin, MaxAuthTries) |
| P1 | Phase 2: auditd installation and base rules |
| P2 | Phase 3: PAM password policy (minlen, complexity, history) |
| P2 | Monitor SCA score for regression — alert if score drops |
| P3 | Deploy to additional lab endpoints via agent group |
| P3 | Add rollback automation test to change control process |

---

## 15. Conclusion

This exercise demonstrates that the Wazuh Command Module can effectively automate targeted Linux endpoint hardening with measurable, validated results. The SCA score improved 9 percentage points in a single automated remediation cycle — with zero service disruption and a complete audit trail.

The idempotency design of `linux_hardening.sh` ensures that the Command Module can run every 12 hours to detect and correct configuration drift — maintaining the hardened state continuously rather than as a one-time event.

Remaining failures represent a clear Phase 2 roadmap with defined scope for further hardening automation development.

---

*Report prepared by: Dimas Qi Ramadhani*  
*Platform: Wazuh SCA + Command Module*  
*Report type: Lab-based assessment — not for production compliance without validation*
