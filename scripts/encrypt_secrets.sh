#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

while read -r file; do 
    # Compare newly generated secret file with vault content to only update vault file if needed
    if [ -f "${file/yaml.generated/gpg}" ]; then
        gpg --passphrase "$VAULT_PASSWORD" --yes -d --output "${file/generated/tmp}" "${file/yaml.generated/gpg}"

        if [[ "$(diff -I '^#' "${file/generated/tmp}" "${file}")" == '' ]]; then
            rm "${file/generated/tmp}"
            continue
        else
            rm "${file/generated/tmp}"
            echo "${file/yaml.generated/gpg}: Updated"
        fi
    fi
    gpg --passphrase "$VAULT_PASSWORD" --yes -c --output "${file/yaml.generated/gpg}" "$file"
    rm "$file"
done < <(find "$CONFIGURATIONS_PATH" -name '*.yaml.generated') 
