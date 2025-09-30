#!/usr/bin/env bash
set -euo pipefail

# Adds/repairs the Alertmanager tile on the Homepage dashboard.
# Safe to run repeatedly (idempotent).

NODE_IP="${NODE_IP:-192.168.29.50}"

HP_DIR=~/homelab/stacks/homepage
CFG_DIR="$HP_DIR/config"
SERVICES="$CFG_DIR/services.yml"
ICONS_DIR="$HP_DIR/public/icons"
ICON_FILE="$ICONS_DIR/alertmanager.png"

mkdir -p "$CFG_DIR" "$ICONS_DIR"

# 1) Ensure a baseline services.yml (Monitoring group header)
if [[ ! -s "$SERVICES" ]]; then
  printf -- "- Monitoring:\n" > "$SERVICES"
fi

# If the Monitoring section is completely missing, add it once at EOF
grep -q '^- Monitoring:' "$SERVICES" || printf -- "\n- Monitoring:\n" >> "$SERVICES"

# 2) Ensure we have a local icon (download once if not present)
if [[ ! -f "$ICON_FILE" ]]; then
  curl -fsSL \
    https://raw.githubusercontent.com/prometheus/alertmanager/main/ui/app/static/favicon.png \
    -o "$ICON_FILE" || true
fi

# 3) Append the Alertmanager tile if it is not already present
if ! grep -q '^  - Alertmanager:' "$SERVICES"; then
  cat >> "$SERVICES" <<YAML
  - Alertmanager:
      href: http://$NODE_IP:9093
      description: Alerts router (Prometheus)
      status: http://$NODE_IP:9093/-/ready
      target: _blank
      icon: alertmanager.png
YAML
fi

# 4) Bounce Homepage so changes are picked up (uses your standard script)
if [[ -x ~/homelab/ops/restore_homepage.sh ]]; then
  bash ~/homelab/ops/restore_homepage.sh
fi

echo "✅ Homepage tile for Alertmanager ensured. Open: http://$NODE_IP:3000/"
