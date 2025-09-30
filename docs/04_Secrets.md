# Secrets Management — HashiCorp Vault
 **Service:** Vault (Secrets)  
**Container:** `vault`  
**Stack file:** `stacks/vault/docker-compose.yml` (inline `VAULT_LOCAL_CONFIG`)  
**UI:** `http://192.168.29.50:18201`  
**Storage (persistent):** `stacks/vault/file/` (ignored by Git)  
**Auth in use:** `userpass` → user **gaurav** with policy **homelab-admin**  
**KV engine:** enabled at path **kv/**  
**Current secrets:**- `kv/adguard/admin`- `kv/portainer/admin`- `kv/postgres/admin`- `kv/postgres/app`--
## Daily workflow
 ### 1) If Vault was restarted → Unseal
 ```bash
 UNSEAL_KEY=$(jq -r '.unseal_keys_b64[0]' ~/homelab/secrets/vault_init.json)
 docker exec -it vault vault operator unseal "$UNSEAL_KEY"
 docker exec -it vault vault status   # Expect: Sealed: false
 ```
 ### 2) Login to the UI- URL: `http://192.168.29.50:18201`- Method: **Username**- Username: **gaurav**- Password: (your admin password)
 > Avoid using the root token for day-to-day work; keep it only for emergencies.
 ### 3) Health check (optional)
 ```bash
 curl -s http://192.168.29.50:18201/v1/sys/health
 ```--
## Storing & retrieving secrets (CLI quick ref)
 **Write / update**
 ```bash
 docker exec -it vault vault kv put kv/postgres/admin \
  username="homelab_admin" password="S3cr3t!"
 ```
 **Read**
 ```bash
 docker exec -it vault vault kv get kv/postgres/admin
 ```
 **Change admin password**
 ```bash
 docker exec -it vault vault write auth/userpass/users/gaurav \
  password="NEW_STRONG_PASSWORD" policies=homelab-admin
```--
## One-time bootstrap (already done)- Vault was **initialized** and **unsealed**; unseal key + root token saved to:
  - `~/homelab/secrets/vault_init.json` (local only, chmod 600, not in Git)- **userpass** auth enabled; user **gaurav** created with policy **homelab-admin** 
(full access).- **KV v2** enabled at **kv/** and baseline secrets stored (listed above).
 If you ever need to re-initialize from scratch (e.g., after wiping storage), see 
**Backup & recovery** below.--
## Backup & recovery
 ### Backup (file backend)
 1. Stop Vault:
   ```bash
   docker compose -f stacks/vault/docker-compose.yml down
   ```
 2. Back up the data directory:
   ```bash
   tar czf ~/vault-file-backup.tgz -C stacks/vault file/
   ```
 3. Start Vault:
   ```bash
   docker compose -f stacks/vault/docker-compose.yml up -d
   ```
 ### Restore
 1. Stop Vault, then restore the archive back into `stacks/vault/file/`:
   ```bash
   docker compose -f stacks/vault/docker-compose.yml down
   tar xzf ~/vault-file-backup.tgz -C stacks/vault
   docker compose -f stacks/vault/docker-compose.yml up -d
   ```
 2. Unseal with the key from `~/homelab/secrets/vault_init.json`:
   ```bash
   UNSEAL_KEY=$(jq -r '.unseal_keys_b64[0]' ~/homelab/secrets/vault_init.json)
   docker exec -it vault vault operator unseal "$UNSEAL_KEY"
   ```
 ### Full re-init (wipe) — **destroys all secrets**
 ```bash
 docker compose -f stacks/vault/docker-compose.yml down
 sudo rm -rf stacks/vault/file/*
 docker compose -f stacks/vault/docker-compose.yml up -d
 # Then: operator init → save ~/homelab/secrets/vault_init.json → operator unseal
 # → recreate userpass user + policies → re-create secrets
 ```--
## Security notes
- `~/homelab/secrets/` contains the **unseal key** and (optionally) admin token 
JSON; keep it `chmod 600` and **out of Git**.- Vault data (`stacks/vault/file/`) is also **ignored by Git**.- Consider auto-unseal (Transit or a cloud KMS) later if you want hands-off 
restarts
