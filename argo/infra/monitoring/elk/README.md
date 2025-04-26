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

### 2025-04-26 (Second Update)
- Fully removed the token generation Job (`elk-generate-kibana-token`) and CronJob approach.
- Reason: The required Elasticsearch 8.5.1 API endpoint (`/_security/service/...`) does not exist; attempts returned "no handler found".
- Decided to statically configure Kibana with basic auth credentials instead of rotating service tokens.
- Cleaned up `kustomization.yaml` and deleted `apps/job-generate-kibana-token.yaml`.

### 2025-04-26 (Update)
- Dropped use of service token generation via Job (`elk-generate-kibana-token`) due to Elasticsearch 8.5.1 lacking the required API endpoint.
- Decided to configure Kibana directly with basic auth using the existing `elasticsearch-master-credentials` Secret.
- Deleted the `elk-generate-kibana-token` Job and related SealedSecret.
- Updated Kibana Helm values to use elastic username and password for authentication.

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