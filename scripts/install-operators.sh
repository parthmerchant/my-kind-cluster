#!/usr/bin/env bash
set -euo pipefail

echo "Installing cert-manager..."
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set crds.enabled=true \
  --wait

echo "Installing KEDA..."
helm upgrade --install keda kedacore/keda \
  --namespace keda --create-namespace \
  -f infra/operators/keda-values.yaml \
  --wait

echo "Installing Spark Operator..."
helm upgrade --install spark-operator spark-operator/spark-operator \
  --namespace spark-operator --create-namespace \
  -f infra/operators/spark-operator-values.yaml \
  --wait

echo "All operators installed."
