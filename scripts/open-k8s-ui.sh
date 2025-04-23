#!/bin/bash

echo "🔍 Discovering services with UIs..."

OPEN_CMD="open"
if ! command -v open &> /dev/null; then
  if command -v xdg-open &> /dev/null; then
    OPEN_CMD="xdg-open"
  else
    echo "❌ Cannot find 'open' or 'xdg-open'. Please install one to auto-open UIs."
    exit 1
  fi
fi

SERVICES=$(kubectl get svc --all-namespaces -o json)

echo "$SERVICES" | jq -r '
  .items[]
  | select(.spec.type == "NodePort" or .spec.type == "LoadBalancer")
  | {
      namespace: .metadata.namespace,
      name: .metadata.name,
      type: .spec.type,
      ports: [.spec.ports[] | {port: .port, nodePort: .nodePort}]
    }
  | @base64
' | while read -r svc64; do
  svc=$(echo "$svc64" | base64 --decode)
  ns=$(echo "$svc" | jq -r '.namespace')
  name=$(echo "$svc" | jq -r '.name')
  type=$(echo "$svc" | jq -r '.type')
  ports=$(echo "$svc" | jq -c '.ports[]')

  for p in $ports; do
    port=$(echo "$p" | jq -r '.port')
    nodePort=$(echo "$p" | jq -r '.nodePort')

    if [[ "$type" == "NodePort" ]]; then
      url="http://localhost:$nodePort"
    elif [[ "$type" == "LoadBalancer" ]]; then
      lb_ip=$(kubectl get svc "$name" -n "$ns" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      [[ -z "$lb_ip" ]] && continue
      url="http://$lb_ip:$port"
    fi

    # 🔐 Pre-fill logins for known apps
    case "$name" in
      grafana)
        url="${url}/login?user=admin&password=prom-operator"
        ;;
      argocd-server)
        url="${url}/login?username=admin"
        ;;
      jaeger|jaeger-query)
        url="${url}/search"
        ;;
    esac

    echo "🌐 $name ($ns): $url"
    $OPEN_CMD "$url" >/dev/null 2>&1 &
  done
done

echo "✅ All known UIs with open ports have been launched."