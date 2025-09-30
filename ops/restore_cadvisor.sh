#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "cAdvisor: looking for stack/containers"
STACK_DIR="${CADVISOR_STACK_DIR:-$(find_stack_dir monitoring '\\bcadvisor\\b|gcr.io/.*/cadvisor|google/cadvisor')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "cAdvisor: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "cAdvisor: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^cadvisor$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:8082/containers/"
log "cAdvisor: OK"
