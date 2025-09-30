#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Grafana: looking for stack/containers"
STACK_DIR="${GRAFANA_STACK_DIR:-$(find_stack_dir monitoring 'grafana/grafana|\\bgrafana\\b')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "Grafana: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "Grafana: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^grafana$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:3002/api/health"
log "Grafana: OK"
