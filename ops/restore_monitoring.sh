#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
STACK=~/homelab/stacks/monitoring
log "Monitoring: compose up (stack)"
compose_up "$STACK"

log "Monitoring: HTTP health checks"
expect_http_ok "http://${NODE_IP}:9090/-/ready"       # Prometheus
expect_http_ok "http://${NODE_IP}:3002/api/health"     # Grafana
expect_http_ok "http://${NODE_IP}:8082/containers/"    # cAdvisor
expect_http_ok "http://${NODE_IP}:3001/status"         # Uptime Kuma
log "Monitoring: OK"
