#!/bin/bash
set -e
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Remote Desktop deployment..."
compose_up "$HOME/homelab/stacks/remote-desktop"
expect_http_ok "http://192.168.29.50:3003" 300
log "Remote Desktop deployment successful!"
log "Access it at http://192.168.29.50:3003"
