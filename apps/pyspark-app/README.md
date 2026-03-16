# PySpark App

Reads sample data, transforms it, and writes an Apache Iceberg table to MinIO.

## Submit

```bash
just submit-pyspark
```

## Monitor

```bash
kubectl get sparkapplications -n spark
kubectl logs -n spark pyspark-app-driver
```
