#!/bin/bash
function init_secrets_folder {
    SECRETS_PATH='./config/secrets'
    if [ ! -d ${SECRETS_PATH} ]; then
        mkdir -p ${SECRETS_PATH}; 
    fi
}
