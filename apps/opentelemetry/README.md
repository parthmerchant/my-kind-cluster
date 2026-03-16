# OpenTelemetry Collector

Receives traces, metrics, and logs via OTLP (gRPC port 4317, HTTP port 4318). Forwards logs to Loki.

## Endpoints (in-cluster)

| Signal  | Endpoint |
|---------|----------|
| Traces  | `http://otel-collector-opentelemetry-collector.opentelemetry.svc.cluster.local:4317` (gRPC) |
| Metrics | `http://otel-collector-opentelemetry-collector.opentelemetry.svc.cluster.local:4318` (HTTP) |
| Logs    | Same endpoints, forwarded to Loki |

## Instrument your app

Set `OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector-opentelemetry-collector.opentelemetry.svc.cluster.local:4317`.
