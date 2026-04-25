# 08 — Deployment Guide

## Prerequisites Checklist

- [ ] Wazuh Manager, Indexer, Dashboard — all services running
- [ ] Ubuntu 24.04 lab VM enrolled as Wazuh Agent — status Active
- [ ] VM snapshot taken **before any hardening**
- [ ] SCA baseline score and failed check list recorded

---

## Step 1 — Review Initial SCA Score

```
Wazuh Dashboard → Endpoint Security → Configuration Assessment
→ Select ubuntu-lab-01
→ Select policy: CIS Ubuntu Linux 24.04 LTS Benchmark
→ Record: score, passed count, failed count, not applicable count
→ Expand each failed check to see: title, rationale, remediation, compliance
```

---

## Step 2 — Run Dry Run

Before applying anything, check what the script would change:

```bash
sudo bash scripts/linux_hardening_dry_run.sh
```

Review the output — confirm expected changes match the scope plan.

---

## Step 3 — Deploy Hardening Script

```bash
sudo cp scripts/linux_hardening.sh /var/ossec/active-response/bin/
sudo chown root:wazuh /var/ossec/active-response/bin/linux_hardening.sh
sudo chmod 750 /var/ossec/active-response/bin/linux_hardening.sh
ls -la /var/ossec/active-response/bin/linux_hardening.sh
# Expected: -rwxr-x--- 1 root wazuh
```

---

## Step 4 — Configure Command Module

Add the wodle block from `wazuh/agent-command-module-snippet.xml` to `/var/ossec/etc/ossec.conf` on the Ubuntu endpoint (inside `<ossec_config>`).

```bash
sudo nano /var/ossec/etc/ossec.conf
# Add the wodle block before </ossec_config>
sudo systemctl restart wazuh-agent
```

---

## Step 5 — Verify Script Execution

```bash
# Check hardening log
sudo tail -30 /var/log/wazuh-linux-hardening.log

# Check agent log for command module output
sudo grep "linux-hardening" /var/ossec/logs/ossec.log | tail -20
```

---

## Step 6 — Validate Hardening State

```bash
sudo bash scripts/validate_hardening_state.sh
```

Review the table output — all target controls should show COMPLIANT.

---

## Step 7 — Review Updated SCA Score

Wait for the next SCA scan interval (or restart agent for `scan_on_start`).

```
Wazuh Dashboard → Endpoint Security → Configuration Assessment
→ Select ubuntu-lab-01
→ Note new score and changed counts
→ Filter: data.sca.check.previous_result:failed
→ Confirm previously failed checks now show passed
```
