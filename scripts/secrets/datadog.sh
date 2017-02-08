#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

# Create datadog secret file
sed "s/DATADOG_API_KEY/${DATADOG_API_KEY}/g" templates/secrets/datadog.yaml > "${SECRETS_PATH}/datadog.yaml"
