package com.example

import com.typesafe.config.ConfigFactory
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._

object Main {
  def main(args: Array[String]): Unit = {
    val config = ConfigFactory.load()

    val spark = SparkSession.builder()
      .appName(config.getString("spark.app-name"))
      .config("spark.hadoop.fs.s3a.endpoint",          config.getString("minio.endpoint"))
      .config("spark.hadoop.fs.s3a.access.key",        config.getString("minio.access-key"))
      .config("spark.hadoop.fs.s3a.secret.key",        config.getString("minio.secret-key"))
      .config("spark.hadoop.fs.s3a.path.style.access", config.getBoolean("minio.path-style-access").toString)
      .config("spark.hadoop.fs.s3a.impl",              "org.apache.hadoop.fs.s3a.S3AFileSystem")
      .config("spark.sql.extensions",                  "org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions")
      .config("spark.sql.catalog.local",               "org.apache.iceberg.spark.SparkCatalog")
      .config("spark.sql.catalog.local.type",          config.getString("spark.iceberg.catalog-type"))
      .config("spark.sql.catalog.local.warehouse",     config.getString("spark.iceberg.warehouse"))
      .getOrCreate()

    spark.sparkContext.setLogLevel("WARN")

    import spark.implicits._

    val df = Seq(
      (1, "alice", 100),
      (2, "bob",   200),
      (3, "carol", 300),
    ).toDF("id", "name", "value")

    val result = df.withColumn("doubled_value", col("value") * 2)

    result.writeTo("local.default.scala_sample_table")
      .using("iceberg")
      .createOrReplace()

    val read = spark.table("local.default.scala_sample_table")
    read.show()
    println(s"Written ${read.count()} rows.")

    spark.stop()
  }
}
