# Homelab Bible (v1)
- Stability first; UAT before prod.
- One step = one commit; no config drift.
- Security & Access are part of baseline: DNS (AdGuard), VPN (Tailscale), central secrets (SOPS/age for now; Vault later).
- Never break prod to test; use UAT ports/containers.
