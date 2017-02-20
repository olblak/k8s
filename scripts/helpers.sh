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

if [ -f .env ];  then
    # shellcheck disable=SC1091
    source .env
fi

: "${CONFIGURATIONS_PATH:=./configurations/$ENV/}"
: "${DEFINITIONS_PATH:=./definitions}"

init_configurations_folder
