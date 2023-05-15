MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := build

.PHONY: setup build run test clean help

.git/hooks/pre-commit: .pre-commit-config.yaml
	pre-commit install

setup: .git/hooks/pre-commit

hello: cmd/hello/main.go pkg/*.go
	go build ./cmd/hello
	@# go build -o hello

build: hello ## build binary file

run: ## run app
	@go run cmd/hello/main.go

test:
	go test ./pkg

clean: ## cleanup binary
	@if [ -f ./hello ]; then rm hello; fi

help: ## Print this help
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
