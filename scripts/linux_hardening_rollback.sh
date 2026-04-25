#!/bin/bash
# =============================================================================
# linux_hardening_rollback.sh
# Wazuh Linux Hardening — Rollback Script
#
# Description:
#   Restores configuration files from backups created by linux_hardening.sh.
#   Requires user confirmation before making any changes.
#
# Usage: sudo bash linux_hardening_rollback.sh
# ⚠️ LAB USE ONLY — Always prefer VM snapshot restore for full rollback.
# =============================================================================

BACKUP_DIR="/var/backups/wazuh-hardening"
SYSCTL_CONF="/etc/sysctl.d/99-wazuh-hardening.conf"

echo "============================================================"
echo " Wazuh Linux Hardening — Rollback"
echo " ⚠️  WARNING: This will revert hardening changes."
echo "============================================================"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run as root (sudo)" && exit 1
fi

# List available backups
echo "Available backups in $BACKUP_DIR:"
ls "$BACKUP_DIR" 2>/dev/null || echo "  No backups found in $BACKUP_DIR"
echo ""

# Confirm
read -rp "Proceed with rollback? [y/N]: " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { echo "Rollback cancelled."; exit 0; }

ROLLED_BACK=0

# Remove wazuh sysctl config
if [[ -f "$SYSCTL_CONF" ]]; then
    rm -f "$SYSCTL_CONF"
    echo "  Removed: $SYSCTL_CONF"
    ((ROLLED_BACK++)) || true
fi

# Restore sysctl.conf backup
SYSCTL_BACKUP=$(ls -t "$BACKUP_DIR"/sysctl.conf.bak_* 2>/dev/null | head -1)
if [[ -n "$SYSCTL_BACKUP" ]]; then
    cp "$SYSCTL_BACKUP" /etc/sysctl.conf
    echo "  Restored: /etc/sysctl.conf from $SYSCTL_BACKUP"
    ((ROLLED_BACK++)) || true
fi

# Restore fstab backup
FSTAB_BACKUP=$(ls -t "$BACKUP_DIR"/fstab.bak_* 2>/dev/null | head -1)
if [[ -n "$FSTAB_BACKUP" ]]; then
    read -rp "Restore /etc/fstab from backup? This will revert /dev/shm changes. [y/N]: " FSTAB_CONFIRM
    if [[ "$FSTAB_CONFIRM" =~ ^[Yy]$ ]]; then
        cp "$FSTAB_BACKUP" /etc/fstab
        echo "  Restored: /etc/fstab from $FSTAB_BACKUP"
        echo "  NOTE: Reboot or manual remount required for fstab changes to take effect."
        ((ROLLED_BACK++)) || true
    fi
fi

# Re-apply sysctl from remaining configs
echo ""
echo "  Applying sysctl --system to reload remaining configs..."
sysctl --system > /dev/null 2>&1 && echo "  sysctl --system: OK"

echo ""
echo "============================================================"
echo " Rollback complete. Items rolled back: $ROLLED_BACK"
echo ""
echo " IMPORTANT:"
echo "   - Some sysctl values may still be set in memory until reboot"
echo "   - /dev/shm changes require remount or reboot"
echo "   - For complete rollback, restore VM snapshot"
echo "   - Restart Wazuh Agent to trigger SCA rescan:"
echo "     sudo systemctl restart wazuh-agent"
echo "============================================================"
