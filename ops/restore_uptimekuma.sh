#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Uptime Kuma: looking for stack/containers"
STACK_DIR="${KUMA_STACK_DIR:-$(find_stack_dir monitoring 'uptime[- ]?kuma|louislam/uptime-kuma|\\bkuma\\b')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "Uptime Kuma: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "Uptime Kuma: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^uptime-?kuma$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:3001/status"
log "Uptime Kuma: OK"
