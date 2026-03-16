# my-kind-cluster

A local Data Platform running on [kind](https://kind.sigs.k8s.io/) (Kubernetes IN Docker). One command to spin up the full stack.

## Quick Start

```bash
just launch
```

This creates the cluster, installs all operators, deploys every app, starts port-forwards in the background, and opens all UIs in your browser.

## Prerequisites

```bash
brew install kind kubectl helm just docker
```

## Apps

| App | UI | Credentials |
|-----|----|-------------|
| MinIO Console | http://localhost:9001 | `minioadmin` / `minioadmin123` |
| Grafana (Loki logs) | http://localhost:3000 | `admin` / `admin` |
| Spark Connect Server | `sc://localhost:15002` (gRPC) | — |

## Operators

| Operator | Namespace |
|----------|-----------|
| KEDA | `keda` |
| Kubeflow Spark Operator | `spark-operator` |

## Iceberg / MinIO

All Spark apps use MinIO as the S3-compatible backend for Apache Iceberg tables.

```
Warehouse:  s3a://warehouse/
Endpoint:   http://minio.minio.svc.cluster.local:9000
```

Pre-created buckets: `warehouse`, `spark-logs`.

## Repo Structure

```
cluster/          kind cluster config (1 control-plane + 3 workers)
scripts/          Helm repo setup, operator install, MinIO bucket init
infra/
  namespaces.yaml           All namespaces, Spark ServiceAccount + RBAC
  operators/                Helm values for KEDA, Spark Operator
apps/
  spark-connect-server/     Spark Connect gRPC server (port 15002) with Iceberg + S3A.
  minio/                    MinIO standalone — Iceberg warehouse + platform storage.
  pyspark-app/              PySpark job via SparkApplication CRD. Writes Iceberg table.
  scala-spark-app/          Scala Spark job via SparkApplication CRD. Multi-stage Gradle build.
  opentelemetry/            OTel Collector — OTLP receiver, Prometheus scrape, Loki export.
  logging/                  Loki (single-binary) + Grafana for unified logging.
```

Each app:
```
apps/<app>/
  infra/    Helm values or Kubernetes manifests
  src/      Dockerfile + application source
  README.md
```

## All Just Commands

```bash
# One-command launch
just launch             # setup + port-forwards + open all UIs

# Cluster lifecycle
just setup              # create cluster, install operators, deploy all apps
just teardown           # delete the kind cluster
just create-cluster
just delete-cluster

# Helm
just add-helm-repos

# Operators
just install-operators
just install-cert-manager
just install-keda
just install-spark-operator

# Apps
just deploy-all
just deploy-minio
just deploy-opentelemetry
just deploy-logging
just deploy-spark-connect-server

# Docker
just build <app>        # docker build apps/<app>/src/
just load <app>         # kind load into cluster
just build-load <app>   # build + load

# Job submission
just submit-pyspark
just submit-scala-spark

# Port forwarding (foreground)
just pf-minio
just pf-grafana
just pf-spark-connect

# Open all UIs in browser (requires port-forwards running)
just open-uis

# Status
just status
just logs <app> <namespace>
```

## Adding a New App

1. Create `apps/<name>/infra/` and `apps/<name>/src/`
2. Add Helm values or K8s manifests to `infra/`
3. Add `Dockerfile` and source to `src/`
4. Add `deploy-<name>` recipe to `justfile`
5. Add namespace to `infra/namespaces.yaml` if needed
