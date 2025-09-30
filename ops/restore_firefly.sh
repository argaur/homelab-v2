#!/bin/bash
set -e
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Firefly III deployment..."

# Check for Vault token
if [ -z "$VAULT_TOKEN" ]; then
  log "Error: VAULT_TOKEN environment variable is not set."
  log "Usage: VAULT_TOKEN=<your_token> bash ~/homelab/ops/restore_firefly.sh"
  exit 1
fi

STACK_DIR=~/homelab/stacks/firefly
SECRET_PATH="kv/firefly/secrets"

log "Fetching secrets from Vault at path: $SECRET_PATH"
# Fetch all secrets and export them for docker-compose
export DB_DATABASE=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=DB_DATABASE "$SECRET_PATH")
export DB_USER=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=DB_USER "$SECRET_PATH")
export DB_PASSWORD=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=DB_PASSWORD "$SECRET_PATH")
export APP_KEY=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=APP_KEY "$SECRET_PATH")
export SITE_OWNER=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SITE_OWNER "$SECRET_PATH")
export TRUSTED_PROXIES=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=TRUSTED_PROXIES "$SECRET_PATH")

if [ -z "$DB_PASSWORD" ] || [ -z "$APP_KEY" ]; then
  log "Error: Failed to fetch critical secrets from Vault. Please check your token and the secret path."
  exit 1
fi

log "Secrets fetched successfully. Launching stack..."
compose_up "$STACK_DIR"

HEALTH_URL="http://192.168.29.50:8088"
log "Waiting for Firefly III to be healthy at $HEALTH_URL..."
# Firefly can be slow on first start as it runs migrations
expect_http_ok "$HEALTH_URL" 180

log "Firefly III deployment successful!"
