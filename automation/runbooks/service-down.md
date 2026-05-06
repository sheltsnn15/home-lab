## Service Down

### Trigger

- Uptime Kuma alert: monitor_status = 0

### Immediate Checks

- Open service URL
- Check container:
  - `docker ps`
  - `docker logs <container>`

### Likely Causes

- Container crashed
- Port conflict
- Dependency unavailable

### Recovery Actions

- Restart service:
  - `ansible-playbook -i inventory.ini playbooks/restart_container.yml -e "container_name="`

- Check logs for errors
- Verify ports and config

### Verify

- Service reachable via URL
- Uptime Kuma returns to UP

### Escalation

- If restart fails:
  - inspect logs in detail
  - check host resources
