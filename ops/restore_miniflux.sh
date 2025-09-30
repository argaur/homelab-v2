#!/bin/bash
set -e

# Source the helper functions
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Miniflux deployment..."

# Check for Vault token
if [ -z "$VAULT_TOKEN" ]; then
  log "Error: VAULT_TOKEN environment variable is not set."
  log "Usage: VAULT_TOKEN=<your_token> bash ~/homelab/ops/restore_miniflux.sh"
  exit 1
fi

STACK_DIR=~/homelab/stacks/miniflux
SECRET_PATH="kv/miniflux/credentials"

log "Fetching secrets from Vault at path: $SECRET_PATH"
# Fetch all secrets and export them for docker-compose
export DATABASE_URL=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=DATABASE_URL "$SECRET_PATH")
export ADMIN_USERNAME=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=ADMIN_USERNAME "$SECRET_PATH")
export ADMIN_PASSWORD=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=ADMIN_PASSWORD "$SECRET_PATH")

if [ -z "$DATABASE_URL" ]; then
  log "Error: Failed to fetch critical secrets from Vault. Please check your token and the secret path."
  exit 1
fi

log "Secrets fetched successfully. Launching stack..."
compose_up "$STACK_DIR"

HEALTH_URL="http://192.168.29.50:8089"
log "Waiting for Miniflux to be healthy at $HEALTH_URL..."
expect_http_ok "$HEALTH_URL"

log "Miniflux deployment successful!"
