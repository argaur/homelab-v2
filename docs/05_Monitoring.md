# Phase 1 — Monitoring Stack

> Prometheus + cAdvisor + node-exporter for metrics; Uptime Kuma for simple uptime checks; Grafana for dashboards.

## Grafana (Dashboards)
- **Container:** `grafana`
- **Stack file:** `stacks/monitoring/prometheus.yml`
- **UI:** `https://grafana.homelab.lan/` (if routed via Traefik) **or** `http://192.168.29.50:3000/`
- **Auth:** user **admin** (password stored in Vault at `kv/grafana/admin`)
- **Datasource(s):** Prometheus (see below)

## Prometheus (Scrape Engine)
- **Container:** `prometheus`
- **Stack file:** `stacks/monitoring/prometheus.yml`
- **Listen:** `http://192.168.29.50:9090/`
- **Scrapes:** cAdvisor (`:8080`), node-exporter (`:9100`) by default

## cAdvisor (Container metrics)
- **Container:** `cadvisor`
- **UI:** `http://192.168.29.50:8080/`

## node-exporter (Host metrics)
- **Container:** `node-exporter`
- **Metrics:** `http://192.168.29.50:9100/metrics`

## Uptime Kuma (Simple uptime monitor)
- **Container:** `uptime-kuma`
- **UI:** `http://192.168.29.50:3001/`
- **Auth:** your Kuma admin (optional; store at `kv/uptime-kuma/admin`)

---

## Daily ops
- Grafana login with **admin** → password from Vault `kv/grafana/admin`.
- Add Prometheus datasource: URL `http://prometheus:9090` (inside Docker network) or `http://192.168.29.50:9090`.
- Import dashboards (cAdvisor / node-exporter / Kubernetes later if needed).

## Notes
- All app passwords should live in Vault (KV v2 under `kv/...`).
- Keep private keys & Vault JSONs **out of Git**.
