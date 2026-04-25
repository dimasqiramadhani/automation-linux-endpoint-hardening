#!/bin/bash
# =============================================================================
# collect_sca_evidence.sh
# Wazuh Linux Hardening — Evidence Collection Script
#
# Description:
#   Collects system information and hardening state for compliance evidence.
#   Output is saved to a timestamped evidence file.
#   READ-ONLY — does not modify any configuration.
#
# Usage: sudo bash collect_sca_evidence.sh
# ⚠️ Does NOT collect passwords, private keys, tokens, or sensitive secrets.
# =============================================================================

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
EVIDENCE_DIR="evidence"
mkdir -p "$EVIDENCE_DIR"
OUTPUT="$EVIDENCE_DIR/linux-hardening-evidence-${TIMESTAMP}.txt"

collect() {
    echo "$1" >> "$OUTPUT"
    echo "------------------------------------------------------------" >> "$OUTPUT"
    eval "$2" >> "$OUTPUT" 2>&1
    echo "" >> "$OUTPUT"
}

echo "============================================================"
echo " SCA Evidence Collection"
echo " Output: $OUTPUT"
echo "============================================================"

{
echo "============================================================"
echo " Linux Hardening Evidence Report"
echo " Generated: $(date)"
echo " Collector: $(whoami)"
echo "============================================================"
echo ""
} > "$OUTPUT"

collect "HOSTNAME" "hostname -f"
collect "OS VERSION" "lsb_release -a 2>/dev/null || cat /etc/os-release"
collect "KERNEL VERSION" "uname -r"
collect "UPTIME" "uptime"
collect "DATE / TIMEZONE" "date && timedatectl status | grep 'Time zone\|synchronized'"

collect "WAZUH AGENT STATUS" "systemctl status wazuh-agent --no-pager | head -20"
collect "WAZUH AGENT VERSION" "/var/ossec/bin/wazuh-agentd --version 2>/dev/null || echo 'Not found'"

collect "HARDENING LOG (last 30 lines)" "tail -30 /var/log/wazuh-linux-hardening.log 2>/dev/null || echo 'Log not found'"

collect "SYSCTL: send_redirects" "sysctl net.ipv4.conf.all.send_redirects net.ipv4.conf.default.send_redirects"
collect "SYSCTL: ip_forward" "sysctl net.ipv4.ip_forward"
collect "SYSCTL: accept_source_route" "sysctl net.ipv4.conf.all.accept_source_route net.ipv4.conf.default.accept_source_route"
collect "SYSCTL: accept_redirects" "sysctl net.ipv4.conf.all.accept_redirects net.ipv4.conf.default.accept_redirects"
collect "SYSCTL: secure_redirects" "sysctl net.ipv4.conf.all.secure_redirects net.ipv4.conf.default.secure_redirects"

collect "/dev/shm MOUNT OPTIONS" "mount | grep '/dev/shm'"
collect "/etc/fstab (shm entries)" "grep -i 'shm\|tmpfs' /etc/fstab || echo 'No shm/tmpfs entry in fstab'"

collect "SYSCTL CONFIG FILE" "cat /etc/sysctl.d/99-wazuh-hardening.conf 2>/dev/null || echo 'File not found'"

collect "BACKUP FILES" "ls -la /var/backups/wazuh-hardening/ 2>/dev/null || echo 'No backups found'"

{
echo "============================================================"
echo " End of Evidence Report"
echo "============================================================"
} >> "$OUTPUT"

echo ""
echo "Evidence saved to: $OUTPUT"
echo "Lines: $(wc -l < "$OUTPUT")"
echo ""
echo "Review before sharing — redact hostname/IP if publishing."
