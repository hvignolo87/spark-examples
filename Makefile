.DEFAULT_GOAL := help

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


##@ Docker

.PHONY: build
build: ## Build the spark-local docker image
	docker build --tag spark-local .

.PHONY: run
run: ## Create and start the spark-local docker container
	docker run \
		--name spark-local \
		-dit \
		--hostname spark-local \
		-p 4040-4050:4040-4050 \
		-v $(PWD)/apps:/opt/spark/apps \
		-v $(PWD)/logs:/opt/spark/logs \
		-v $(PWD)/logs:/opt/spark/work \
		spark-local

.PHONY: start
start: ## Start the spark-local docker container
	docker start spark-local

.PHONY: stop
stop: ## Stop the spark-local docker container
	docker stop spark-local

.PHONY: exec
exec: ## Execute a command in the spark-local docker container
	docker exec -it spark-local $(cmd)

.PHONY: remove
remove: ## Remove the spark-local docker container
	docker rm -f spark-local

.PHONY: clean
clean: ## Remove the spark-local docker image and the logs/ directory
	docker image rm -f spark-local
	rm -rf $(PWD)/logs


##@ Spark

.PHONY: start-spark
start-spark: ## Start the Spark cluster
	$(MAKE) exec cmd="start-master.sh"
	$(MAKE) exec cmd="start-worker.sh spark://localhost:7077"

.PHONY: stop-spark
stop-spark: ## Stop the Spark cluster
	$(MAKE) exec cmd="stop-master.sh"
	$(MAKE) exec cmd="stop-worker.sh"

.PHONY: spark-submit
spark-submit: ## Submit a Spark job
	$(MAKE) exec cmd="spark-submit /opt/spark/apps/$(app)"
