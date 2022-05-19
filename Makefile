# These shell flags are REQUIRED for an early exit in case any program called by make errors!
.SHELLFLAGS=-euo pipefail -c
SHELL := /bin/bash

TARGETS := init check packer tf-login clean help
.PHONY: $(TARGETS)
.DEFAULT_GOAL := help

export TFENV_TERRAFORM_VERSION := 1.1.9
export TFENV_AUTO_INSTALL := true

export AWS_REGION := us-east-1
export AWS_PROFILE := sugarraysam

# TODO - need to add to terraform cloud??
export TF_VAR_aws_account := 905967380707
export TF_VAR_aws_ami := algorand_node_$(shell git rev-parse --short HEAD)

init: ## Validate prerequisites (packer + terraform).
	@./hack/prerequisites.sh
	@terraform fmt -check
	@terraform init

check: init ## Validate
	packer validate packer/
	terraform validate

packer: check ## Build the AMI using packer
	# set to 1 to enable debug output
	# https://www.packer.io/docs/debugging#debugging-packer
	@PACKER_LOG=0 packer build packer/

deploy:
	@echo "not implemented"

clean: ## Clean directory
	@echo "not implemented"

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
