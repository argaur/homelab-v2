# Phase 1 — SSO (Authelia)

**Service:** Authelia (SSO/2FA)  
**Container:** `authelia`  
**Stack file:** `stacks/authelia/docker-compose.yml`  
**UI (temp):** `http://192.168.29.50:9091/` (Traefik SSO later)  
**Auth backend:** file (`stacks/authelia/config/users_database.yml`)  
**Storage:** sqlite at `/config/db.sqlite3`  
**Secrets (JWT/session/storage):** `~/homelab/secrets/authelia/*` (ignored by Git)

## Daily login
- Username: **gaurav**  
- Password: in Vault at `kv/authelia/admin`  
- TOTP can be enabled later (currently `one_factor`).

## Later (Traefik SSO)
- Add a forwardAuth middleware to Traefik and apply to protected routes:
  `Host(`*.homelab.lan`)` ⇒ policy `one_factor`.
