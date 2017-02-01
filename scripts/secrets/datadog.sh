#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source .env
# shellcheck disable=SC1091
source ./scripts/helpers.sh

init_secrets_folder

# Exit if require variable doesn't exist
: "${DATADOG_API_KEY?Required}"

# Encode in base64
DATADOG_API_KEY=$(echo -n "${DATADOG_API_KEY}"| base64)

# Create datadog secret file
sed "s/DATADOG_API_KEY/${DATADOG_API_KEY}/g" templates/secrets/datadog.yaml > "${SECRETS_PATH}/datadog.yaml"
