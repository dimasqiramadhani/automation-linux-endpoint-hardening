# Remediation Checklist

Gunakan checklist ini sebelum, selama, dan setelah hardening exercise.

---

## Pre-Hardening

- [ ] **VM snapshot created** — beri nama dengan tanggal, contoh: `pre-hardening-baseline-YYYY-MM-DD`
- [ ] **Remote commands enabled** — `wazuh_command.remote_commands=1` ada di `local_internal_options.conf`
- [ ] **SCA baseline recorded** — catat score, passed, failed, not applicable
- [ ] **Target controls confirmed Failed** — verifikasi 6 control LH-001 s/d LH-006 statusnya Failed di dashboard
- [ ] **Dry run executed** — `bash scripts/linux_hardening_dry_run.sh` dijalankan dan outputnya direview
- [ ] **Script deployed** — `linux_hardening.sh` ada di `/var/ossec/active-response/bin/`
- [ ] **Permissions verified** — `root:wazuh` ownership, `750` permission confirmed via `ls -la`
- [ ] **ossec.conf backed up** — `cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.bak`

---

## During Hardening

- [ ] **Command Module configured** — wodle block ditambahkan ke `ossec.conf`
- [ ] **Wazuh Agent restarted** — `systemctl restart wazuh-agent`
- [ ] **Agent status confirmed** — `systemctl status wazuh-agent` menunjukkan `active (running)`
- [ ] **Script execution confirmed** — hardening log dicek: `tail /var/log/wazuh-linux-hardening.log`
- [ ] **No errors in log** — semua control menunjukkan CHANGED atau COMPLIANT (tidak ada FAILED)
- [ ] **Summary verified** — log menunjukkan `Changed: X, Failed: 0`

---

## Post-Hardening Validation

- [ ] **validate_hardening_state.sh run** — semua baris menunjukkan ✅ PASS
- [ ] **sysctl values verified manual** — `sysctl net.ipv4.conf.all.send_redirects` dll mengembalikan `0`
- [ ] **/dev/shm options verified** — `mount | grep shm` menunjukkan `nosuid,nodev,noexec`
- [ ] **Persistent config exists** — `cat /etc/sysctl.d/99-wazuh-hardening.conf` berisi value hardening
- [ ] **Idempotency tested** — restart agent sekali lagi, cek log run kedua menunjukkan `Changed: 0`
- [ ] **SCA rescan triggered** — agent direstart, tunggu scan selesai
- [ ] **Updated SCA score noted** — catat score after hardening
- [ ] **Per-control status verified** — search setiap control di dashboard, konfirmasi status Passed

---

## Evidence and Reporting

- [ ] **Dry run log saved** — `bash scripts/linux_hardening_dry_run.sh | tee ~/dry-run-evidence-$(date +%F).log`
- [ ] **Validation log saved** — `bash scripts/validate_hardening_state.sh | tee ~/validation-after-$(date +%F).log`
- [ ] **Evidence collected** — `bash scripts/collect_sca_evidence.sh`
- [ ] **Script hash recorded** — `sha256sum /var/ossec/active-response/bin/linux_hardening.sh`
- [ ] **Screenshots captured** — before dan after sesuai panduan di `screenshots/README.md`
- [ ] **Before-after report updated** — `reports/sample-before-after-sca-score-report.md` diisi data aktual
- [ ] **Assessment report updated** — `reports/sample-linux-hardening-assessment-report.md` diisi data aktual

---

## Rollback Plan

- [ ] **VM snapshot available** — cara tercepat untuk full rollback
- [ ] **Backup files available** — `/var/backups/wazuh-hardening/` berisi backup fstab dan sysctl.conf
- [ ] **Rollback script tersedia** — `bash scripts/linux_hardening_rollback.sh` (jika perlu rollback via script)
