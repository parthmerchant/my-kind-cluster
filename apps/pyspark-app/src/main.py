"""PySpark app: reads sample data, writes an Iceberg table to MinIO."""

from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

def main():
    spark = SparkSession.builder.appName("pyspark-app").getOrCreate()
    spark.sparkContext.setLogLevel("WARN")

    schema = StructType([
        StructField("id", IntegerType(), False),
        StructField("name", StringType(), True),
        StructField("value", IntegerType(), True),
    ])
    data = [(1, "alice", 100), (2, "bob", 200), (3, "carol", 300)]
    df = spark.createDataFrame(data, schema)

    df = df.withColumn("doubled_value", F.col("value") * 2)

    df.writeTo("local.default.sample_table") \
        .using("iceberg") \
        .createOrReplace()

    result = spark.table("local.default.sample_table")
    result.show()
    print(f"Written {result.count()} rows to local.default.sample_table")

    spark.stop()


if __name__ == "__main__":
    main()
