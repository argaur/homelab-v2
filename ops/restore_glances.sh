#!/bin/bash
set -e
source ~/homelab/ops/helpers.sh

log "Starting Glances deployment..."
compose_up "$HOME/homelab/stacks/glances"
# The web UI is on port 61208
expect_http_ok "http://192.168.29.50:61208" 
log "Glances deployment successful!"
