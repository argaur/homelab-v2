#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Vault: looking for stack/containers"
STACK_DIR="${VAULT_STACK_DIR:-$(find_stack_dir vault 'hashicorp/vault|\\bvault\\b')}"
if [[ -n "${STACK_DIR:-}" ]]; then
  log "Vault: compose up ($STACK_DIR)"
  compose_up "$STACK_DIR"
else
  log "Vault: no compose dir; restarting container(s)"
  docker ps -a --format '{{.Names}}' | awk '/^vault$/ {print $1}' | xargs -r -n1 docker restart
fi
expect_http_ok "http://${NODE_IP}:18201/v1/sys/health"
log "Vault: OK"
