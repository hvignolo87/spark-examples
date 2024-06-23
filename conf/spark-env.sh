#!/bin/bash

# Spark cluster configs

# References:
# https://spark.apache.org/docs/3.5.1/configuration.html#available-properties
# https://spark.apache.org/docs/3.5.1/spark-standalone.html#cluster-launch-scripts

# shellcheck disable=SC2034
SPARK_EXECUTOR_CORES=1
SPARK_EXECUTOR_MEMORY=512M
SPARK_DRIVER_MEMORY=512M
SPARK_MASTER_HOST=localhost
SPARK_MASTER_PORT=7077
SPARK_MASTER_WEBUI_PORT=4040
SPARK_WORKER_CORES=1
SPARK_WORKER_MEMORY=1G
SPARK_WORKER_INSTANCES=3
SPARK_WORKER_PORT=9000
SPARK_WORKER_WEBUI_PORT=4041
SPARK_DAEMON_MEMORY=512M
PYSPARK_PYTHON="$(pyenv which python)"
PYSPARK_DRIVER_PYTHON="$(pyenv which python)"
