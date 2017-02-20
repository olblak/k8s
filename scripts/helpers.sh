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

source k8s.default

if [ -f k8s.cfg ];  then
    # shellcheck disable=SC1091
    source k8s.cfg
fi

: "${CONFIGURATIONS_PATH:=./configurations/$ENV/}"
: "${DEFINITIONS_PATH:=./definitions}"

init_configurations_folder
