# Spark examples

[![Spark](https://img.shields.io/badge/Spark-3.5.1-blue.svg?logo=apachespark&labelColor=blue&color=lightgray)](https://spark.apache.org/)<br>

[![Python 3.10.12](https://img.shields.io/badge/python-3.10.12-blue.svg?labelColor=%23FFE873&logo=python)](https://www.python.org/downloads/release/python-31012/)<br>

[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://docs.astral.sh/ruff/) [![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://black.readthedocs.io/en/stable/) [![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)<br>

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org) [![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://pre-commit.com/)

This repo holds some examples, to start familiarizing yourself with [Spark](https://spark.apache.org/).

The idea is to quickly create a Spark cluster in your machine, and then run some jobs. In these examples, we're going to use the Sparks' Python API, named [PySpark](https://spark.apache.org/docs/latest/api/python/index.html).

## Directories structure

```text
.
├── .dockerignore
├── .gitignore
├── .markdownlint.json
├── .pre-commit-config.yaml
├── .python-version
├── .vscode
│   ├── extensions.json
│   └── settings.json
├── Dockerfile
├── LICENSE
├── Makefile
├── README.md
├── apps
│   ├── intro.py
│   └── python_app.py
├── conf
│   ├── spark-env.sh
│   └── workers
├── mypy.ini
├── noxfile.py
├── poetry.lock
└── pyproject.toml

4 directories, 19 files
```

## Pre-requisites

You'll need the following tools in your machine:

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [GNU make](https://www.gnu.org/software/make/)

Also, it's recommended to have [pyenv](https://github.com/pyenv/pyenv) installed and working.

Please, keep in mind that a small Spark cluster like this one requires at least 2GB of RAM and 1 CPU core.

## Set up the environment

### 1. Build the Docker image

The first thing you'll need to do is build the required Docker image:

```shell
make build
```

The built image is tagged as `spark-local`.

### 2. Start the container

You can start the `spark-local` container with:

```shell
make run
```

### 3. Configure the Spark cluster

In the `conf/spark-env.sh` file you'll find some settings to configure the Spark cluster.

This example uses the following settings:

```shell
# conf/spark-env.sh

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
```

All these settings are self-explanatory, but for example, you can modify the number of worker nodes by changing the `SPARK_WORKER_INSTANCES` variable.

### 4. Start the Spark cluster

You can start the Spark cluster with:

```shell
make spark-start
```

Wait a few seconds, and go to `localhost:4040` in your browser, you'll see a UI like this:

![master](images/master.png)

## Run Spark jobs
