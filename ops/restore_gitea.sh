#!/bin/bash
set -e
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Gitea deployment..."
compose_up "$HOME/homelab/stacks/gitea"
# Gitea can be slow on first launch, so wait up to 2 minutes
expect_http_ok "http://192.168.29.50:3004" 120
log "Gitea deployment successful!"
log "Access it at http://192.168.29.50:3004 to complete initial setup."
