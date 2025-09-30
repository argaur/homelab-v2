# Reverse Proxy — Traefik (Homelab)

**Service:** Traefik v3 (reverse proxy + TLS)  
**Container:** `traefik`  
**Stack files:** `stacks/traefik/docker-compose.yml`, `stacks/traefik/dynamic.yml`  
**Certificates (kept out of Git):** `stacks/traefik/certs/homelab.lan.fullchain.crt`, `stacks/traefik/certs/homelab.lan.key`  
**DNS:** AdGuard rules map `*.homelab.lan` to `192.168.29.50`

---

## Hostnames (use these in the browser)
- **Portainer:** `https://portainer.homelab.lan`
- **AdGuard Home:** `https://adguard.homelab.lan`
- **Vault:** `https://vault.homelab.lan`

---

## What “healthy” looks like
- Each URL above opens its app (a certificate warning is expected with a self-signed CA).
- Portainer is reachable behind HTTPS (container listens on 9443 → Traefik 443).
- AdGuard Home is reachable behind HTTPS (container listens on 80 → Traefik 443).
- Vault is reachable behind HTTPS (container listens on 8200 → Traefik 443). If sealed, the UI prompts to unseal.

---

## Certificates (Option A — quick, self-signed)
- A local “Homelab Root CA” issues a wildcard certificate `*.homelab.lan`.
- You may ignore the browser warning and proceed; TLS is still in use.
- To remove warnings later, import the CA on each device (Windows Trusted Root; iOS/iPadOS/Android trusted credentials). Optional.

---

## DNS rewrites (AdGuard Home)
Add these **custom filtering rules** and apply:
- `||homelab.lan^$dnsrewrite=NOERROR;A;192.168.29.50`
- `||portainer.homelab.lan^$dnsrewrite=NOERROR;A;192.168.29.50`
- `||adguard.homelab.lan^$dnsrewrite=NOERROR;A;192.168.29.50`
- `||vault.homelab.lan^$dnsrewrite=NOERROR;A;192.168.29.50`

Ensure your client devices actually use AdGuard as DNS (e.g., Windows NIC DNS set to `192.168.29.50`).

---

## How routing is defined (summary)
- **Routers (entryPoint `websecure`, port 443):**
  - `Host("portainer.homelab.lan")` → service: `portainer`
  - `Host("adguard.homelab.lan")` → service: `adguard`
  - `Host("vault.homelab.lan")` → service: `vault`
- **Services (targets):**
  - `portainer` → `https://portainer:9443` (skip verify)
  - `adguard` → `http://adguardhome:80`
  - `vault` → `http://vault:8200`
- TLS served from the mounted fullchain/key under `stacks/traefik/certs/`.

---

## Troubleshooting quick guide
- **NXDOMAIN / can’t resolve:** client not using AdGuard or rules missing. Point DNS to `192.168.29.50` and add the rules above; flush DNS.
- **404 from Traefik:** router didn’t match. Check that hostnames are quoted exactly as shown and entryPoint is `websecure`.
- **502 / Bad Gateway:** backend down or wrong port. Targets should be: Portainer `:9443` (HTTPS), AdGuard `:80` (HTTP), Vault `:8200` (HTTP).
- **Certificate warning:** expected with self-signed CA until trusted on the device; safe to continue on LAN.

---

## Notes
- Secrets, Vault file backend, and certificates are **not committed** to Git (ignored via `.gitignore`).
- Traefik listens on **443**; HTTP is not exposed at the proxy.
- This setup is LAN-only. Public exposure (e.g., Let’s Encrypt via DNS-01/Cloudflare) can be added later if needed.
