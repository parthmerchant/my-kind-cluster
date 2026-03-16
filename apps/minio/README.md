# MinIO

S3-compatible object storage for the data platform. Serves as the storage backend for Apache Iceberg tables and Spark logs.

## Access

| Interface | Port |
|-----------|------|
| API (S3)  | 9000 |
| Console   | 9001 |

Credentials: `minioadmin` / `minioadmin123`

## Buckets

| Bucket | Purpose |
|--------|---------|
| `warehouse` | Iceberg table warehouse |
| `spark-logs` | Spark event logs |
## S3A Configuration (Spark)

```
fs.s3a.endpoint=http://minio.minio.svc.cluster.local:9000
fs.s3a.access.key=minioadmin
fs.s3a.secret.key=minioadmin123
fs.s3a.path.style.access=true
```
