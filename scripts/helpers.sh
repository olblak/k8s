#!/bin/bash

# shellcheck disable=SC2034

function init_secrets_folder {
    if [ ! -d "${SECRETS_PATH}" ]; then
        mkdir -p "${SECRETS_PATH}"; 
    fi
}

function init_secret_file {
    SECRET_FILE="$SECRETS_PATH/$1.yaml.generated"
    echo "# Secret generated on $(date)" > "$SECRET_FILE"
    echo "#=======" >> "$SECRET_FILE"
    echo "$SECRET_FILE"
}

if [ -f vars/config ];  then
    # shellcheck disable=SC1091
    source vars/config
fi

# shellcheck disable=SC1091
source vars/default
# shellcheck disable=SC1091

init_secrets_folder
