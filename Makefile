.DEFAULT := help

define log
	@echo "\033[0;31m$(1)\033[0m\n"
endef


.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Environment

.PHONY: install-poetry
install-poetry: ## Install poetry. Usage: make install-poetry
	$(call log, Installing poetry...)
	curl -sSL https://install.python-poetry.org | POETRY_VERSION=1.6.1 python3 - && \
	export "PATH=${HOME}/.local/bin:${PATH}" && \
	poetry config virtualenvs.in-project true && \
	poetry --version

.PHONY: install-project
install-project: ## Install the project dependencies. Usage: make install-project
	$(call log, Installing project dependencies...)
	poetry install --no-interaction --all-extras --with dev --sync

.PHONY: install-pre-commit
install-pre-commit: ## Install pre-commit and git hooks. Usage: make install-pre-commit
	$(call log, Installing pre-commit and git hooks...)
	poetry run pre-commit install --install-hooks


##@ Pre-commit hooks

.PHONY: nox-hooks
nox-hooks: ## Run all the pre-commit hooks in a nox session on all the files. Usage: make nox-hooks
	$(call log, Running all the pre-commit hooks in a nox session...)
	poetry run nox --session hooks

.PHONY: pre-commit-hooks
pre-commit-hooks: ## Run all the pre-commit hooks on all the files. Usage: make pre-commit-hooks
	$(call log, Running all the pre-commit hooks...)
	poetry run pre-commit run --hook-stage manual --show-diff-on-failure --all-files


##@ Docker

.PHONY: build
build: ## Build the spark-local docker image. Usage: make build
	$(call log, Building the spark-local docker image...)
	docker build --tag spark-local .

.PHONY: run
run: ## Create and start the spark-local docker container. Usage: make run
	$(call log, Creating and starting the spark-local docker container...)
	docker run \
		--name spark-local \
		-dit \
		--hostname spark-local \
		-p 4040-4050:4040-4050 \
		-v $(PWD)/apps:/opt/spark/apps \
		-v $(PWD)/logs:/opt/spark/logs \
		-v $(PWD)/logs:/opt/spark/work \
		-v $(PWD)/conf:/opt/spark/conf \
		spark-local

.PHONY: start
start: ## Start the spark-local docker container. Usage: make start
	$(call log, Starting the spark-local docker container...)
	docker start spark-local

.PHONY: stop
stop: ## Stop the spark-local docker container. Usage: make stop
	$(call log, Stopping the spark-local docker container...)
	docker stop spark-local

.PHONY: exec
exec: ## Execute a command in the spark-local docker container. Usage: make exec
	$(call log, Executing a command in the spark-local docker container...)
	docker exec -it spark-local $(cmd)

.PHONY: remove
remove: ## Remove the spark-local docker container. Usage: make remove
	$(call log, Removing the spark-local docker container...)
	docker rm -f spark-local

.PHONY: clean
clean: ## Remove the spark-local docker image and the logs/ directory. Usage: make clean
	$(call log, Removing the spark-local docker image and the logs/ directory...)
	docker image rm -f spark-local
	rm -rf logs/


##@ Spark

.PHONY: spark-start
spark-start: ## Start the Spark cluster. Usage: make spark-start
	$(call log, Starting the Spark cluster...)
	$(MAKE) exec cmd="start-master.sh"
	$(MAKE) exec cmd="start-worker.sh spark://localhost:7077"

.PHONY: spark-stop
spark-stop: ## Stop the Spark cluster. Usage: make spark-stop
	$(call log, Stopping the Spark cluster...)
	$(MAKE) exec cmd="stop-master.sh"
	$(MAKE) exec cmd="stop-worker.sh"

.PHONY: spark-submit
spark-submit: ## Submit a Spark job. Usage: make spark-submit
	$(call log, Submitting the Spark job $(app)...)
	$(MAKE) exec cmd="spark-submit /opt/spark/apps/$(app)"
