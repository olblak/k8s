#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

gpg --import "$CONFIGURATIONS_PATH/public.key"
while read -r file; do 
    # Compare newly generated secret file with vault content to only update vault file if needed
    if [ -f "${file/yaml.generated/gpg}" ]; then
        gpg --yes -d --output "${file/generated/tmp}" "${file/yaml.generated/gpg}"

        if [[ "$(diff -I '^#' "${file/generated/tmp}" "${file}")" == '' ]]; then
            rm "${file/generated/tmp}"
            continue
        else
            rm "${file/generated/tmp}"
            echo "${file/yaml.generated/gpg}: Updated"
        fi
    fi
    gpg --encrypt --recipient "$ENV-jenkinsinfra-k8s" --yes --output "${file/yaml.generated/gpg}" "$file"
    rm "$file"
done < <(find "$CONFIGURATIONS_PATH" -name '*.yaml.generated') 
