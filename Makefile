.PHONY: *

export PATH := ./.bin:$(PATH)
export KUBECONFIG := .kube/config

apply: apply/systems apply/configurations apply/definitions

apply/configurations:
	@echo "Apply Configurations files"
	@/bin/bash ./scripts/apply_resources.sh -c

apply/definitions:
	@echo "Apply Definitions files"
	@/bin/bash ./scripts/apply_resources.sh -d

apply/systems:
	@echo "Apply Definitions files"
	@/bin/bash ./scripts/apply_resources.sh -s

clean: clean/secrets clean/trash

clean/secrets:
	@echo "Delete secrets folders"
	@/bin/bash ./scripts/clean_secrets.sh

clean/trash:
	@if [ $$( ls resources/trash | wc -l) -gt '0' ]; then \
		kubectl delete -f resources/trash --ignore-not-found=true -R -o name 2>/dev/null; \
		else \
		echo "Nothing to clean"; \
	 fi

generate/secrets:
	@for script in $$(find ./scripts/secrets_generator -name '*.sh'); do \
		echo $$script; \
		/bin/bash $$script; \
	done
	@/bin/bash  ./scripts/encrypt_secrets.sh
	@/bin/bash ./scripts/clean_secrets.sh

init: init/secrets init/kubectl init/kubectl/ssh

init/secrets:
	/bin/bash  ./scripts/decrypt_secrets.sh

init/kubectl:
	if [ ! -d .bin ]; then mkdir .bin; fi
	@curl -L https://storage.googleapis.com/kubernetes-release/release/$$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o ./.bin/kubectl
	@chmod +x ./.bin/kubectl
init/kubectl/azure:
	@/bin/bash ./scripts/init_kubectl.sh azure

init/kubectl/ssh:
	@/bin/bash ./scripts/init_kubectl.sh ssh

status:
	@kubectl get pods --all-namespaces

get/endpoint:
	@/bin/bash -c 'source scripts/helpers.sh && get_public_ip'

# Disable test as they are broken
#test:
#	@for scenario in `ls tests/bats`; do \
#		echo "Execute: $$scenario"; \
#		bats tests/bats/$$scenario; \
#	done

proxy:
	@kubectl proxy


