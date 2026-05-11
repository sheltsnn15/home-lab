#!/usr/bin/env bash

set -euo pipefail

export LANG=C.UTF-8
export LC_ALL=C.UTF-8

TIMESTAMP=$(date +%Y%m%d-%H%M)
LOG_DIR="/mnt/myssd2/automation/ansible/reports"
LOG_FILE="$LOG_DIR/update-$TIMESTAMP.log"

mkdir -p "$LOG_DIR"

echo "Started: $(date)"
echo ""

ansible-playbook \
  -i /mnt/myssd2/automation/ansible/inventory.ini \
  /mnt/myssd2/automation/ansible/playbooks/update-containers.yml \
  2>&1 | tee "$LOG_FILE"

echo ""
echo "Log saved to:"
echo "$LOG_FILE"
