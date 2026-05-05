## High CPU Usage

### Trigger

- Alert: CPU > 90% for 5m

### Immediate Checks

- Open Grafana → filter instance
- Check “Top containers by CPU”
- Run:
  - `top`
  - `htop`
  - `docker stats`

### Likely Causes

- Runaway container/process
- Too many concurrent tasks
- Recent deployment or restart loop

### Recovery Actions

- Restart offending container:
  - `docker restart <container>`

- Stop non-critical workloads
- If persistent → reboot host

### Escalation

- If CPU remains >95% after restart:
  - investigate logs
  - consider resource limits
