#!/usr/bin/env bash
set -euo pipefail
STACK=~/homelab/stacks/nocodb
cd "$STACK"
docker compose up -d
# Simple readiness check
for i in {1..30}; do
  if docker exec nocodb sh -lc 'wget -qO- http://127.0.0.1:8080/api/v1/health' >/dev/null 2>&1; then
    echo "NocoDB is ready."
    exit 0
  fi
  sleep 2
done
echo "NocoDB did not become ready in time." >&2
exit 1
