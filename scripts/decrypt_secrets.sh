#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

while read -r line; do 
    gpg --passphrase "$VAULT_PASSWORD" --yes -d --output "${line/gpg/yaml}" "$line"
done < <(find "$CONFIGURATIONS_PATH" -mindepth 1 -maxdepth 2 -name '*.gpg' | sort) 
