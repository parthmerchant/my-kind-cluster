#!/bin/bash
set -e

exec "$SPARK_HOME/bin/spark-submit" \
  --class org.apache.spark.sql.connect.service.SparkConnectServer \
  --master "local[*]" \
  --packages "org.apache.spark:spark-connect_2.12:3.5.3" \
  --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
  --conf spark.sql.catalog.spark_catalog.type=hive \
  --conf spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog \
  --conf spark.sql.catalog.local.type=hadoop \
  --conf spark.sql.catalog.local.warehouse=s3a://warehouse/ \
  --conf spark.hadoop.fs.s3a.endpoint=http://minio.minio.svc.cluster.local:9000 \
  --conf spark.hadoop.fs.s3a.access.key=minioadmin \
  --conf spark.hadoop.fs.s3a.secret.key=minioadmin123 \
  --conf spark.hadoop.fs.s3a.path.style.access=true \
  --conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem \
  local[*]
