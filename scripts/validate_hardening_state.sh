#!/bin/bash
# =============================================================================
# validate_hardening_state.sh
# Wazuh Linux Hardening — Validation Evidence Script
#
# Description:
#   Checks the current state of all hardening controls and outputs
#   a formatted validation table. READ-ONLY — no changes made.
#
# Usage: sudo bash validate_hardening_state.sh
# =============================================================================

echo "============================================================"
echo " Linux Hardening State Validation"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S')"
echo " Host: $(hostname)"
echo " Mode: READ-ONLY"
echo "============================================================"
echo ""
printf "%-8s %-48s %-10s %-8s %s\n" "Control" "Parameter" "Expected" "Current" "Status"
printf "%-8s %-48s %-10s %-8s %s\n" "-------" "---------" "--------" "-------" "------"

check() {
    local ctrl="$1"
    local key="$2"
    local expected="$3"
    local current
    current=$(sysctl -n "$key" 2>/dev/null || echo "N/A")
    local status
    if [[ "$current" == "$expected" ]]; then
        status="✅ PASS"
    else
        status="❌ FAIL"
    fi
    printf "%-8s %-48s %-10s %-8s %s\n" "$ctrl" "$key" "$expected" "$current" "$status"
}

check "LH-002" "net.ipv4.conf.all.send_redirects"     "0"
check "LH-002" "net.ipv4.conf.default.send_redirects" "0"
check "LH-003" "net.ipv4.ip_forward"                  "0"
check "LH-004" "net.ipv4.conf.all.accept_source_route"     "0"
check "LH-004" "net.ipv4.conf.default.accept_source_route" "0"
check "LH-005" "net.ipv4.conf.all.accept_redirects"     "0"
check "LH-005" "net.ipv4.conf.default.accept_redirects" "0"
check "LH-006" "net.ipv4.conf.all.secure_redirects"     "0"
check "LH-006" "net.ipv4.conf.default.secure_redirects" "0"

echo ""
echo "--- LH-001: /dev/shm Mount Options ---"
CURRENT_OPTS=$(mount | grep "/dev/shm" | grep -oP '(?<=\().*(?=\))' | head -1)
echo "  Current options: $CURRENT_OPTS"
for opt in noexec nodev nosuid; do
    if echo "$CURRENT_OPTS" | grep -q "$opt"; then
        echo "  ✅ $opt"
    else
        echo "  ❌ $opt — MISSING"
    fi
done

echo ""
echo "--- Persistent Config File ---"
if [[ -f "/etc/sysctl.d/99-wazuh-hardening.conf" ]]; then
    echo "  ✅ /etc/sysctl.d/99-wazuh-hardening.conf exists"
    echo "  Contents:"
    grep -v "^#\|^$" /etc/sysctl.d/99-wazuh-hardening.conf | sed 's/^/    /'
else
    echo "  ❌ /etc/sysctl.d/99-wazuh-hardening.conf NOT found"
fi
echo ""
echo "============================================================"
echo " Validation complete."
echo " Use as manual evidence for SCA report."
echo "============================================================"
