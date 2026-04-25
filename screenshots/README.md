# Screenshots Guide

This directory contains portfolio evidence screenshots from the Automated Linux Endpoint Hardening with Wazuh project.

---

## Required Screenshots

### 1. `01-agent-active.png`
**Navigate to:** Wazuh Dashboard → Agents  
**Show:** `ubuntu-lab-01` with **Active** status (green)

### 2. `02-ubuntu-endpoint-details.png`
**Navigate to:** Wazuh Dashboard → Agents → click ubuntu-lab-01  
**Show:** Agent detail: OS version, IP, last keep alive

### 3. `03-initial-sca-score.png`
**Navigate to:** Endpoint Security → Configuration Assessment → ubuntu-lab-01 → CIS Ubuntu 24.04  
**Show:** Initial score (e.g. 44%), passed/failed/N-A counts  
**Why:** Baseline evidence before hardening

### 4. `04-failed-check-dev-shm.png`
**Navigate to:** Same — click on `/dev/shm noexec` check  
**Show:** Full check detail: title, rationale, remediation, compliance  
**Why:** Evidence of pre-hardening state

### 5. `05-failed-check-redirect.png`
**Navigate to:** Same — click on "packet redirect sending" check  
**Show:** Full check detail with rationale and CIS reference  
**Why:** Pre-hardening evidence for network control

### 6. `06-script-file-location.png`
**Command:** `ls -la /var/ossec/active-response/bin/ | grep hardening`  
**Show:** linux_hardening.sh listed with correct path

### 7. `07-script-permissions.png`
**Command:** `stat /var/ossec/active-response/bin/linux_hardening.sh`  
**Show:** Owner: root | Group: wazuh | Mode: 0750

### 8. `08-command-module-config.png`
**Command:** `grep -A10 "linux-hardening" /var/ossec/etc/ossec.conf`  
**Show:** The wodle block with all parameters visible

### 9. `09-agent-restart.png`
**Command:** `sudo systemctl status wazuh-agent`  
**Show:** Active (running) status after restart

### 10. `10-hardening-script-log.png`
**Command:** `sudo tail -30 /var/log/wazuh-linux-hardening.log`  
**Show:** CHANGED entries for all 9 sysctl parameters and /dev/shm

### 11. `11-validate-hardening-state.png`
**Command:** `sudo bash scripts/validate_hardening_state.sh`  
**Show:** Table with all controls showing ✅ PASS

### 12. `12-updated-sca-score.png`
**Navigate to:** Endpoint Security → Configuration Assessment → ubuntu-lab-01  
**Show:** Updated score (e.g. 53%), improved counts  
**Why:** Post-hardening evidence

### 13. `13-sca-check-changed.png`
**Filter:** `data.sca.check.previous_result:failed`  
**Show:** Status changed events with `previous_result: failed` → `result: passed`

### 14. `14-dashboard-sca-filter.png`
**Navigate to:** Threat Hunting / Security Events  
**Filter:** `rule.groups:sca AND agent.name:ubuntu-lab-01`  
**Show:** SCA events list

### 15. `15-final-report-github.png`
**Navigate to:** `reports/sample-linux-hardening-assessment-report.md` in GitHub  
**Show:** Report rendered with before/after comparison table visible

---

## Screenshot Tips

- Resolution: 1920×1080
- **Redact hostname, IP, and any internal identifiers** before publishing
- For terminal output, use a dark theme for readability
- For check detail screenshots, expand the full check panel to show rationale + compliance
- Capture both the before and after SCA score screenshots in the same Dashboard location for clean comparison

---

> Place actual PNG/JPG files here using the naming convention above.
