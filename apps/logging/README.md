# Logging

Unified logging using Grafana Loki (storage) + Grafana (visualization).

## Access Grafana

```bash
just pf-grafana
```
Open http://localhost:3000 — credentials: `admin` / `admin`

## Send logs via OTLP

Point your OpenTelemetry SDK to the OTEL Collector, which forwards logs to Loki automatically.

Or push directly to Loki:
```
http://loki.logging.svc.cluster.local:3100/loki/api/v1/push
```
