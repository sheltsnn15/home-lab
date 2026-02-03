# Home Lab — Self-Hosted Services

Personal homelab stack running on Docker Compose. Focus: **secure access**, **monitoring/alerting**, and **repeatable ops** (runbooks + backups).

## What’s in here

- **Home Automation:** Home Assistant, Zigbee2MQTT, Mosquitto, Node-RED
- **Monitoring:** Prometheus, cAdvisor, node-exporter, Grafana, Uptime Kuma
- **Media / Apps:** Jellyfin, PhotoPrism, qBittorrent, Heimdall, CouchDB LiveSync, Watchtower
- **Networking/Access:** services exposed locally (and optionally via a private tunnel / reverse proxy)

## Repo structure

- `homeassistant/` — HA + Zigbee2MQTT + Mosquitto + Node-RED compose + config
- `monitoring/` — Prometheus/Grafana exporters + Uptime Kuma + AdGuard
- `jellyfin/`, `photoprism/`, `qbittorrent/`, `heimdall/`, `couchdb-livesync/`, `watchtower/` — per-service compose/config

## Bring up a stack

From the service folder:

```bash
docker compose up -d

```
