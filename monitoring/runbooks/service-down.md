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
  - `docker restart <container>`

- Check logs for errors
- Verify ports and config

### Escalation

- If restart fails:
  - inspect logs in detail
  - check host resources
