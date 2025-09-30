#!/bin/bash
set -e
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Agent DVR deployment..."
compose_up "$HOME/homelab/stacks/agent-dvr"
expect_http_ok "http://192.168.29.50:8090"
log "Agent DVR deployment successful!"
