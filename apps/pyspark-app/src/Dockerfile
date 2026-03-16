FROM apache/spark-py:3.5.3
USER root
COPY requirements.txt /opt/spark/requirements.txt
RUN pip install --no-cache-dir -r /opt/spark/requirements.txt
COPY main.py /opt/spark/work-dir/main.py
USER spark
