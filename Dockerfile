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

ENTRYPOINT /bin/bash
