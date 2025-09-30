#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
STACK=~/homelab/stacks/homepage
log "Homepage: compose up"
compose_up "$STACK"
expect_http_ok "http://${NODE_IP}:3333"
log "Homepage: OK"
