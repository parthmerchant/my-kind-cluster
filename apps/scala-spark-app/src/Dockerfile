# Stage 1: Build fat JAR with Gradle
FROM gradle:8.10-jdk11 AS builder
WORKDIR /build
COPY build.gradle settings.gradle ./
COPY gradle/ gradle/
COPY src/ src/
RUN gradle shadowJar --no-daemon

# Stage 2: Spark runtime image
FROM apache/spark:3.5.3
COPY --from=builder /build/build/libs/app.jar /opt/spark/work-dir/app.jar
USER spark
