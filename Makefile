.PHONY: *

include vars/default.sh
include vars/config.sh

apply: test apply/secrets apply/daemonsets

apply/daemonsets:
	@python scripts/apply_daemonset.py

apply/secrets:
	@kubectl apply -f config/secrets

delete:
	@kubectl delete -f config/daemonsets
	@kubectl delete -f config/secrets

clean:
	@echo "Delete secrets folders"
	@rm -Rf config/secrets

init: init/secrets

init/secrets:
	@for script in `ls scripts/secrets`; do \
		echo "Execute: $$script"; \
		/bin/bash scripts/secrets/$$script; \
	done

init/kubectl_azure:
	# !Require box ssh access
	# Require ssh key to be id_rsa -> https://github.com/Azure/azure-cli/issues/1878
	# version: 0.1.8 az acs kubernetes get-credentials -n containerservice-overnink8s -g overnink8s
	az acs kubernetes get-credentials --debug --dns-prefix $(PREFIX)mgmt --location=$(LOCATION)

init/kubectl_ssh:
	scp azureuser@$(PREFIX)mgmt.$(LOCATION).cloudapp.azure.com:/home/azureuser/.kube/config ~/.kube/config

status:
	@kubectl get pods

test:
	@for scenario in `ls tests/bats`; do \
		echo "Execute: $$scenario"; \
		bats tests/bats/$$scenario; \
	done
