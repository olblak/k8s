#!/bin/bash


function init_secrets_folder {
    if [ ! -d "${SECRETS_PATH}" ]; then
        mkdir -p "${SECRETS_PATH}"; 
    fi
}

# shellcheck disable=SC1091
source vars/config.sh
# shellcheck disable=SC1091
source vars/default.sh
# shellcheck disable=SC1091
source vars/base64.sh


init_secrets_folder
