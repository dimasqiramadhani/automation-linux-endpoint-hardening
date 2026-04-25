# 07 — Policy and Remediation Scope

## Scope Selection Criteria

Not all SCA failures should be automatically remediated. The selection criteria for this lab:

| Criterion | Detail |
|-----------|--------|
| **Safe to automate** | Change cannot cause service outage or connectivity loss |
| **Idempotent** | Applying twice produces no additional change |
| **Reversible** | Can be rolled back via backup restore |
| **No application dependency** | Setting doesn't affect a specific workload's function |
| **CIS-documented** | Has a clear rationale and remediation in the benchmark |

---

## In-Scope Controls (Lab)

| Control ID | Control | Benchmark Section | Automatable |
|-----------|---------|------------------|-------------|
| LH-001 | /dev/shm noexec,nodev,nosuid | 1.1.x Filesystem | ✅ Yes |
| LH-002 | Disable packet redirect sending | 3.1.x Network | ✅ Yes |
| LH-003 | Disable IP forwarding | 3.1.x Network | ✅ Yes |
| LH-004 | Disable source routed packets | 3.1.x Network | ✅ Yes |
| LH-005 | Disable ICMP redirects | 3.1.x Network | ✅ Yes |
| LH-006 | Disable secure ICMP redirects | 3.1.x Network | ✅ Yes |

## Out-of-Scope Controls (Require Manual Review)

| Control | Reason Not Automated |
|---------|---------------------|
| SSH PermitRootLogin | Access risk; requires key auth verified first |
| SSH PasswordAuthentication | Requires confirming key deployment |
| auditd rules | Application-specific; requires workload context |
| PAM password policy | Requires testing with all authentication flows |
| Firewall rules | Application-specific |
| Service minimization | Workload-dependent |

---

## Catatan (Bahasa Indonesia)

Tidak semua konfigurasi yang "failed" di SCA harus langsung diubah secara otomatis. Beberapa perubahan memerlukan review lebih dalam karena bisa memutus koneksi, mematikan layanan, atau mengubah perilaku aplikasi. Scope yang dipilih di lab ini sengaja dibatasi pada setting sysctl dan mount options yang relatif aman dan mudah di-rollback.
