#!/bin/bash
set -euxo pipefail

services=("client-service" "llmserver-service")

for svc in "${services[@]}"; do
    if ! kubectl get service "$svc" >/dev/null 2>&1; then
        fail-message "Kubernetes service '$svc' has not been deployed"
    fi
done

echo "Kubernete services have been deployed to successfully."
