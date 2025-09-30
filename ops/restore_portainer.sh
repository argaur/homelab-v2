#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Portainer: looking for stack/containers"
STACK_DIR="${PORTAINER_STACK_DIR:-$(find_stack_dir portainer 'portainer|portainer-ce|portainer/portainer-ce')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "Portainer: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "Portainer: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^portainer(-ce)?$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "https://${NODE_IP}:9443/api/status"
log "Portainer: OK"
