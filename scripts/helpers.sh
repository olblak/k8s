#!/bin/bash


function init_secrets_folder {
    if [ ! -d "${SECRETS_PATH}" ]; then
        mkdir -p "${SECRETS_PATH}"; 
    fi
}

if [ -f vars/config.sh ];  then
    # shellcheck disable=SC1091
    source vars/config.sh
fi

# shellcheck disable=SC1091
source vars/default.sh
# shellcheck disable=SC1091

init_secrets_folder
