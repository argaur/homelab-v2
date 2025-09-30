#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Prometheus: looking for stack/containers"
STACK_DIR="${PROM_STACK_DIR:-$(find_stack_dir monitoring 'prom/prometheus|\\bprometheus\\b')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "Prometheus: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "Prometheus: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^prometheus$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:9090/-/ready"
log "Prometheus: OK"
