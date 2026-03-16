# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A local Data Platform on a [kind](https://kind.sigs.k8s.io/) cluster (Kubernetes IN Docker). Contains Helm-based deployments for Spark Connect Server, MinIO/Iceberg, PySpark, Scala Spark, OpenTelemetry, and Loki/Grafana logging.

## Common Commands (justfile)

```bash
just launch                 # Full setup + background port-forwards + open all UIs in browser

just setup                  # Full setup: cluster + operators + all apps
just teardown               # Delete the kind cluster

just create-cluster         # Create the kind cluster only
just add-helm-repos         # Add all required Helm repos
just install-operators      # Install KEDA, Spark Operator

just deploy-all             # Deploy all apps
just deploy-<app>           # Deploy a specific app (minio, opentelemetry, logging, spark-connect-server)

just build <app>            # docker build apps/<app>/src/
just load <app>             # kind load docker-image <app>:latest
just build-load <app>       # Build + load into cluster

just submit-pyspark         # Build, load, and submit PySpark SparkApplication
just submit-scala-spark     # Build, load, and submit Scala SparkApplication

just pf-minio               # Port forward → http://localhost:9001
just pf-grafana             # Port forward → http://localhost:3000
just pf-spark-connect       # Port forward → localhost:15002 (gRPC)
just open-uis               # Open MinIO, Grafana in browser
just status                 # All nodes + pods
just logs <app> <namespace> # Tail logs for a pod label
```

## Architecture

```
cluster/          kind cluster config (1 control-plane + 3 workers, name: k8s-environment)
scripts/          Shell scripts for helm repos, operator install, MinIO bucket init
infra/
  namespaces.yaml           All namespaces + Spark ServiceAccount + RBAC
  operators/                Helm values for KEDA, Spark Operator
apps/
  spark-connect-server/     Spark Connect gRPC server — Deployment + Service (port 15002)
  minio/                    MinIO standalone — S3-compatible storage + Iceberg warehouse
  pyspark-app/              PySpark job via SparkApplication CRD (Spark Operator)
  scala-spark-app/          Scala Spark job via SparkApplication CRD (Gradle build)
  opentelemetry/            OpenTelemetry Collector — OTLP receiver, forwards logs to Loki
  logging/                  Loki (single-binary) + Grafana — unified logging
```

Each app follows the structure:
```
apps/<app>/
  infra/    Helm values or K8s manifests
  src/      Dockerfile + application source
  README.md
```

## Kubernetes Context

When working with this repo, follow the kubex conventions defined in `~/.claude/skills/kubex/kubex.md`:
- Always confirm namespace and cluster context before mutating resources
- Use `--dry-run=client` to preview mutations when uncertain
- Structure output as: `[Context]`, `[Action]`, `[Command]`, `[Result]`, `[Next Step]`

Cluster context name: `kind-k8s-environment`

## Namespaces

| Namespace      | Contents                          |
|----------------|-----------------------------------|
| `spark`        | Spark apps, Connect Server        |
| `minio`        | MinIO object storage              |
| `opentelemetry`| OTel Collector                    |
| `logging`      | Loki + Grafana                    |
| `keda`         | KEDA operator                     |
| `spark-operator`| Spark Operator                   |
| `cert-manager` | cert-manager (required by Spark Operator webhook) |

## Credentials

| Service | Username   | Password       |
|---------|------------|----------------|
| MinIO   | minioadmin | minioadmin123  |
| Grafana | admin      | admin          |

## MinIO S3A Config (for Spark)

```
fs.s3a.endpoint=http://minio.minio.svc.cluster.local:9000
fs.s3a.access.key=minioadmin
fs.s3a.secret.key=minioadmin123
fs.s3a.path.style.access=true
fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem
```

Iceberg warehouse path: `s3a://warehouse/`

## Adding a New App

1. Create `apps/<app-name>/infra/` and `apps/<app-name>/src/`
2. Add Helm values or K8s manifests to `infra/`
3. Add Dockerfile and source to `src/`
4. Add `deploy-<app>` recipe to `justfile`
5. Add namespace to `infra/namespaces.yaml` if needed
