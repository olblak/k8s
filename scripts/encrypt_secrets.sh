#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

while read -r file; do 
    gpg --passphrase "$VAULT_PASSWORD" --yes -c --output "${file/yaml.generated/gpg}" "$file"
    rm "$file"
done < <(find "$CONFIGURATIONS_PATH" -name '*.yaml.generated') 
