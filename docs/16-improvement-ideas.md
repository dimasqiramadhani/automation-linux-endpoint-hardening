# 16 — Improvement Ideas

## 🔬 Observed Gap from Lab Execution (Apr 27, 2026)

Selama eksekusi lab pada `ubuntu-server`, **CIS check 35612** ("Ensure icmp redirects are not accepted") tetap **Failed** setelah hardening, meskipun script berhasil set `net.ipv4.conf.all.accept_redirects = 0`.

**Root cause analysis:**

```bash
# Output sysctl -a | grep accept_redirects dari lab:
net.ipv4.conf.all.accept_redirects = 0       # ✅ set oleh script
net.ipv4.conf.default.accept_redirects = 0   # ✅ set oleh script
net.ipv4.conf.enp1s0.accept_redirects = 0    # ✅ inherited
net.ipv4.conf.lo.accept_redirects = 1        # ❌ loopback — tidak di-set
net.ipv6.conf.all.accept_redirects = 1       # ❌ IPv6 — tidak di-cover
net.ipv6.conf.default.accept_redirects = 1   # ❌ IPv6 — tidak di-cover
net.ipv6.conf.enp1s0.accept_redirects = 1    # ❌ IPv6 — tidak di-cover
net.ipv6.conf.lo.accept_redirects = 1        # ❌ IPv6 loopback — tidak di-cover
```

CIS check 35612 mengevaluasi `net.ipv4.conf.all.accept_redirects` **dan** `net.ipv6.conf.all.accept_redirects`. Kalau salah satu masih non-zero, check tetap Failed. Script saat ini hanya handle IPv4. Ini adalah **scope limitation yang disengaja dan terdokumentasi**.

**Fix untuk Phase 2** — tambahkan ke `linux_hardening.sh`:
```bash
# LH-005 extended — tambahkan setelah IPv4 redirects
apply_sysctl "net.ipv6.conf.all.accept_redirects"     "0" "Disable IPv6 accept_redirects (all)"
apply_sysctl "net.ipv6.conf.default.accept_redirects" "0" "Disable IPv6 accept_redirects (default)"
```

---

## Priority Roadmap

| Priority | Improvement | Effort | Impact |
|----------|-------------|--------|--------|
| High | Extend scope: IPv6 hardening (fix check 35612) | Low | High |
| High | Extend scope: SSH hardening, auditd, password policy | Medium | High |
| High | Automated drift alerting when SCA score drops | Medium | High |
| Medium | Centralized config untuk 50+ endpoints via agent group | Low | High |
| Medium | Ansible integration untuk orchestrated hardening | High | High |
| Medium | Compliance score trend dashboard (Grafana) | Medium | Medium |
| Low | GitHub Actions — YAML lint untuk SCA policies | Low | Medium |

---

## 1. IPv6 Hardening (Phase 2 — Priority Fix)

Extend `linux_hardening.sh` untuk cover parameter IPv6 yang menyebabkan check 35612 tetap Failed:

```bash
# Tambahkan ke linux_hardening.sh — LH-005 extended
apply_sysctl "net.ipv6.conf.all.accept_redirects"     "0" "Disable IPv6 accept_redirects (all)"
apply_sysctl "net.ipv6.conf.default.accept_redirects" "0" "Disable IPv6 accept_redirects (default)"
apply_sysctl "net.ipv6.conf.all.forwarding"           "0" "Disable IPv6 forwarding (all)"
```

---

## 2. Agent Group Centralization

Deploy Command Module config dan hardening script ke semua Ubuntu server via Wazuh agent group:

```bash
# Create group
sudo /var/ossec/bin/agent_groups -a -g ubuntu_hardening

# Add agents
sudo /var/ossec/bin/agent_groups -a -i <agent_id> -g ubuntu_hardening

# Deploy config
cp wazuh/centralized-agent-config-snippet.xml \
   /var/ossec/etc/shared/ubuntu_hardening/agent.conf
```

---

## 3. Extended Hardening Scope

Additional controls untuk fase selanjutnya:

| Phase | Controls |
|-------|---------|
| Phase 2 | IPv6: accept_redirects, forwarding (fix check 35612) |
| Phase 2 | SSH: PermitRootLogin no, MaxAuthTries 4, ClientAlive |
| Phase 3 | auditd rules untuk privileged command logging |
| Phase 4 | PAM password policy: minlen, complexity, history |
| Phase 5 | World-writable file scan and report |
| Phase 6 | SUID/SGID binary review |

---

## 4. SCA Score Drop Alerting

Buat custom Wazuh rule yang fire ketika SCA score turun:
- Alert level: 8 (score drop detected)
- Trigger: `data.sca.score` current < `data.sca.score` previous
- Action: Notify SOC; trigger dry-run verification

---

## 5. OpenSCAP Comparison

Jalankan OpenSCAP berdampingan dengan Wazuh SCA untuk cross-validate findings:

```bash
sudo apt install openscap-scanner
oscap oval eval --report openscap-report.html cis-ubuntu24.oval.xml
```

Bandingkan OpenSCAP findings dengan Wazuh SCA results untuk identify coverage gap.

---

## 6. Approval Workflow Before Remediation

Di production, Command Module sebaiknya tidak apply perubahan otomatis tanpa approval:

```
SCA scan → failed checks identified
         → Jira ticket created per check
         → Change request approval
         → Approved ticket → trigger remediation
         → Validation scan → close ticket
```

Workflow ini mengubah lab automation menjadi production-grade change-managed hardening pipeline.
