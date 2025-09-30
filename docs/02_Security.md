# Phase 1 — Security Baseline

## AdGuard Home
- **Service**: AdGuard Home
- **Purpose**: DNS resolver, ad/malware blocking, local service resolution
- **Container**: adguardhome
- **LAN Access**: http://192.168.29.50:8080
- **DNS IP**: 192.168.29.50 (tcp/udp port 53)
- **Volumes**:
  - ./data → /opt/adguardhome/work
  - ./config → /opt/adguardhome/conf
- **Networks**: core
- **Notes**:
  - Default AdGuard list enabled
  - Added OISD Full (https://big.oisd.nl)
  - Clients configured: Windows laptop, iPad, Android phone

## Tailscale VPN
- **Service**: Tailscale
- **Purpose**: Secure remote access (Acer, iPad, S8) to homelab services
- **Container**: tailscale
- **Hostname**: msi-homelab
- **Tailscale IP**: 100.x.x.x (dynamic, shown in `tailscale status`)
- **Volumes**:
  - ./data → /var/lib/tailscale
- **Capabilities**:
  - NET_ADMIN, NET_RAW
- **Network mode**: host
- **Usage**:
  - Tailscale app installed on Acer, iPad, S8
  - Devices can access services using Tailscale IP (e.g., `http://100.x.x.x:8080`)
- **Optional**:
  - Route DNS through AdGuard → global filtering even when outside LAN
