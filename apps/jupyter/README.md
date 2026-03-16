# Jupyter

Local JupyterLab that connects to the Spark Connect Server via port-forward.

## Setup

```bash
pip install -r apps/jupyter/requirements.txt
```

## Usage

```bash
# In one terminal — forward Spark Connect
just pf-spark-connect

# In another terminal — start JupyterLab
just jupyter
```

Then open `notebooks/spark_connect_demo.ipynb`.

## Notebooks

| Notebook | Description |
|----------|-------------|
| `spark_connect_demo.ipynb` | DataFrame ops, SQL window functions, Iceberg write/read on MinIO, matplotlib chart |

## Connection

```python
SparkSession.builder.remote("sc://localhost:15002")
```
