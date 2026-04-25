# 01 — Project Overview

## Project Title

**Automated Linux Endpoint Hardening with Wazuh**  
*Using Wazuh Command Module and SCA to Remediate Linux Configuration Drift*

---

## Executive Summary

This project demonstrates how Wazuh can function as more than a passive monitoring tool — it can actively drive continuous endpoint hardening through automation and visibility. Using the **Wazuh Security Configuration Assessment (SCA)** module to measure compliance and the **Wazuh Command Module** to execute remediation automatically, the lab shows a complete hardening automation workflow from baseline measurement to validated improvement.

**Core workflow:**
1. SCA measures the current configuration state against the CIS Ubuntu 24.04 benchmark
2. Failed checks are analyzed; safe lab remediations are scoped
3. A hardening script applies targeted configuration changes
4. The Command Module runs the script automatically on start and schedule
5. SCA re-scans and confirms improvements (status changed: failed → passed)
6. Before/after evidence is collected and reported

---

## Project Objectives

| # | Objective |
|---|-----------|
| 1 | Understand Linux endpoint hardening concepts and CIS benchmark structure |
| 2 | Use Wazuh SCA to measure baseline security configuration compliance |
| 3 | Identify failed checks suitable for automated lab remediation |
| 4 | Design and implement a safe, idempotent Bash hardening script |
| 5 | Configure the Wazuh Command Module to run the script automatically |
| 6 | Validate hardening effectiveness through SCA re-scan comparison |
| 7 | Collect and document before/after evidence for compliance reporting |
| 8 | Demonstrate a full configuration drift remediation workflow |

---

## Skills Demonstrated

| Domain | Skills |
|--------|--------|
| Linux Hardening | sysctl network hardening, mount option hardening, CIS benchmark |
| Wazuh Platform | SCA module, Command Module, agent configuration, status change tracking |
| Bash Scripting | Idempotent scripts, backup/rollback, logging, dry-run mode |
| Compliance | CIS Controls mapping, before/after evidence, assessment reporting |
| Security Documentation | Risk-conscious automation design, change control notes |

---

## Catatan (Bahasa Indonesia)

Project ini menunjukkan perspektif yang sering diabaikan dalam portfolio security: bukan hanya mendeteksi masalah, tetapi juga membuktikan bahwa masalah tersebut bisa diperbaiki secara sistematis dan terukur. Kemampuan untuk mengotomatisasi hardening dan memvalidasi perubahannya menggunakan SIEM adalah skill yang sangat relevan untuk peran security engineer, DevSecOps engineer, dan SOC operations.

---

## What I Learned

- Linux endpoint hardening: sysctl network parameters, filesystem mount security
- Wazuh SCA scoring, check detail interpretation, and status change tracking
- Wazuh Command Module configuration and scheduling
- Idempotent Bash scripting — scripts that are safe to run multiple times
- Before/after compliance posture measurement and reporting
- CIS Ubuntu benchmark alignment and compliance mapping
- Rollback planning and change control for automated hardening
- Evidence-based reporting for security engineering portfolios
