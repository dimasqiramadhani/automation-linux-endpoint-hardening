# 11 — Compliance Mapping

## Overview

All mappings are contextual and educational. This project is not a formal compliance audit. A qualified compliance officer or auditor must validate specific mappings for any regulatory requirement.

---

## CIS Controls Mapping

| CIS Control | Description | Related Lab Controls |
|-------------|-------------|---------------------|
| Control 4 | Secure Configuration of Enterprise Assets | All (LH-001 through LH-006) |
| Control 7 | Continuous Vulnerability Management | SCA continuous scanning |
| Control 8 | Audit Log Management | Hardening log, SCA evidence |

## CIS Ubuntu Linux 24.04 Benchmark

| Section | Area | Lab Controls |
|---------|------|-------------|
| 1.1.x | Filesystem configuration | LH-001 (/dev/shm) |
| 3.1.x | Network parameters (host only) | LH-002 through LH-006 |
| 4.x | Logging and auditing | Hardening log (LH-007) |

## ISO 27001 Mapping (Contextual)

| Control | Description | Relevant To |
|---------|-------------|------------|
| A.8.8 | Management of technical vulnerabilities | Benchmark-based remediation |
| A.8.9 | Configuration management | All hardening controls |
| A.8.15 | Logging | Hardening log + SCA evidence |
| A.8.20 | Network security | LH-002 through LH-006 |

## PCI DSS Mapping (Contextual)

| Requirement | Description | Relevant To |
|-------------|-------------|------------|
| Req 1 | Network security controls | LH-002 through LH-006 |
| Req 2 | Secure configurations | All LH controls |
| Req 10 | Logging and monitoring | Hardening log + Wazuh SCA |
