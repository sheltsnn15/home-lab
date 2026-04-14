#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0; VERBOSE=0
for arg in "${@:-}"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    --verbose|-v) VERBOSE=1 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done
log(){ echo "[*] $*"; }
vlog(){ [ "$VERBOSE" -eq 1 ] && echo "[v] $*"; }
run(){ [ "$DRY_RUN" -eq 1 ] && echo "$*" || eval "$@"; }

command -v tailscale >/dev/null || { echo "tailscale not found in PATH"; exit 1; }
vlog "tailscale version: $(tailscale version 2>/dev/null || echo unknown)"
if command -v systemctl >/dev/null 2>&1; then
  systemctl is-active --quiet tailscaled || { echo "tailscaled not active"; exit 1; }
fi

ENV_FILE="/mnt/myssd/.env"
declare -A ENVV=()
if [ -f "$ENV_FILE" ]; then
  log "Reading env from $ENV_FILE (safe parser)"
  while IFS= read -r line; do
    line="${line%$'\r'}"                    # drop trailing CR if any
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"; val="${BASH_REMATCH[2]}"
      ENVV["$key"]="$val"
    fi
  done < "$ENV_FILE"
fi

HA_PORT_DEFAULT="${ENVV[HOMEASSISTANT_PORT]:-8123}"
Z2M_PORT_DEFAULT="${ENVV[Z2M_PORT]:-8080}"
INVIDIOUS_PORT_DEFAULT="${ENVV[INVIDIOUS_PORT]:-8011}"
PHOTOPRISM_PORT_DEFAULT="${ENVV[PHOTOPRISM_PORT]:-8012}"
JELLYFIN_PORT_DEFAULT="${ENVV[JELLYFIN_PORT]:-8015}"
QBIT_PORT_DEFAULT="${ENVV[QBITTORRENT_WEBUI_PORT]:-8016}"
KUMA_PORT_DEFAULT="${ENVV[UPTIME_KUMA_PORT]:-8017}"
GRAFANA_PORT_DEFAULT="${ENVV[GRAFANA_PORT]:-8020}"
NODERED_PORT_DEFAULT="${ENVV[NODE_RED_PORT]:-8022}"
ADGUARD_PORT_DEFAULT="${ENVV[ADGUARD_PORT]:-8023}"

echo
echo "Detected defaults (Enter=accept):"
read -rp "Home Assistant port [${HA_PORT_DEFAULT}]: " HA_PORT; HA_PORT="${HA_PORT:-$HA_PORT_DEFAULT}"
read -rp "Zigbee2MQTT port [${Z2M_PORT_DEFAULT}]: " Z2M_PORT; Z2M_PORT="${Z2M_PORT:-$Z2M_PORT_DEFAULT}"
read -rp "Invidious port [${INVIDIOUS_PORT_DEFAULT}]: " INVIDIOUS_PORT; INVIDIOUS_PORT="${INVIDIOUS_PORT:-$INVIDIOUS_PORT_DEFAULT}"
read -rp "PhotoPrism port [${PHOTOPRISM_PORT_DEFAULT}]: " PHOTOPRISM_PORT; PHOTOPRISM_PORT="${PHOTOPRISM_PORT:-$PHOTOPRISM_PORT_DEFAULT}"
read -rp "Jellyfin port [${JELLYFIN_PORT_DEFAULT}]: " JELLYFIN_PORT; JELLYFIN_PORT="${JELLYFIN_PORT:-$JELLYFIN_PORT_DEFAULT}"
read -rp "qBittorrent WebUI port [${QBIT_PORT_DEFAULT}]: " QBIT_PORT; QBIT_PORT="${QBIT_PORT:-$QBIT_PORT_DEFAULT}"
read -rp "Uptime Kuma port [${KUMA_PORT_DEFAULT}]: " KUMA_PORT; KUMA_PORT="${KUMA_PORT:-$KUMA_PORT_DEFAULT}"
read -rp "Grafana port [${GRAFANA_PORT_DEFAULT}]: " GRAFANA_PORT; GRAFANA_PORT="${GRAFANA_PORT:-$GRAFANA_PORT_DEFAULT}"
read -rp "AdGuard port [${ADGUARD_PORT_DEFAULT}]: " ADGUARD_PORT; ADGUARD_PORT="${ADGUARD_PORT:-$ADGUARD_PORT_DEFAULT}"
read -rp "Node-RED port [${NODERED_PORT_DEFAULT}]: " NODERED_PORT; NODERED_PORT="${NODERED_PORT:-$NODERED_PORT_DEFAULT}"

echo
log "Planned Serve mappings (private HTTPS inside tailnet):"
echo "  8443 -> http://127.0.0.1:${HA_PORT}          # Home Assistant"
echo "  8444 -> http://127.0.0.1:${Z2M_PORT}         # Zigbee2MQTT"
echo "  8445 -> http://127.0.0.1:${QBIT_PORT}        # qBittorrent"
echo "  8446 -> http://127.0.0.1:${JELLYFIN_PORT}    # Jellyfin"
echo "  8447 -> http://127.0.0.1:${INVIDIOUS_PORT}   # Invidious"
echo "  8448 -> http://127.0.0.1:${PHOTOPRISM_PORT}  # PhotoPrism"
echo "  8450 -> http://127.0.0.1:${KUMA_PORT}        # Uptime Kuma"
echo "  8451 -> http://127.0.0.1:${GRAFANA_PORT}     # Grafana"
echo "  8452 -> http://127.0.0.1:${ADGUARD_PORT}     # AdGuard"
echo "  8454 -> http://127.0.0.1:${NODERED_PORT}     # Node-RED"
read -rp "Proceed? [y/N]: " OK; case "${OK,,}" in y|yes) ;; *) echo "Aborted."; exit 0;; esac

OUTDIR="$HOME/tailscale_collection"; OUTCMDS="$OUTDIR/tailscale_commands_cleaned.txt"
mkdir -p "$OUTDIR"; : > "$OUTCMDS"
note(){ echo "$*" | tee -a "$OUTCMDS" >/dev/null; }

note "== Tailscale Serve (clean, most-recent mappings) =="
note "# Allow current user to manage Serve without sudo"
note "sudo tailscale set --operator=\"\$USER\""
run "sudo tailscale set --operator=\"\$USER\""

TARGET_PORTS=(8443 8444 8445 8446 8447 8448 8450 8451 8452 8454)
note ""; note "# Clear target ports (no-op if absent)"
for p in "${TARGET_PORTS[@]}"; do
  note "tailscale serve --https=$p --set-path=/ off || true"
  run "tailscale serve --https=$p --set-path=/ off || true"
done

declare -A MAPS=(
  [8443]="$HA_PORT" [8444]="$Z2M_PORT" [8445]="$QBIT_PORT" [8446]="$JELLYFIN_PORT"
  [8447]="$INVIDIOUS_PORT" [8448]="$PHOTOPRISM_PORT" [8450]="$KUMA_PORT"
  [8451]="$GRAFANA_PORT" [8452]="$ADGUARD_PORT" [8454]="$NODERED_PORT"
)
note ""; note "# Recreate dedicated-port routes"
for p in "${!MAPS[@]}"; do
  url="http://127.0.0.1:${MAPS[$p]}"
  note "tailscale serve --bg --https=$p --set-path=/ $url"
  run "tailscale serve --bg --https=$p --set-path=/ $url"
done

note ""; note "# Show result"; note "tailscale serve status"
log "Commands written to: $OUTCMDS"
run "tailscale serve status"
