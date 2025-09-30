#!/usr/bin/env bash
set -euo pipefail

STACK=~/homelab/stacks/n8n
cd "$STACK"

echo "==> Bringing up n8n + Postgres…"
docker compose -f docker-compose.yml -f ports.override.yml up -d

# wait for n8n health
echo "==> Waiting for n8n readiness…"
for i in {1..30}; do
  code=$(curl -fsS -o /dev/null -w "%{http_code}" http://127.0.0.1:5678/healthz || true)
  if [[ "$code" == "200" ]]; then
    echo "n8n is ready (HTTP 200)."
    exit 0
  fi
  sleep 3
done

echo "ERROR: n8n health check did not return 200 within timeout." >&2
docker compose ps
exit 1
