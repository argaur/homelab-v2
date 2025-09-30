#!/usr/bin/env bash
set -euo pipefail

# Restore Alertmanager in the monitoring stack and verify readiness.
# Uses ops/helpers.sh (log, compose_up, expect_http_ok).

source ~/homelab/ops/helpers.sh

STACK_DIR=~/homelab/stacks/monitoring
NODE_IP="${NODE_IP:-192.168.29.50}"
AM_URL="http://$NODE_IP:9093"

log "Bringing up Alertmanager (monitoring stack)…"
compose_up "$STACK_DIR" alertmanager

log "Waiting for Alertmanager readiness…"
expect_http_ok "$AM_URL/-/ready"

log "✅ Alertmanager is up at $AM_URL"
log "Optional quick status:  curl -s $AM_URL/api/v2/status | jq"
