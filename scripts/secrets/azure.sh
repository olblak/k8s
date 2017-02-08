#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

# Create azure secret file
sed "s/STORAGE_ACCOUNT_KEY/$STORAGE_ACCOUNT_KEY/g" templates/secrets/azure-secret.yaml > config/secrets/azure-secret.yaml
sed -i "s/STORAGE_ACCOUNT_NAME/$STORAGE_ACCOUNT_NAME/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_OMS_CUSTOMER_ID/$AZURE_OMS_CUSTOMER_ID/g" config/secrets/azure-secret.yaml
sed -i "s/STORAGE_ACCOUNT_LOGS_KEY/$STORAGE_ACCOUNT_LOGS_KEY/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_ARCHIVE_CONTAINER/$AZURE_ARCHIVE_CONTAINER/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_ARCHIVE_STORAGE_ACCESSKEY/$AZURE_ARCHIVE_STORAGE_ACCESSKEY/g" config/secrets/azure-secret.yaml
