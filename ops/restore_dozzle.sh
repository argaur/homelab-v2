#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------
# restore_dozzle.sh
# Brings up the Dozzle service in the monitoring stack and verifies it.
# Mirrors the style of restore_homepage.sh (helpers + health check).
# ------------------------------------------------------------------

source ~/homelab/ops/helpers.sh

STACK_DIR=~/homelab/stacks/monitoring
NODE_IP="${NODE_IP:-192.168.29.50}"
DOZZLE_URL="http://$NODE_IP:8888"

log "Restoring Dozzle (monitoring stack)"

# If a separate dozzle.yml is present, include it; otherwise fall back
# to the standard docker-compose.yml + ports.override.yml files.
if [[ -f "$STACK_DIR/dozzle.yml" ]]; then
  ( cd "$STACK_DIR" && \
    docker compose \
      -f docker-compose.yml \
      -f ports.override.yml \
      -f dozzle.yml \
      up -d dozzle )
else
  # If helpers support compose_up, this mirrors restore_homepage.sh style
  compose_up "$STACK_DIR" dozzle
fi

log "Waiting for Dozzle to answer at: $DOZZLE_URL"
expect_http_ok "$DOZZLE_URL"

log "✅ Dozzle is up: $DOZZLE_URL"
