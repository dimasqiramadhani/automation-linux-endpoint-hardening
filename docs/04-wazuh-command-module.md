# 04 — Wazuh Command Module

## What Is the Command Module?

The Wazuh **Command Module** (`wodle name="command"`) allows the Wazuh Agent to execute operating system commands or scripts at defined intervals. It is a general-purpose automation capability built into every Wazuh Agent.

---

## How It Works in This Project

1. The `linux_hardening.sh` script is placed at `/var/ossec/active-response/bin/`
2. The Command Module is configured in the agent's `ossec.conf` (or via centralized group config)
3. On agent start (if `run_on_start: yes`) and at each `interval`, the script runs as root
4. Script output is captured and visible in Wazuh Manager logs
5. The script applies hardening controls and logs results to `/var/log/wazuh-linux-hardening.log`

---

## Configuration Parameters

```xml
<wodle name="command">
  <disabled>no</disabled>
  <tag>linux-hardening</tag>
  <command>/var/ossec/active-response/bin/linux_hardening.sh</command>
  <interval>12h</interval>
  <ignore_output>no</ignore_output>
  <run_on_start>yes</run_on_start>
  <timeout>120</timeout>
</wodle>
```

| Parameter | Value | Meaning |
|-----------|-------|---------|
| `disabled` | no | Module is active |
| `tag` | linux-hardening | Label for log correlation |
| `command` | full path to script | What to execute |
| `interval` | 12h | Run every 12 hours |
| `ignore_output` | no | Capture script stdout/stderr |
| `run_on_start` | yes | Run immediately when agent starts |
| `timeout` | 120 | Kill script if it runs longer than 120 seconds |

---

## Security Considerations for the Command Module

The Command Module runs with the same privileges as the Wazuh Agent — which in this lab, is root. This means:

- **The script must be trusted** — owned by root, not writable by others
- **Permission must be `750`** — readable/executable by wazuh group, not world-readable
- **The script must be idempotent** — safe to run repeatedly without unintended side effects
- **Scope must be limited** — only apply what is explicitly required; no destructive operations
- **All changes must be logged** — for audit and rollback purposes
