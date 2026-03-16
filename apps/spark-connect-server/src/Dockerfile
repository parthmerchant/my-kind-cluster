# Pre-download known JARs at build time; spark-connect is resolved via --packages at startup
FROM apache/spark:3.5.3
USER root

ARG ICEBERG_VERSION=1.7.0
ARG HADOOP_AWS_VERSION=3.3.4
ARG AWS_SDK_VERSION=1.12.262
ARG MVN=https://repo1.maven.org/maven2

RUN curl -fsSL \
    "${MVN}/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/${ICEBERG_VERSION}/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VERSION}.jar" \
    -o /opt/spark/jars/iceberg-spark-runtime-3.5_2.12-${ICEBERG_VERSION}.jar && \
    curl -fsSL \
    "${MVN}/org/apache/hadoop/hadoop-aws/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
    -o /opt/spark/jars/hadoop-aws-${HADOOP_AWS_VERSION}.jar && \
    curl -fsSL \
    "${MVN}/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar" \
    -o /opt/spark/jars/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar

# Create ivy2 cache dir so --packages can write resolved descriptors at runtime
RUN mkdir -p /home/spark/.ivy2/cache && chown -R spark:spark /home/spark/.ivy2

COPY start.sh /opt/spark/start.sh
RUN chmod +x /opt/spark/start.sh

USER spark
EXPOSE 15002 4040
ENTRYPOINT ["/opt/spark/start.sh"]
