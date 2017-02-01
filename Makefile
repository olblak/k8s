.PHONY: *
include .env

apply: apply_secrets apply_daemonsets

apply_daemonsets: 
	@kubectl apply -f config/daemonsets

apply_secrets:
	@kubectl apply -f config/secrets

clean: 
	@echo "Delete secrets folders"
	@rm -Rf config/secrets

init: init_secrets

init_secrets: 
	@for script in `ls scripts/secrets`; do \
		echo "Execute: $$script"; \
		/bin/bash scripts/secrets/$$script; \
	done

get_kubectl_config:
	# !Require box ssh access
	# Require ssh key to be id_rsa -> https://github.com/Azure/azure-cli/issues/1878
	az acs kubernetes get-credentials --debug --dns-prefix $(PREFIX)mgmt --location=$(LOCATION)

status: 
	@kubectl get pods

test:
	@for scenario in `ls tests/bats`; do \
		echo "Execute: $$scenario"; \
		bats tests/bats/$$scenario; \
	done
