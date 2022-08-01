.PHONY: help

help: ## Show this help message.
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build and push to docker hub
	@docker buildx build --platform linux/arm/v7,linux/arm64,linux/amd64 --push --tag xdung24/pofwd:latest .