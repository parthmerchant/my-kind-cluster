# Scala Spark App

Reads sample data, transforms it, and writes an Apache Iceberg table to MinIO.

## Build & Submit

```bash
just submit-scala-spark
```

The Dockerfile uses a multi-stage build: compiles with sbt in stage 1, produces a minimal Spark image in stage 2.

## Monitor

```bash
kubectl get sparkapplications -n spark
kubectl logs -n spark scala-spark-app-driver
```
