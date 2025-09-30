# n8n – Homelab Guide

A lightweight, self-hosted workflow automation service backed by Postgres.

---

## 📍 Where things live

- **Stack dir:** `~/homelab/stacks/n8n/`
- **Compose:** `~/homelab/stacks/n8n/docker-compose.yml`
- **Port overrides:** `~/homelab/stacks/n8n/ports.override.yml`
- **Environment / secrets:** `~/homelab/stacks/n8n/secrets.env`
- **Data volumes (Docker):** `n8n_n8n_pg` (Postgres data)
- **Restore script:** `~/homelab/ops/restore_n8n.sh`
- **Homepage tile:** `~/homelab/stacks/homepage/config/services.yml`  (section: *Automation* / tile: **n8n**)
- **Default port (LAN):** `5678`
- **Health endpoint:** `http://127.0.0.1:5678/healthz`

---

## 🚀 Bring-up / Restore

```bash
# one-shot restore / bring-up
bash ~/homelab/ops/restore_n8n.sh

The script:

runs compose with docker-compose.yml and ports.override.yml

waits for 200 from /healthz

prints the open URL

You should see logs like “Editor is now accessible”.

🔐 Environment & security

All runtime config is in ~/homelab/stacks/n8n/secrets.env.
Important keys we set:

# Allow plain HTTP on your LAN
N8N_SECURE_COOKIE=false
N8N_PROTOCOL=http
N8N_HOST=192.168.29.50
N8N_EDITOR_BASE_URL=http://192.168.29.50:5678/
WEBHOOK_URL=http://192.168.29.50:5678/

# Basic auth for the UI
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=change_me_strong

# 64-hex encryption key for credential storage
N8N_ENCRYPTION_KEY=<64-hex>

# Postgres wiring
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=n8n-postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=\${POSTGRES_USER}
DB_POSTGRESDB_PASSWORD=\${POSTGRES_PASSWORD}
DB_POSTGRESDB_DATABASE=\${POSTGRES_DB}

# Postgres creds (referenced above)
POSTGRES_USER=n8n
POSTGRES_PASSWORD=change_pg_password
POSTGRES_DB=n8n

# Optional
GENERIC_TIMEZONE=Asia/Kolkata


Cookie / HTTPS note
We explicitly set N8N_SECURE_COOKIE=false + N8N_PROTOCOL=http so the UI loads over plain LAN HTTP (your chosen setup).
When you later put n8n behind HTTPS, flip N8N_SECURE_COOKIE=true and set N8N_PROTOCOL=https, N8N_HOST=<dns-name>, and update N8N_EDITOR_BASE_URL/WEBHOOK_URL.

🧪 Health & quick checks
# health should be 200
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1:5678/healthz

# follow logs until "Editor is now accessible"
docker logs -f --tail=200 n8n


If you ever see the “secure cookie” warning again, re-check the three vars:
N8N_SECURE_COOKIE, N8N_PROTOCOL, N8N_EDITOR_BASE_URL.

🔧 Updating n8n
cd ~/homelab/stacks/n8n
docker compose pull
docker compose -f docker-compose.yml -f ports.override.yml up -d
docker image prune -f

🗂 Homepage

Add (or verify) this tile under your existing section in
~/homelab/stacks/homepage/config/services.yml:

- Automation:
    - n8n:
        href: http://$NODE_IP:5678
        description: Workflow automation
        icon: n8n
        status: http://$NODE_IP:5678/healthz
        target: _blank


(You already added the tile; keep this here for reference.)

🧰 Backup & data

Postgres data persists in the Docker volume n8n_n8n_pg.

Credentials (node secrets) are encrypted with N8N_ENCRYPTION_KEY — keep that key safe (in Vault).

To snapshot Postgres quickly:

# ad-hoc dump (inside the postgres container)
docker exec -t n8n-postgres pg_dump -U n8n -d n8n | gzip > ~/backups/n8n_$(date +%F).sql.gz

🪪 Vault (secrets)

Keep these in Vault (KV) and template them into secrets.env during restore:

N8N_ENCRYPTION_KEY

N8N_BASIC_AUTH_USER

N8N_BASIC_AUTH_PASSWORD

POSTGRES_PASSWORD

We keep the cleartext file only on the node; repo should never include real values.

🐛 Troubleshooting

“Cannot GET /” immediately after boot: migrations are still running. Watch docker logs -f n8n until “Editor is now accessible”.

Cookie/HTTPS banner: set
N8N_SECURE_COOKIE=false, N8N_PROTOCOL=http, N8N_EDITOR_BASE_URL=http://192.168.29.50:5678/, then restart.

Health 200 but browser fails: hard-refresh, or try a private tab to drop stale cookies.

🔁 One-liner re-deploy
cd ~/homelab/stacks/n8n && \
docker compose -f docker-compose.yml -f ports.override.yml up -d && \
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1:5678/healthz
