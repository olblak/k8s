.PHONY: *

sinclude .env

export PATH := ./bin:$(PATH)
export KUBECONFIG := .kube/config

apply: apply/configurations apply/definitions

apply/configurations:
	@echo "Apply Configurations files"
	@/bin/bash ./scripts/apply_configurations.sh

apply/definitions:
	@echo "Apply Definitions files"
	@/bin/bash ./scripts/apply_definitions.sh

clean: clean/secrets

clean/secrets:
	@echo "Delete secrets folders"
	@/bin/bash ./scripts/clean_secrets.sh

generate/secrets:
	@for script in $$(find ./scripts/secrets_generator -name '*.sh'); do \
		echo $$script; \
		/bin/bash $$script; \
	done
	@/bin/bash  ./scripts/encrypt_secrets.sh
	@/bin/bash ./scripts/clean_secrets.sh

init: init/secrets init/kubectl/ssh

init/secrets:
	/bin/bash  ./scripts/decrypt_secrets.sh

init/kubectl/azure:
	# !Require box ssh access
	# Require ssh key to be id_rsa -> https://github.com/Azure/azure-cli/issues/1878
	# version: 0.1.8 az acs kubernetes get-credentials -n containerservice-overnink8s -g overnink8s
	az acs kubernetes get-credentials --debug --dns-prefix $(PREFIX)mgmt --location=$(LOCATION)

init/kubectl/ssh:
	# Allow us to configure kubectl without az configuration
	@if [ ! -d .kube ]; then mkdir .kube; fi
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no azureuser@$(PREFIX)mgmt.$(LOCATION).cloudapp.azure.com:~/.kube/config .kube/config

status:
	@kubectl get pods --all-namespaces

get/endpoint:
	@kubectl get service --namespace nginx-ingress | grep nginx

test:
	@for scenario in `ls tests/bats`; do \
		echo "Execute: $$scenario"; \
		bats tests/bats/$$scenario; \
	done

proxy:
	@kubectl proxy
