# 06: Authelia Deployment Summary

## Service Details
- **Service:** Authelia (Single Sign-On & Authentication Provider)
- **Version:** `4.37.5`
- [cite_start]**URL:** `http://192.168.29.50:9091` [cite: 10]

## Purpose
Authelia serves as the centralized authentication provider for the homelab. Its purpose is to provide Single Sign-On (SSO) for other services, increasing security by having a single, hardened entry point for user credentials.

## Deployment Method
[cite_start]The service was deployed using Docker and a single `docker-compose.yml` file[cite: 34]. Due to complexities with the Vault Agent sidecar, we pivoted to a more robust, script-based approach for secrets management.

A `start.sh` script orchestrates the launch:
1.  It first checks HashiCorp Vault to ensure all required secrets exist. If any are missing, it generates them.
2.  It fetches the secrets from Vault and exports them as environment variables.
3.  It uses `envsubst` to substitute these variables into a `configuration.template.yml` file, creating the final `configuration.yml`.
4.  It then runs `docker compose up -d` to launch the Authelia service with the generated configuration.

## Configuration Files
The stack is located in `~/homelab/stacks/authelia/` and consists of:
- `docker-compose.yml`: Defines the Authelia service.
- `configuration.template.yml`: The template for the Authelia configuration, with placeholders for secrets.
- `users_database.yml`: A file containing the user definitions and hashed passwords.
- `start.sh`: The master script for injecting secrets and launching the service.

## Secrets Management
[cite_start]All secrets are stored in HashiCorp Vault under the `kv/authelia/` path[cite: 37, 86, 110].
- `kv/authelia/jwt`: Stores the JWT secret.
- `kv/authelia/session`: Stores the session validation secret.
- `kv/authelia/storage`: Stores the SQLite database encryption key.

## Restore Process
[cite_start]The service can be restored and relaunched by running the dedicated restore script located at `~/homelab/ops/restore_authelia.sh`[cite: 64, 67].
