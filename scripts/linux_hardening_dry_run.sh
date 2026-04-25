#!/bin/bash
# =============================================================================
# linux_hardening_dry_run.sh
# Wazuh Linux Hardening — Dry Run / Pre-Change Review
#
# Description:
#   Checks the current state of each hardening control WITHOUT making
#   any changes. Shows what the main script WOULD change.
#   Use this before applying hardening for review and evidence.
#
# Usage: sudo bash linux_hardening_dry_run.sh
# ⚠️ READ-ONLY — This script does not modify any configuration.
# =============================================================================

echo "============================================================"
echo " Linux Hardening Dry Run — Pre-Change Review"
echo " Mode: READ-ONLY (no changes applied)"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo " Host: $(hostname)"
echo "============================================================"
echo ""

COMPLIANT=0
NON_COMPLIANT=0

check_sysctl() {
    local key="$1"
    local expected="$2"
    local control="$3"
    local current
    current=$(sysctl -n "$key" 2>/dev/null || echo "UNKNOWN")

    if [[ "$current" == "$expected" ]]; then
        printf "  ✅ COMPLIANT    %-45s current=%s\n" "$key" "$current"
        ((COMPLIANT++)) || true
    else
        printf "  ❌ NON-COMPLIANT %-43s current=%s → would set to %s\n" "$key" "$current" "$expected"
        echo "     Command: sysctl -w ${key}=${expected}"
        ((NON_COMPLIANT++)) || true
    fi
}

echo "--- LH-002: Packet Redirect Sending ---"
check_sysctl "net.ipv4.conf.all.send_redirects"     "0" "LH-002"
check_sysctl "net.ipv4.conf.default.send_redirects" "0" "LH-002"
echo ""

echo "--- LH-003: IP Forwarding ---"
check_sysctl "net.ipv4.ip_forward" "0" "LH-003"
echo ""

echo "--- LH-004: Source Routed Packets ---"
check_sysctl "net.ipv4.conf.all.accept_source_route"     "0" "LH-004"
check_sysctl "net.ipv4.conf.default.accept_source_route" "0" "LH-004"
echo ""

echo "--- LH-005: ICMP Redirects ---"
check_sysctl "net.ipv4.conf.all.accept_redirects"     "0" "LH-005"
check_sysctl "net.ipv4.conf.default.accept_redirects" "0" "LH-005"
echo ""

echo "--- LH-006: Secure ICMP Redirects ---"
check_sysctl "net.ipv4.conf.all.secure_redirects"     "0" "LH-006"
check_sysctl "net.ipv4.conf.default.secure_redirects" "0" "LH-006"
echo ""

echo "--- LH-001: /dev/shm Mount Options ---"
CURRENT_OPTS=$(mount | grep "/dev/shm" | grep -oP '(?<=\().*(?=\))' | head -1)
echo "  Current /dev/shm options: $CURRENT_OPTS"

MISSING=""
for opt in noexec nodev nosuid; do
    if echo "$CURRENT_OPTS" | grep -q "$opt"; then
        echo "  ✅ $opt — present"
    else
        echo "  ❌ $opt — MISSING → would add to /etc/fstab + remount"
        MISSING="$MISSING $opt"
    fi
done

if [[ -n "$MISSING" ]]; then
    ((NON_COMPLIANT++)) || true
else
    ((COMPLIANT++)) || true
fi

echo ""
echo "============================================================"
echo " Dry Run Summary"
echo "  Compliant:     $COMPLIANT controls"
echo "  Non-Compliant: $NON_COMPLIANT controls (would be changed)"
echo ""
if [[ $NON_COMPLIANT -gt 0 ]]; then
    echo "  Run to apply: sudo bash linux_hardening.sh"
fi
echo "============================================================"
