.PHONY: *

include k8s.default
sinclude k8s.cfg

export PATH := ./bin:$(PATH)
export KUBECONFIG := .kube/config

apply: apply/configurations apply/definitions

apply/configurations:
	@echo "Apply Configurations files"
	@/bin/bash ./scripts/apply_resources.sh -c

apply/definitions:
	@echo "Apply Definitions files"
	@/bin/bash ./scripts/apply_resources.sh -d

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
	@/bin/bash ./scripts/init_kubectl.sh azure

init/kubectl/ssh:
	@/bin/bash ./scripts/init_kubectl.sh ssh

status:
	@kubectl get pods --all-namespaces

get/endpoint:
	@kubectl get service --namespace nginx-ingress | grep nginx

# Disable test as they are broken
#test:
#	@for scenario in `ls tests/bats`; do \
#		echo "Execute: $$scenario"; \
#		bats tests/bats/$$scenario; \
#	done

proxy:
	@kubectl proxy
