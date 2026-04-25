# 03 — Linux Hardening Concept

## What Is Linux Hardening?

**Linux hardening** is the process of systematically reducing a system's attack surface by configuring it more securely — removing unnecessary features, restricting network behavior, enforcing safer defaults, and ensuring audit trails exist.

A default Ubuntu installation is designed for broad compatibility and ease of use, not minimal attack surface. Hardening closes the gap between "works out of the box" and "configured according to security best practice."

---

## Hardening Categories

| Category | Examples |
|----------|---------|
| **Kernel parameters (sysctl)** | Disable IP forwarding, ICMP redirects, source routing |
| **Filesystem security** | Mount options: noexec, nodev, nosuid on /dev/shm, /tmp |
| **SSH configuration** | Disable root login, require key auth, set MaxAuthTries |
| **Service minimization** | Disable and remove unnecessary services |
| **Audit and logging** | Enable auditd, configure log retention |
| **Password policy** | PAM configuration, minimum complexity |
| **File permissions** | World-writable files, SUID binaries |
| **Network access control** | Firewall rules, disable unused network protocols |

---

## Why Hardening Matters

| Reason | Detail |
|--------|--------|
| **Compliance** | CIS Benchmark, PCI DSS Req 2, ISO 27001 A.8.9 require secure configurations |
| **Reduce attack surface** | Fewer services, stricter network settings → fewer attack paths |
| **Prevent lateral movement** | Disabling IP forwarding prevents the endpoint from being used as a relay |
| **Audit readiness** | Demonstrable, documented configuration baseline |
| **Configuration drift control** | Automation prevents manual changes from reverting hardening |

---

## Hardening ≠ Security Silver Bullet

Hardening reduces risk but does not eliminate it. Important caveats:

- Some hardening controls may break specific applications (e.g., disabling IP forwarding on a router)
- Always test in a lab environment before applying to production
- Application owners and system administrators must review changes
- Hardening should be combined with monitoring, patching, and access control

---

## Automation and Idempotency

The hardening script in this project is **idempotent** — running it multiple times produces the same result. This is essential for:

- Safely using the Wazuh Command Module to re-apply hardening periodically
- Detecting and correcting configuration drift (when a change reverts)
- Ensuring the script doesn't accumulate duplicate entries in config files

---

## Catatan (Bahasa Indonesia)

Linux hardening adalah langkah proaktif untuk memastikan server dikonfigurasi sesuai standar keamanan, bukan hanya berjalan dengan setting default. Script di project ini dirancang idempotent — bisa dijalankan berkali-kali tanpa efek samping — yang penting untuk automation. Yang harus diingat: selalu test di lab dulu, karena beberapa setting bisa memengaruhi aplikasi yang berjalan di server tersebut.
