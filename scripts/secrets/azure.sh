#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source .env
# shellcheck disable=SC1091
source ./scripts/helpers.sh

init_secrets_folder

# Exit if required variable doesn't exist
: "${STORAGE_ACCOUNT_LOGS_KEY:?required}"

# Get azure value
: "${AZURE_ARCHIVE_CONTAINER:=k8slogs}"
: "${STORAGE_ACCOUNT_KEY:=$(az storage account keys list -n "${PREFIX}jenkinslogs" -g "${PREFIX}logs" -o json --query '[0].value' | sed 's/"//g')}"
: "${STORAGE_ACCOUNT_NAME:=$(az storage account show -g "${PREFIX}logs" -n "${PREFIX}jenkinslogs" -o json --query name | sed 's/"//g')}"
: "${AZURE_OMS_CUSTOMER_ID:=$(az resource  show --resource-type Microsoft.OperationalInsights/workspaces --resource-group "${PREFIX}logs" -n "${PREFIX}logs" -o json  --query properties.customerId | sed 's/"//g')}"

# Encode in base64
STORAGE_ACCOUNT_KEY=$(echo -n "$STORAGE_ACCOUNT_KEY" | base64 -w 0)
STORAGE_ACCOUNT_NAME=$(echo -n "$STORAGE_ACCOUNT_NAME" | base64 -w 0)
AZURE_OMS_CUSTOMER_ID=$(echo -n "$AZURE_OMS_CUSTOMER_ID" | base64 -w 0)
STORAGE_ACCOUNT_LOGS_KEY=$(echo -n "$STORAGE_ACCOUNT_LOGS_KEY" | base64 -w 0)
AZURE_ARCHIVE_CONTAINER=$(echo -n "$AZURE_ARCHIVE_CONTAINER" | base64 -w 0 )
AZURE_ARCHIVE_STORAGE_ACCESSKEY=$(echo -n "$STORAGE_ACCOUNT_LOGS_KEY" | base64 -w 0)

# Create azure secret file
sed "s/STORAGE_ACCOUNT_KEY/$STORAGE_ACCOUNT_KEY/g" templates/secrets/azure-secret.yaml > config/secrets/azure-secret.yaml
sed -i "s/STORAGE_ACCOUNT_NAME/$STORAGE_ACCOUNT_NAME/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_OMS_CUSTOMER_ID/$AZURE_OMS_CUSTOMER_ID/g" config/secrets/azure-secret.yaml
sed -i "s/STORAGE_ACCOUNT_LOGS_KEY/$STORAGE_ACCOUNT_LOGS_KEY/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_ARCHIVE_CONTAINER/$AZURE_ARCHIVE_CONTAINER/g" config/secrets/azure-secret.yaml
sed -i "s/AZURE_ARCHIVE_STORAGE_ACCESSKEY/$AZURE_ARCHIVE_STORAGE_ACCESSKEY/g" config/secrets/azure-secret.yaml
