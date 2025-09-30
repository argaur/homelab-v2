#!/usr/bin/env bash
set -euo pipefail
. ~/homelab/ops/helpers.sh
: "${NODE_IP:=192.168.29.50}"
log "Restore ALL: starting"
for s in \
  restore_portainer.sh \
  restore_adguard.sh \
  restore_vault.sh \
  restore_prometheus.sh \
  restore_grafana.sh \
  restore_cadvisor.sh \
  restore_uptimekuma.sh \
  restore_homepage.sh \
  restore_monitoring.sh
do
  log "==> $s"
  bash "$HOME/homelab/ops/$s"
done
log "Restore ALL: done"
