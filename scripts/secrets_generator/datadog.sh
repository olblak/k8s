#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

GENERATOR_PATH="$(dirname $0)"

DATADOG_API_KEY=$(echo -n "${DATADOG_API_KEY}"| base64)

# Create datadog secret file
sed "s/DATADOG_API_KEY/${DATADOG_API_KEY}/g" "${GENERATOR_PATH}/templates/datadog.yaml" > "config/env/$ENV/secrets/datadog.yaml"
