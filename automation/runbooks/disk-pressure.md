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

- Run cleanup:
  - `ansible-playbook -i inventory.ini playbooks/cleanup_disk.yml`

- Delete unnecessary files

### Verify

- Disk usage < 80%

### Escalation

- If disk >95%:
  - immediate cleanup required
  - risk of service failure
