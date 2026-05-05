## Disk Usage High

### Trigger

- Alert: Disk > 90%

### Immediate Checks

- `df -h`
- `du -sh /* | sort -h`
- `docker system df`

### Likely Causes

- Logs growing (/var/log)
- Docker images/volumes
- Downloads/media files

### Recovery Actions

- Clean logs:
  - `journalctl --vacuum-time=3d`

- Remove unused containers/images:
  - `docker system prune -a`

- Delete unnecessary files

### Escalation

- If disk >95%:
  - immediate cleanup required
  - risk of service failure
