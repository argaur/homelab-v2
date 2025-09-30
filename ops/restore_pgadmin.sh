#!/bin/bash
set -e

# Source the helper functions
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting pgAdmin deployment..."

# Check for Vault token
if [ -z "$VAULT_TOKEN" ]; then
  log "Error: VAULT_TOKEN environment variable is not set."
  log "Usage: VAULT_TOKEN=<your_token> bash ~/homelab/ops/restore_pgadmin.sh"
  exit 1
fi

STACK_DIR=~/homelab/stacks/pgadmin
SECRET_PATH="kv/pgadmin/initial_user"

log "Fetching secrets from Vault at path: $SECRET_PATH"
# Fetch secrets from Vault and export them for docker-compose
export PGADMIN_EMAIL=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=email "$SECRET_PATH")
export PGADMIN_PASSWORD=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=password "$SECRET_PATH")

if [ -z "$PGADMIN_EMAIL" ] || [ -z "$PGADMIN_PASSWORD" ]; then
  log "Error: Failed to fetch secrets from Vault. Please check your token and the secret path."
  exit 1
fi

log "Secrets fetched successfully. Launching stack..."
compose_up "$STACK_DIR"

HEALTH_URL="http://192.168.29.50:8086"
log "Waiting for pgAdmin to be healthy at $HEALTH_URL..."
# pgAdmin can be slow to start, so we'll give it a longer timeout
expect_http_ok "$HEALTH_URL" 120

log "pgAdmin deployment successful!"
