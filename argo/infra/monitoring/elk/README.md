# ELK Stack (Elastic, FluentBit, Kibana)

## Overview
This directory manages the ELK stack deployment via Argo CD GitOps.

It includes:
- Elasticsearch deployment (TLS secured, custom certs via cert-manager)
- Kibana deployment (secured via service token)
- Fluent Bit log forwarding (configured for applications)
- Job automation for generating Kibana service tokens
- RBAC controls for pod exec permissions

## Deployment History

### 2025-04-26
- Organized `elk/` structure into apps, certs, roles, secrets, and values.
- Switched `elk-generate-kibana-token` Job to use a dedicated curl container instead of elasticsearch image.
- Applied pod access Role and RoleBinding for token creation job.
- Created self-signed TLS certs via cert-manager for Elasticsearch.
- Sealed Kibana token as a SealedSecret.
- Created Argo CD Application for syncing token generation Job.
- Added notes for improvements.

---


## Organization

This directory is organized into subfolders for clarity and scalability:

- `apps/`: Argo CD Applications for ELK components (Elasticsearch, Fluent Bit, Kibana, Jobs)
- `certs/`: Certificates for Elasticsearch TLS (managed via cert-manager)
- `roles/`: RBAC Role and RoleBinding for pod access to generate tokens
- `secrets/`: SealedSecrets and plain Secrets for Elastic credentials and tokens
- `values/`: Custom Helm value overrides (e.g., for Fluent Bit)

Kustomization is handled via `kustomization.yaml` at this level for easier GitOps synchronization.