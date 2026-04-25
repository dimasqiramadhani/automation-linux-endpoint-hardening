# CIS Ubuntu Linux 24.04 LTS — Lab Controls Mapping

> This mapping is contextual and educational. Always refer to the official CIS Benchmark document for authoritative guidance. Mappings should be validated by a qualified compliance officer before use in formal audits.

---

## Section Mapping

### Section 1: Initial Setup — Filesystem Configuration

| CIS Section | CIS Check | Lab Control | Status |
|-------------|----------|-------------|--------|
| 1.1.8 | Ensure nodev on /dev/shm | LH-001 | ✅ Covered |
| 1.1.9 | Ensure nosuid on /dev/shm | LH-001 | ✅ Covered |
| 1.1.10 | Ensure noexec on /dev/shm | LH-001 | ✅ Covered |

### Section 3: Network Configuration

| CIS Section | CIS Check | Lab Control | Status |
|-------------|----------|-------------|--------|
| 3.1.1 | Ensure IP forwarding is disabled | LH-003 | ✅ Covered |
| 3.1.2 | Ensure packet redirect sending is disabled | LH-002 | ✅ Covered |
| 3.2.1 | Ensure source routed packets are not accepted | LH-004 | ✅ Covered |
| 3.2.2 | Ensure ICMP redirects are not accepted | LH-005 | ✅ Covered |
| 3.2.3 | Ensure secure ICMP redirects are not accepted | LH-006 | ✅ Covered |

### Not Covered in This Lab (Require Additional Testing)

| CIS Section | CIS Check | Reason Not Automated |
|-------------|----------|---------------------|
| 5.2.x | SSH server configuration | Access risk |
| 1.5.x | Additional process hardening | Reboot required |
| 4.x | Logging and auditing | Requires auditd config review |
| 6.x | System maintenance | Manual review needed |

---

## Notes

- CIS Ubuntu 24.04 Level 1 covers basic security hygiene suitable for most server environments
- CIS Ubuntu 24.04 Level 2 adds more restrictive controls that may impact certain workloads
- This lab focuses on Level 1 network and filesystem controls that are safe to automate
- The full CIS Benchmark PDF is available at: https://www.cisecurity.org/benchmark/ubuntu_linux
