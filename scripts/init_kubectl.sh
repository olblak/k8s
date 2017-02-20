#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

# Allow us to configure kubectl without az configuration
function init_kubectl_ssh {
    echo "Configure kubectl through ssh"
    if [ ! -d .kube ]; then mkdir .kube; fi
    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
        "azureuser@${PREFIX}mgmt.${LOCATION}.cloudapp.azure.com:~/.kube/config"\
        .kube/config
}

# !Require box ssh access
# Require ssh key to be id_rsa -> https://github.com/Azure/azure-cli/issues/1878
# version: 0.1.8 az acs kubernetes get-credentials -n containerservice-overnink8s -g overnink8s
function init_kubectl_azure {
    echo "Confgure kubectl with az"
    az acs kubernetes get-credentials --debug --dns-prefix "${PREFIX}mgmt" "--location=${LOCATION}"
}

while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        "ssh")
            init_kubectl_ssh
            exit 0
        ;;
        "azure")
            init_kubectl_azure
            exit 0
        ;;
        *)
            echo "Wrong argument"
            exit 1
        ;;
    esac
done
