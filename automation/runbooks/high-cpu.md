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

- Identify container
- Restart offending container:
  - `ansible-playbook -i inventory.ini playbooks/restart_container.yml -e "container_name="`
- If unknown container:
  - ansible all -a `docker stats --no-stream`
- Stop non-critical workloads
- If persistent → reboot host

### Verify

- CPU drops below 80%
- Grafana panel returns to normal

### Escalation

- If CPU remains >95% after restart:
  - investigate logs
  - consider resource limits
