#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "AdGuard: looking for stack/containers"
STACK_DIR="${ADGUARD_STACK_DIR:-$(find_stack_dir adguard 'adguard|adguardhome|adguard/adguardhome')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "AdGuard: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "AdGuard: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^adguard(home)?$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:8080/"
log "AdGuard: OK"
