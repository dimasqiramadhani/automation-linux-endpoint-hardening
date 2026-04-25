# 10 — SCA Score Before and After

## Measurement Method

SCA scores are captured from the Wazuh Dashboard before and after running the hardening script. The key metrics are:

- **Score %** — overall compliance percentage
- **Passed checks** — checks where configuration meets the benchmark
- **Failed checks** — checks where configuration does not meet the benchmark
- **Not applicable** — checks skipped due to system context

---

## Before / After Comparison Table

> All values below are example lab results. Actual numbers depend on OS version, installed packages, Wazuh version, and existing configuration.

| Metric | Before Hardening | After Hardening | Change |
|--------|-----------------|----------------|--------|
| SCA Score | 44% | 53% | +9% |
| Passed Checks | 100 | 135 | +35 |
| Failed Checks | 127 | 92 | −35 |
| Not Applicable | 53 | 53 | — |
| Remediated Controls | 0 | 6 | +6 |

---

## Improved Checks (Example)

| Check | Before | After |
|-------|--------|-------|
| Ensure /dev/shm has noexec option | failed | ✅ passed |
| Ensure /dev/shm has nodev option | failed | ✅ passed |
| Ensure /dev/shm has nosuid option | failed | ✅ passed |
| Ensure packet redirect sending is disabled | failed | ✅ passed |
| Ensure IP forwarding is disabled | failed | ✅ passed |
| Ensure source routed packets are not accepted | failed | ✅ passed |
| Ensure ICMP redirects are not accepted | failed | ✅ passed |
| Ensure secure ICMP redirects are not accepted | failed | ✅ passed |

---

## How to Read Status Changed Events

In Wazuh Dashboard, filter:
```
data.sca.check.previous_result:failed
```

This shows all checks that changed from failed to any other result. Expand each event to see:
- `data.sca.check.title` — what changed
- `data.sca.check.result` — current result (passed)
- `data.sca.check.previous_result` — previous result (failed)
- `data.sca.check.remediation` — what was done to fix it

---

## Catatan (Bahasa Indonesia)

Kenaikan skor SCA menunjukkan bahwa konfigurasi endpoint sekarang lebih dekat ke standar CIS Benchmark. Tapi ingat: kenaikan persentase ini bukan jaminan keamanan absolut. Ada checks lain yang masih failed dan perlu dianalisis satu per satu dengan konteks yang tepat sebelum diputuskan untuk diremediate atau diterima risikonya.
