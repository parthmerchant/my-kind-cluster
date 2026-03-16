# Data Platform — local kind cluster
cluster_name := "k8s-environment"

default:
    @just --list

# === One-Command Launch ===

# Full setup + start port-forwards in background + open all UIs
launch: setup
    @echo "Starting port-forwards..."
    @kubectl port-forward svc/minio-console 9001:9001 -n minio &
    @kubectl port-forward svc/grafana 3000:80 -n logging &
    @kubectl port-forward svc/spark-connect-server 15002:15002 -n spark &
    @sleep 3
    @just open-uis

# Open all UIs in the default browser (requires port-forwards running)
open-uis:
    open http://localhost:9001
    open http://localhost:3000

# === Cluster Lifecycle ===

# Full cluster setup: create cluster, install operators, deploy all apps
setup: create-cluster add-helm-repos deploy-infra install-operators deploy-all
    @echo "Data platform ready."

# Tear down the entire cluster
teardown:
    kind delete cluster --name {{cluster_name}}

# Create the kind cluster
create-cluster:
    kind create cluster --config cluster/kind-config.yaml
    kubectl config use-context kind-{{cluster_name}}

# Delete the kind cluster
delete-cluster:
    kind delete cluster --name {{cluster_name}}

# === Helm Repos ===

add-helm-repos:
    bash scripts/add-helm-repos.sh

# === Operators ===

install-operators: install-cert-manager install-keda install-spark-operator

install-cert-manager:
    helm upgrade --install cert-manager jetstack/cert-manager \
        --namespace cert-manager --create-namespace \
        --set crds.enabled=true \
        --wait

install-keda:
    helm upgrade --install keda kedacore/keda \
        --namespace keda --create-namespace \
        -f infra/operators/keda-values.yaml \
        --wait

install-spark-operator:
    helm upgrade --install spark-operator spark-operator/spark-operator \
        --namespace spark-operator --create-namespace \
        -f infra/operators/spark-operator-values.yaml \
        --wait

# === Infrastructure ===

deploy-infra:
    kubectl apply -f infra/namespaces.yaml

# === Apps ===

deploy-all: deploy-minio deploy-opentelemetry deploy-logging deploy-spark-connect-server

deploy-minio:
    helm upgrade --install minio minio/minio \
        --namespace minio --create-namespace \
        -f apps/minio/infra/values.yaml
    kubectl wait --for=condition=ready pod -l app=minio -n minio --timeout=120s
    kubectl apply -f apps/minio/infra/init-buckets-job.yaml

deploy-opentelemetry:
    helm upgrade --install otel-collector open-telemetry/opentelemetry-collector \
        --namespace opentelemetry --create-namespace \
        -f apps/opentelemetry/infra/values.yaml

deploy-logging:
    helm upgrade --install loki grafana/loki \
        --namespace logging --create-namespace \
        -f apps/logging/infra/loki-values.yaml
    helm upgrade --install grafana grafana/grafana \
        --namespace logging \
        -f apps/logging/infra/grafana-values.yaml

deploy-spark-connect-server: (build-load "spark-connect-server")
    kubectl apply -f apps/spark-connect-server/infra/ -n spark

# === Docker Build & Load ===

build app:
    docker build -t {{app}}:latest apps/{{app}}/src/

load app:
    kind load docker-image {{app}}:latest --name {{cluster_name}}

build-load app: (build app) (load app)

# === Job Submission ===

submit-pyspark: (build-load "pyspark-app")
    kubectl apply -f apps/pyspark-app/infra/spark-application.yaml

submit-scala-spark: (build-load "scala-spark-app")
    kubectl apply -f apps/scala-spark-app/infra/spark-application.yaml

# === Port Forwarding ===

pf-minio:
    kubectl port-forward svc/minio-console 9001:9001 -n minio

pf-grafana:
    kubectl port-forward svc/grafana 3000:80 -n logging

pf-spark-connect:
    kubectl port-forward svc/spark-connect-server 15002:15002 -n spark

# Start local JupyterLab (port-forward spark-connect first: just pf-spark-connect)
jupyter:
    apps/jupyter/.venv/bin/jupyter lab apps/jupyter/notebooks/

# === Status ===

status:
    @echo "=== Nodes ==="
    kubectl get nodes
    @echo "\n=== All Pods ==="
    kubectl get pods -A

logs app namespace:
    kubectl logs -l app={{app}} -n {{namespace}} --tail=100 -f
