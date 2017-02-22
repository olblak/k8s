#!/bin/bash

# shellcheck disable=SC2034

function init_configurations_folder {
    if [ ! -d "${CONFIGURATIONS_PATH}" ]; then
        mkdir -p "${CONFIGURATIONS_PATH}"; 
    fi
}

function init_secret_file {
    if [ ! -d "${CONFIGURATIONS_PATH}/$1" ]; then
        mkdir -p "${CONFIGURATIONS_PATH}/$1"; 
    fi
    SECRET_FILE="$CONFIGURATIONS_PATH/$1/secret.yaml.generated"
    echo "# Secret generated on $(date)" > "$SECRET_FILE"
    echo "#=======" >> "$SECRET_FILE"
    echo "$SECRET_FILE"
}

function get_public_ip {
    DNS_RECORDS=''
    while read -r line; do
        DNS_RECORDS="$(grep 'host:' "$line" | awk '{print $3}') $DNS_RECORDS"
    done < <(find "$CONFIGURATIONS_PATH" -name 'ingress-tls.yaml')
    printf "\nHostname:\n%s\n\nmust be redirected to \n\t %s\n\n" \
        "$DNS_RECORDS" \
		"$(kubectl get service nginx --namespace nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[*].ip}')"
    printf "Run make get/endpoint to display this message"
}


if [ -f k8s.cfg ];  then
    # shellcheck disable=SC1091
    source k8s.cfg
fi

# shellcheck disable=SC1091
source k8s.default

init_configurations_folder
