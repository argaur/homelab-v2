# Homelab Infrastructure 🏠

Welcome to my personal homelab repository! This project is a complete, self-hosted infrastructure running on a dedicated server, managed with a GitOps-centric workflow. All services are deployed as Docker containers and orchestrated with `docker-compose`.

## ✨ Core Philosophy

This homelab operates on a set of strict principles to ensure stability, security, and maintainability:

* **Docker First**: All services and applications must be deployed and managed using Docker and `docker-compose.yml` files.
* **Secrets in Vault**: All credentials, API keys, and passwords MUST be stored in HashiCorp Vault. No secrets are ever stored in plaintext, `.env` files, or committed to the repository.
* **Git-Driven Workflow**: The repository follows a strict Git workflow. `main` is for stable configurations, and all development occurs in the `ongoing` branch.
* **Atomic Commits**: Every new service or major change is a single, self-contained commit for a clean and auditable history.
* **Definition of Done**: A deployment is not complete until documentation is updated and a new restore script is created and pushed to the `ongoing` branch.

---

## 💻 Hardware Setup

The homelab runs on a two-node model:

* **Primary Server (MSI GE62 2QD)**: A laptop running Linux Mint 21.3 Cinnamon with 12GB RAM.
    * **Role**: Acts as the primary backend server, running all core Docker containers.
    * **Static IP**: `192.168.29.50`.
* **Workstation (Acer Aspire)**: A Windows 11 laptop with WSL2 (Ubuntu).
    * **Role**: Used for development, testing, and remote administration.

---

## 🚀 Core Services

The following services are currently deployed on the primary server.

| Service               | Port  | Purpose                                             |
| --------------------- | ----- | --------------------------------------------------- |
| **Homepage** | 3333  | A unified, central dashboard for all services.      |
| **Portainer** | 9443  | Web UI for Docker container management.         |
| **Nginx Proxy Manager** | 8181  | Admin UI for the reverse proxy.               |
| **AdGuard Home** | 8080  | Network-wide DNS filtering and local DNS.         |
| **Vault** | 18201 | Secrets management for all credentials.          |
| **Prometheus** | 9090  | Metrics collection and time-series database.      |
| **Grafana** | 3002  | Metrics dashboards and visualization.           |
| **Uptime Kuma** | 3001  | Service status monitoring and alerts.        |
| **n8n** | 5678  | Workflow automation tool.                     |
| **Ansible Semaphore** | 3005  | Web UI for running Ansible playbooks.                 |

---

## 📁 Directory Structure

The project is organized with a strict and consistent directory structure located at `~/homelab/`.

```
~/homelab/
├── stacks/       # Contains one sub-directory for each Docker Compose stack
│   ├── homepage/
│   │   └── docker-compose.yml
│   └── ...
├── ops/          # Houses all restore scripts and helper utilities
│   ├── helpers.sh
│   └── restore_homepage.sh
└── docs/         # Project documentation, guides, and diagrams
```

---

## ⚙️ Getting Started

### Prerequisites

* Docker & Docker Compose
* Git CLI
* A running HashiCorp Vault instance

### Deployment

All services are deployed using standardized shell scripts. To deploy or restore a service, execute its corresponding script from the `ops/` directory.

**Important**: Before running a script, you must export a valid Vault token. The scripts use this token to fetch the necessary secrets for the service to start.

```bash
# Example: Deploying Ansible Semaphore
export VAULT_TOKEN="<your_vault_token_here>"
bash ~/homelab/ops/restore_semaphore.sh
```

---

## 📜 Key Conventions

* **Networking**: All Docker Compose stacks must explicitly join the pre-existing external Docker network named `core`. This allows services to communicate with each other using their container names.
* **Secrets**: The base path for the KV v2 secrets engine in Vault is `kv/`. A dedicated folder must be created for each new service (e.g., `kv/n8n/`, `kv/semaphore/`).

```
# Example Vault Path Structure
kv/
├── n8n/
│   └── secrets
└── semaphore/
    └── secrets
```

This infrastructure is an ongoing project. Please refer to the `docs/` directory for more detailed guides on specific services.
