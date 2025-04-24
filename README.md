# infra-gitops# ✅ Production Readiness Checklist

This checklist tracks what’s needed to make this Kubernetes cluster secure, observable, and production-ready.

---

## 🛡️ Tier 1 - Security

- [ ] Migrate Kibana from NodePort to Istio Gateway + TLS
- [ ] Protect Kibana with auth (e.g. Basic Auth or OIDC)
- [ ] Convert `elasticsearch-master-credentials` to SealedSecret
- [ ] Apply NetworkPolicies for namespace isolation
- [ ] Audit and restrict Argo CD & app-level RBAC

---

## 📈 Tier 2 - Observability

- [ ] Hook Fluent Bit into app logs (e.g. guestbook, sentiment-service)
- [ ] Add Alertmanager rules:
  - [ ] PodCrashLoop alerts
  - [ ] Elasticsearch disk > 80%
  - [ ] High 5xx rate alerts
  - [ ] Prometheus down alert
- [ ] (Optional) Add tracing with Jaeger or Tempo

---

## 🔁 Tier 3 - Stability & Scaling

- [ ] Add liveness and readiness probes to all apps
- [ ] Add Horizontal Pod Autoscalers (HPA) where applicable
- [ ] Add PodDisruptionBudgets
- [ ] (Optional) Configure anti-affinity rules or zone-aware scheduling for HA

---

## 💾 Tier 4 - Persistence & Backup

- [ ] Automate Elasticsearch snapshots to S3 or PVC
- [ ] (Optional) Add Kubecost or OpenCost for FinOps insights
- [ ] (Optional) Enable Prometheus remote write (Thanos/Cortex/Loki)

---

## 🌱 Tier 5 - Environment Management

- [ ] Add dev/staging/prod namespace separation (or separate clusters)
- [ ] Extend Argo CD health checks (e.g. StatefulSets, CronJobs, PVCs)

---

Progressively checking these off will bring the cluster in line with production-grade best practices for availability, security, and observability.