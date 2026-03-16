#!/usr/bin/env bash
set -euo pipefail

MINIO_POD=$(kubectl get pod -n minio -l app=minio -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n minio "$MINIO_POD" -- bash -c "
  mc alias set local http://localhost:9000 minioadmin minioadmin123
  mc mb --ignore-existing local/warehouse
  mc mb --ignore-existing local/spark-logs
  echo 'Buckets created.'
"
