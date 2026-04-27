# Screenshots

Lab execution screenshots untuk project **Automated Linux Endpoint Hardening with Wazuh**.  
Diambil pada: **Apr 27, 2026** · Host: `ubuntu-server` · Policy: CIS Ubuntu Linux 24.04 LTS Benchmark v1.0.0

---

## Deployment & Configuration Evidence

| File | Deskripsi |
|------|-----------|
| `Wazuh Remote Command Enable.png` | Setting `wazuh_command.remote_commands=1` di `local_internal_options.conf` |
| `Hardening Script Deploy.png` | Script `linux_hardening.sh` ter-deploy dengan permission `root:wazuh 750` |
| `Woodle Agent Ossec Config.png` | Wodle command block yang sudah ditambahkan ke `ossec.conf` |

---

## Hardening Execution Evidence

| File | Deskripsi |
|------|-----------|
| `Hardening Log Before.png` | Dry run output — menunjukkan 8 controls NON-COMPLIANT sebelum hardening |
| `Hardening Log.png` | Hardening log aktual — `[CHANGED]` entries + summary `Changed: 8, Failed: 0` |
| `Validasi Hardening Status.png` | Output `validate_hardening_state.sh` — semua 12 baris ✅ PASS |

---

## Before Hardening (Baseline — Score 50%)

| File | Deskripsi |
|------|-----------|
| `Security Configuration Assessment - Before.png` | SCA dashboard — Score: 50%, Passed: 119, Failed: 118, N/A: 42 |
| `Security Configuration Assessment - dev-shm Before.png` | /dev/shm checks — 35514/35515/35516 Passed, 35517 (noexec) Failed |
| `Security Configuration Assessment - icmp redirects Before.png` | Check 35609, 35612, 35613 — semua Failed |
| `Security Configuration Assessment - send_redirects Before.png` | Check 35609 (send_redirects) — Failed |
| `Security Configuration Assessment - secure icmp Before.png` | Check 35613 (secure icmp) — Failed |
| `Security Configuration Assessment - source routed Before.png` | Check 35615 (source routed) — Failed |

---

## After Hardening (Score 51%)

| File | Deskripsi |
|------|-----------|
| `Security Configuration Assessment - After.png` | SCA dashboard — Score: 51%, Passed: 123, Failed: 114, N/A: 42 |
| `Security Configuration Assessment - dev-shm After.png` | /dev/shm checks — semua 4 checks Passed (termasuk 35517 noexec) ✅ |
| `Security Configuration Assessment - icmp redirects After.png` | 35609 Passed ✅, 35612 masih Failed (IPv6 gap), 35613 Passed ✅ |
| `Security Configuration Assessment - send_redirects After.png` | Check 35609 (send_redirects) — Passed ✅ |
| `Security Configuration Assessment - secure icmp After.png` | Check 35613 (secure icmp) — Passed ✅ |
| `Security Configuration Assessment - source routed After.png` | Check 35615 (source routed) — Passed ✅ |

---

## Catatan

- Check **35612** (`accept_redirects`) masih Failed setelah hardening. Root cause: CIS policy mengevaluasi IPv6 interfaces (`net.ipv6.conf.*`) dan loopback (`lo`) yang tidak di-cover script. Detail di `docs/16-improvement-ideas.md`.
- Semua screenshot diambil langsung dari terminal dan Wazuh Dashboard tanpa editing.
