Homelab Infrastructure 🏠

Welcome to my personal homelab repository! This project is a complete, self-hosted infrastructure running on a dedicated server, managed with a GitOps-centric workflow. All services are deployed as Docker containers and orchestrated with `docker-compose`.

## ✨ Core Philosophy

This homelab operates on a set of strict principles to ensure stability, security, and maintainability:

* [cite_start]**Docker First**: All services and applications must be deployed and managed using Docker and `docker-compose.yml` files[cite: 34, 57, 59, 63, 324].
* [cite_start]**Secrets in Vault**: All credentials, API keys, and passwords MUST be stored in HashiCorp Vault[cite: 37, 86, 335]. [cite_start]No secrets are ever stored in plaintext, `.env` files, or committed to the repository[cite: 87, 340].
* **Git-Driven Workflow**: The repository follows a strict Git workflow. [cite_start]`main` is for stable configurations, and all development occurs in the `ongoing` branch[cite: 89, 169, 325, 460].
* [cite_start]**Atomic Commits**: Every new service or major change is a single, self-contained commit for a clean and auditable history[cite: 90, 461].
* [cite_start]**Definition of Done**: A deployment is not complete until documentation is updated and a new restore script is created and pushed to the `ongoing` branch[cite: 91, 161, 532].

---

## 💻 Hardware Setup

The homelab runs on a two-node model:

* [cite_start]**Primary Server (MSI GE62 2QD)**: A laptop running Linux Mint 21.3 Cinnamon with 12GB RAM[cite: 6, 8, 276, 377, 379].
    * [cite_start]**Role**: Acts as the primary backend server, running all core Docker containers[cite: 277, 279, 380].
    * [cite_start]**Static IP**: `192.168.29.50`[cite: 10, 280, 381].
* [cite_start]**Workstation (Acer Aspire)**: A Windows 11 laptop with WSL2 (Ubuntu)[cite: 281, 382, 384].
    * [cite_start]**Role**: Used for development, testing, and remote administration[cite: 283, 385].

---

## 🚀 Core Services

The following services are currently deployed on the primary server.

| Service               | Port  | Purpose                                             |
| --------------------- | ----- | --------------------------------------------------- |
| **Homepage** | 3333  | [cite_start]A unified, central dashboard for all services[cite: 306].      |
| **Portainer** | 9443  | [cite_start]Web UI for Docker container management[cite: 289].         |
| **Nginx Proxy Manager** | 8181  | [cite_start]Admin UI for the reverse proxy[cite: 296].               |
| **AdGuard Home** | 8080  | [cite_start]Network-wide DNS filtering and local DNS[cite: 291].         |
| **Vault** | 18201 | [cite_start]Secrets management for all credentials[cite: 294].          |
| **Prometheus** | 9090  | [cite_start]Metrics collection and time-series database[cite: 300].      |
| **Grafana** | 3002  | [cite_start]Metrics dashboards and visualization[cite: 298].           |
| **Uptime Kuma** | 3001  | [cite_start]Service status monitoring and alerts[cite: 299].        |
| **n8n** | 5678  | [cite_start]Workflow automation tool[cite: 305].                     |
| **Ansible Semaphore** | 3005  | Web UI for running Ansible playbooks.                 |

---

## 📁 Directory Structure

[cite_start]The project is organized with a strict and consistent directory structure located at `~/homelab/`[cite: 54, 129, 313, 425].

```
~/homelab/
[cite_start]├── stacks/       # Contains one sub-directory for each Docker Compose stack [cite: 55, 130, 315, 426]
│   ├── homepage/
│   │   └── docker-compose.yml
│   └── ...
[cite_start]├── ops/          # Houses all restore scripts and helper utilities [cite: 64, 67, 145, 317, 435]
│   ├── helpers.sh
│   └── restore_homepage.sh
[cite_start]└── docs/         # Project documentation, guides, and diagrams [cite: 78, 161, 319, 449]
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

* [cite_start]**Networking**: All Docker Compose stacks must explicitly join the pre-existing external Docker network named `core`[cite: 81, 82, 328, 452]. This allows services to communicate with each other using their container names.
* [cite_start]**Secrets**: The base path for the KV v2 secrets engine in Vault is `kv/`[cite: 37, 108, 218, 336, 479]. [cite_start]A dedicated folder must be created for each new service (e.g., `kv/n8n/`, `kv/semaphore/`)[cite: 110, 220, 338, 481].

```
# Example Vault Path Structure
kv/
├── n8n/
│   └── secrets
└── semaphore/
    └── secrets
```

This infrastructure is an ongoing project. Please refer to the `docs/` directory for more detailed guides on specific services.
