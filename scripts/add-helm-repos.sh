#!/usr/bin/env bash
set -euo pipefail

helm repo add jetstack https://charts.jetstack.io
helm repo add kedacore https://kedacore.github.io/charts
helm repo add spark-operator https://kubeflow.github.io/spark-operator
helm repo add minio https://charts.min.io/
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update
echo "Helm repos added and updated."
