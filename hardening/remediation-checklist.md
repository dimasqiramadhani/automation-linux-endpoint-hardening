# Remediation Checklist

Use this checklist before, during, and after the hardening exercise.

---

## Pre-Hardening

- [ ] **VM snapshot created** — named with date/time before any hardening
- [ ] **SCA baseline recorded** — initial score, passed, failed, not applicable counts noted
- [ ] **Failed checks identified** — list of checks selected for remediation
- [ ] **Dry run executed** — `sudo bash scripts/linux_hardening_dry_run.sh` reviewed
- [ ] **Script deployed** — `linux_hardening.sh` at `/var/ossec/active-response/bin/`
- [ ] **Permissions verified** — `root:wazuh` ownership, `750` permission confirmed
- [ ] **Backup confirmed** — backup directory exists at `/var/backups/wazuh-hardening/`

---

## During Hardening

- [ ] **Command Module configured** — wodle block added to `ossec.conf`
- [ ] **Wazuh Agent restarted** — `sudo systemctl restart wazuh-agent`
- [ ] **Script execution confirmed** — hardening log checked: `sudo tail /var/log/wazuh-linux-hardening.log`
- [ ] **No errors in log** — all controls showing CHANGED or COMPLIANT (no FAILED)

---

## Post-Hardening Validation

- [ ] **validate_hardening_state.sh run** — all controls showing ✅ PASS
- [ ] **sysctl values verified** — `sysctl net.ipv4.ip_forward` etc. return 0
- [ ] **/dev/shm options verified** — `mount | grep /dev/shm` shows noexec,nodev,nosuid
- [ ] **SCA rescan triggered** — agent restarted or scan interval waited
- [ ] **Updated SCA score noted** — score after remediation recorded
- [ ] **Status changed events confirmed** — Dashboard filter `data.sca.check.previous_result:failed`
- [ ] **Before-after comparison documented** — screenshot or table

---

## Evidence and Reporting

- [ ] **Evidence collected** — `sudo bash scripts/collect_sca_evidence.sh`
- [ ] **Screenshots captured** — per `screenshots/README.md` guide
- [ ] **Report generated** — `reports/sample-linux-hardening-assessment-report.md` completed
- [ ] **Before-after SCA report completed** — `reports/sample-before-after-sca-score-report.md`

---

## Rollback Plan

- [ ] **Rollback tested** (optional in lab) — `sudo bash scripts/linux_hardening_rollback.sh`
- [ ] **VM snapshot confirmed available** — fastest full rollback option
- [ ] **Backup files available** — `/var/backups/wazuh-hardening/` populated
