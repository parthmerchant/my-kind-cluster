# Spark Connect Server

Runs Apache Spark Connect Server (gRPC) for remote Spark sessions. Clients connect via the Spark Connect protocol on port 15002.

## Usage

Connect from Python:
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .remote("sc://localhost:15002") \
    .getOrCreate()
```

## Port Forward

```bash
just pf-spark-connect
```
