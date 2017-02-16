#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

while read -r line; do 
    gpg --passphrase "$VAULT_PASSWORD" -d --output "${line/gpg/yaml}" "$line"
done < <(find ./config/env/$ENV/secrets -name '*.gpg') 
