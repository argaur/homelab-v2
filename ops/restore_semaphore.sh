#!/bin/bash
set -e
# shellcheck source=/dev/null
source ~/homelab/ops/helpers.sh

log "Starting Ansible Semaphore deployment..."

# Check for Vault token
if [ -z "$VAULT_TOKEN" ]; then
  log "Error: VAULT_TOKEN environment variable is not set."
  log "Usage: VAULT_TOKEN=<your_token> bash ~/homelab/ops/restore_semaphore.sh"
  exit 1
fi

STACK_DIR=~/homelab/stacks/semaphore
SECRET_PATH="kv/semaphore/secrets"

log "Fetching secrets from Vault at path: $SECRET_PATH"
# Fetch all secrets and export them with the correct names for docker-compose
export DB_PASS=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=DB_PASS "$SECRET_PATH")
export SEMAPHORE_ENCRYPTION_KEY=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SEMAPHORE_ENCRYPTION_KEY "$SECRET_PATH")
export SEMAPHORE_ADMIN_USER=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SEMAPHORE_ADMIN_USER "$SECRET_PATH")
export SEMAPHORE_ADMIN_NAME=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SEMAPHORE_ADMIN_NAME "$SECRET_PATH")
export SEMAPHORE_ADMIN_EMAIL=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SEMAPHORE_ADMIN_EMAIL "$SECRET_PATH")
export SEMAPHORE_ADMIN_PASSWORD=$(docker exec -e VAULT_TOKEN="$VAULT_TOKEN" vault vault kv get -field=SEMAPHORE_ADMIN_PASSWORD "$SECRET_PATH")

if [ -z "$DB_PASS" ]; then
  log "Error: Failed to fetch critical DB_PASS secret from Vault."
  exit 1
fi

log "Secrets fetched successfully. Launching stack..."
compose_up "$STACK_DIR"

HEALTH_URL="http://192.168.29.50:3005"
log "Waiting for Semaphore to be healthy at $HEALTH_URL..."
expect_http_ok "$HEALTH_URL" 120

log "Ansible Semaphore deployment successful!"
