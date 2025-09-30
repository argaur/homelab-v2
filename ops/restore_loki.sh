#!/usr/bin/env bash
set -euo pipefail

# conventions: NODE_IP=192.168.29.50, network=core, restart=unless-stopped
# requires: ~/homelab/ops/helpers.sh (compose_up, expect_http_ok, log)

source ~/homelab/ops/helpers.sh

STACK_DIR=~/homelab/stacks/monitoring

log "Bringing up Loki + Promtail (with ports override)…"
pushd "$STACK_DIR" >/dev/null
docker compose -f docker-compose.yml -f ports.override.yml up -d loki promtail
popd >/dev/null

# Loki readiness probe
expect_http_ok "http://$NODE_IP:3100/ready"
log "Loki is ready (HTTP 200)."

log "Tip: tail promtail logs if needed →  docker logs -n 200 -f promtail"
