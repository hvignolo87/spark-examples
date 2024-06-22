FROM apache/spark:3.5.1

USER root

WORKDIR ${HOME}

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked <<END
		apt-get update && \
		apt-get install --no-install-recommends --no-install-suggests -y \
        git \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        lzma-dev && \
        apt-get clean && \
        apt-get autoremove -y
END

ARG PYENV_ROOT="/usr/local/.pyenv"

ENV PYENV_ROOT="${PYENV_ROOT}" \
    PATH="${PYENV_ROOT}/bin:${PATH}"

RUN curl https://pyenv.run | bash

RUN <<END
    echo 'export PYENV_ROOT="${PYENV_ROOT}"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin:${PATH}"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc" && \
    eval "$(pyenv init --path)"
END

COPY ./.python-version .

RUN <<END
    pyenv install -s $(cat .python-version) && \
    pyenv global $(cat .python-version)
END

USER spark

ENV PYENV_ROOT="${PYENV_ROOT}" \
    PATH="${PYENV_ROOT}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"

WORKDIR ${SPARK_HOME}

RUN <<END
    mkdir -p ./conf && \
    echo "localhost" > ./conf/workers
END

RUN cat <<EOL > ./conf/spark-env.sh
SPARK_EXECUTOR_CORES=1
SPARK_EXECUTOR_MEMORY=512M
SPARK_DRIVER_MEMORY=512M
PYSPARK_PYTHON="$(pyenv which python)"
PYSPARK_DRIVER_PYTHON="$(pyenv which python)"
SPARK_MASTER_HOST=localhost
SPARK_MASTER_PORT=7077
SPARK_MASTER_WEBUI_PORT=4040
SPARK_WORKER_CORES=1
SPARK_WORKER_MEMORY=1G
SPARK_WORKER_INSTANCES=3
SPARK_WORKER_PORT=9000
SPARK_WORKER_WEBUI_PORT=4041
SPARK_DAEMON_MEMORY=512M
EOL

ENTRYPOINT /bin/bash
