# Phase 1 — Baseline Services

> Canonical reference for core services running on the MSI homelab node.

## Portainer (Container Orchestration)
- **Purpose:** Manage Docker containers/stacks; UI for deploys & logs
- **Container:** `portainer`
- **Stack file:** `stacks/portainer/docker-compose.yml`
- **Access (LAN):** `https://192.168.29.50:9443`
- **Access (VPN/Tailscale):** `https://<tailscale-ip>:9443`
- **Ports:** `9443/tcp` (HTTPS UI), `8000/tcp` (agent edge)
- **Volumes:** `/var/run/docker.sock:/var/run/docker.sock`, `portainer_data:/data`
- **Network:** `core`
- **Status:** ✅ Running

## PostgreSQL (Primary DB)
- **Purpose:** App database for future services (NocoDB, etc.)
- **Container:** `postgres` (`postgres:15`)
- **Stack file:** `stacks/postgres/docker-compose.yml`
- **DB:** `homelab`
- **Admin:** `homelab_admin`
- **LAN:** `192.168.29.50:5432`
- **VPN/Tailscale:** `<tailscale-ip>:5432`
- **Volume:** `pg_data:/var/lib/postgresql/data`
- **Network:** `core`
- **Sanity Table:** `sanity.ping` (row inserted)
- **Status:** ✅ Running

## AdGuard Home (DNS)
- **Container:** `adguardhome`
- **Stack file:** `stacks/adguard/docker-compose.yml`
- **Dashboard:** `http://192.168.29.50:8080`
- **DNS:** `192.168.29.50` (53/tcp+udp)
- **Blocklists:** Default + **OISD Full** `https://big.oisd.nl`
- **Network:** `core`
- **Status:** ✅ Running

## Tailscale (VPN Mesh)
- **Container:** `tailscale`
- **Stack file:** `stacks/tailscale/docker-compose.yml`
- **MSI Tailscale IP:** `docker exec -it tailscale tailscale ip -4`
- **Remote access:** Portainer `https://<tailscale-ip>:9443`, AdGuard `http://<tailscale-ip>:8080`
- **Status:** ✅ Connected

## Vault (Secrets Management)
- **Container:** `vault`
- **Stack file:** `stacks/vault/docker-compose.yml` (inline config)
- **Backend:** file (`./stacks/vault/file`)
- **UI:** `http://192.168.29.50:18201`
- **Unseal key/root token file:** `~/homelab/secrets/vault_init.json` (not in Git)
- **Auth:** `userpass` enabled → user `gaurav` with `homelab-admin` policy
- **KV engine:** enabled at `kv/`
- **Stored secrets:** `kv/adguard/admin`, `kv/portainer/admin`, `kv/postgres/admin`, `kv/postgres/app`
- **Status:** ✅ Running (unseal after reboot)
