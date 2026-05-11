#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
VERBOSE=0

for arg in "${@:-}"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

log(){ echo "[*] $*"; }
run(){ [ "$DRY_RUN" -eq 1 ] && echo "$*" || eval "$@"; }

command -v tailscale >/dev/null || { echo "tailscale not found"; exit 1; }

if command -v systemctl >/dev/null 2>&1; then
  systemctl is-active --quiet tailscaled || { echo "tailscaled not active"; exit 1; }
fi

ENV_FILE="/mnt/myssd2/.env"
[ -f "$ENV_FILE" ] || { echo ".env not found"; exit 1; }

log "Loading env"
set -o allexport
source "$ENV_FILE"
set +o allexport

# Internal service ports
ha_PORT="${HOMEASSISTANT_PORT:-8123}"
z2m_PORT="${Z2M_PORT:-8080}"
vault_PORT="${VAULT_WARDEN_PORT:-8010}"
invidious_PORT="${INVIDIOUS_PORT:-8011}"
photoprism_PORT="${PHOTOPRISM_PORT:-8012}"
jellyfin_PORT="${JELLYFIN_PORT:-8015}"
qbit_PORT="${QBITTORRENT_WEBUI_PORT:-8016}"
kuma_PORT="${KUMA_PORT:-8017}"
prometheus_PORT="${PROMETHEUS_PORT:-8018}"
node_exporter_PORT="${NODE_EXPORTER_PORT:-8019}"
grafana_PORT="${GRAFANA_PORT:-8020}"
nodered_PORT="${NODE_RED_PORT:-8022}"
cAdvisor_PORT="${CADVISOR_PORT:-8023}"
heimdall_PORT="${HEIMDALL_PORT:-8024}"
seafile_PORT="${SEAFILE_PORT:-8090}"
couchDB_PORT="${COUCHDB_PORT:-5984}"

# External HTTPS ports (clean mapping)
declare -A ROUTES=(
  [8443]="$ha_PORT"
  [8444]="$z2m_PORT"
  [8445]="$qbit_PORT"
  [8446]="$jellyfin_PORT"
  [8447]="$invidious_PORT"
  [8448]="$photoprism_PORT"
  [8449]="$vault_PORT"
  [8450]="$kuma_PORT"
  [8451]="$grafana_PORT"
  [8452]="$nodered_PORT"
  [8453]="$heimdall_PORT"
  [8454]="$seafile_PORT"
  [8456]="$cAdvisor_PORT"
  [8457]="$prometheus_PORT"
  [8458]="$node_exporter_PORT"
)

echo
log "Planned mappings:"
for ext in "${!ROUTES[@]}"; do
  printf "  https://<tailnet>:%s -> http://127.0.0.1:%s\n" "$ext" "${ROUTES[$ext]}"
done | sort

echo
read -rp "Proceed? [y/N]: " OK
[[ "${OK,,}" =~ ^(y|yes)$ ]] || { echo "Aborted."; exit 0; }

log "Set operator"
run "sudo tailscale set --operator=\"$USER\""

log "Reset serve config"
run "tailscale serve reset"

log "Applying routes"
for ext in "${!ROUTES[@]}"; do
  port="${ROUTES[$ext]}"
  cmd="tailscale serve --bg --https=$ext http://127.0.0.1:$port"
  log "$ext -> $port"
  run "$cmd"
done

echo
log "Final status:"
run "tailscale serve status"
