SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
# .DELETE_ON_ERROR:
MAKEFLAGS = --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

py = $$(if [ -d $(PWD)/'.venv' ]; then echo $(PWD)/".venv/bin/python3"; else echo "python3"; fi)
pip = $(py) -m pip

# Override PWD so that it's always based on the location of the file and **NOT**
# based on where the shell is when calling `make`. This is useful if `make`
# is called like `make -C <some path>`
PWD := $(realpath $(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
MAKEFILE_PWD := $(CURDIR)
WORKTREE_ROOT := $(shell git rev-parse --show-toplevel 2> /dev/null)


# Using $$() instead of $(shell) to run evaluation only when it's accessed
# https://unix.stackexchange.com/a/687206
py = $$(if [ -d $(PWD)/'.venv' ]; then echo $(PWD)/".venv/bin/python3"; else echo "python3"; fi)
pip = $(py) -m pip

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@echo "Usage: make [target], targets are:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: init
init: .venv  ## Initialize the project
	$(pip) install -U -r requirements.txt

.venv: requirements.txt  ## Build the virtual environment
	$(py) -m venv .venv
	$(pip) install -U pip setuptools wheel build
	$(pip) install -U -r requirements.txt
	touch .venv

.PHONY: test
test: .venv  ## Run tests
	$(py) -m unittest test_default_class.py