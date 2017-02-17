#!/bin/bash
 
set +e
set +x

# shellcheck disable=SC1091
source ./scripts/helpers.sh

GENERATOR_PATH="$(dirname "$0")"

# Get azure value
: "${AZURE_ARCHIVE_CONTAINER:=k8slogs}"
: "${STORAGE_ACCOUNT_KEY:=$(az storage account keys list -n "${PREFIX}jenkinslogs" -g "${PREFIX}logs" -o json --query 'keys[0].value' | sed 's/\"//g' | sed 's/\r//g')}"
: "${STORAGE_ACCOUNT_NAME:=$(az storage account show -g "${PREFIX}logs" -n "${PREFIX}jenkinslogs" -o json --query name | sed 's/\"//g' | sed 's/\r//g')}"
: "${AZURE_OMS_CUSTOMER_ID:=$(az resource  show --resource-type Microsoft.OperationalInsights/workspaces --resource-group "${PREFIX}logs" -n "${PREFIX}logs" -o json  --query properties.customerId | sed 's/\"//g' | sed 's/\r//g')}"

STORAGE_ACCOUNT_KEY=$(echo -n "${STORAGE_ACCOUNT_KEY:?Empty}" | base64 -w 0)
STORAGE_ACCOUNT_NAME=$(echo -n "${STORAGE_ACCOUNT_NAME:?Empty}" | base64 -w 0)
AZURE_OMS_CUSTOMER_ID=$(echo -n "${AZURE_OMS_CUSTOMER_ID:?Empty}" | base64 -w 0)
STORAGE_ACCOUNT_LOGS_KEY=$(echo -n "${STORAGE_ACCOUNT_LOGS_KEY:?Empty}" | base64 -w 0)
AZURE_ARCHIVE_CONTAINER=$(echo -n "${AZURE_ARCHIVE_CONTAINER:?}" | base64 -w 0 )
AZURE_ARCHIVE_STORAGE_ACCESSKEY=$(echo -n "${STORAGE_ACCOUNT_LOGS_KEY:?Empty}" | base64 -w 0)

# Create azure secret file
SECRET_FILE=$(init_secret_file 'azure-secret')
sed "s/STORAGE_ACCOUNT_KEY/$STORAGE_ACCOUNT_KEY/g" "$GENERATOR_PATH/templates/azure-secret.yaml" >> "$SECRET_FILE"
sed -i "s/STORAGE_ACCOUNT_NAME/$STORAGE_ACCOUNT_NAME/g" "$SECRET_FILE"
sed -i "s/AZURE_OMS_CUSTOMER_ID/$AZURE_OMS_CUSTOMER_ID/g" "$SECRET_FILE"
sed -i "s/STORAGE_ACCOUNT_LOGS_KEY/$STORAGE_ACCOUNT_LOGS_KEY/g" "$SECRET_FILE"
sed -i "s/AZURE_ARCHIVE_CONTAINER/$AZURE_ARCHIVE_CONTAINER/g" "$SECRET_FILE"
sed -i "s/AZURE_ARCHIVE_STORAGE_ACCESSKEY/$AZURE_ARCHIVE_STORAGE_ACCESSKEY/g" "$SECRET_FILE"
