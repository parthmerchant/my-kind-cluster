# my-kind-cluster Plan

## Objective
A local kind cluster that is able to support deployments and testing of various Open Source Technologies. The application structure: 
* Every app is it's own folder in the apps/ directory
* Each app should have the following structure

apps/
    spark-connect-server/
        infra/
        src/
        README.md
    airflow/
        infra/
        src/


I want to build a complete Data Platform on my-kind-cluster. I want the following technologies used in their own apps:
* Apache Airflow
* Apache Spark Connect Server 
* S3 Storage using MinIO with Apache Iceberg
* One PySpark app
* One Scala Spark app
* OpenTelemetry instance ingesting metrics 
* Open Source Unified Logging
* One PyFlink app (Demo)


This project should be extremely boilerplate. 

Use helm releases

Install keda, kubernetes Spark Operator, Kubernetes Flink Operator
