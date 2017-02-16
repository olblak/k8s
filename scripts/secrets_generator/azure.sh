#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

GENERATOR_PATH="$(dirname $0)"

# Get azure value
: "${AZURE_ARCHIVE_CONTAINER:=k8slogs}"
: "${STORAGE_ACCOUNT_KEY:=$(az storage account keys list -n "${PREFIX}jenkinslogs" -g "${PREFIX}logs" -o json --query 'keys[0].value' | sed 's/\"//g' | sed 's/\r//g')}"
: "${STORAGE_ACCOUNT_NAME:=$(az storage account show -g "${PREFIX}logs" -n "${PREFIX}jenkinslogs" -o json --query name | sed 's/\"//g' | sed 's/\r//g')}"
: "${AZURE_OMS_CUSTOMER_ID:=$(az resource  show --resource-type Microsoft.OperationalInsights/workspaces --resource-group "${PREFIX}logs" -n "${PREFIX}logs" -o json  --query properties.customerId | sed 's/\"//g' | sed 's/\r//g')}"

STORAGE_ACCOUNT_KEY=$(echo -n "$STORAGE_ACCOUNT_KEY" | base64 -w 0)
STORAGE_ACCOUNT_NAME=$(echo -n "$STORAGE_ACCOUNT_NAME" | base64 -w 0)
AZURE_OMS_CUSTOMER_ID=$(echo -n "$AZURE_OMS_CUSTOMER_ID" | base64 -w 0)
STORAGE_ACCOUNT_LOGS_KEY=$(echo -n "$STORAGE_ACCOUNT_LOGS_KEY" | base64 -w 0)
AZURE_ARCHIVE_CONTAINER=$(echo -n "$AZURE_ARCHIVE_CONTAINER" | base64 -w 0 )
AZURE_ARCHIVE_STORAGE_ACCESSKEY=$(echo -n "$STORAGE_ACCOUNT_LOGS_KEY" | base64 -w 0)

# Create azure secret file
sed "s/STORAGE_ACCOUNT_KEY/$STORAGE_ACCOUNT_KEY/g" "$GENERATOR_PATH/templates/azure-secret.yaml" > "config/env/$ENV/secrets/azure-secret.yaml.generated"
sed -i "s/STORAGE_ACCOUNT_NAME/$STORAGE_ACCOUNT_NAME/g" "config/env/$ENV/secrets/azure-secret.yaml.generated"
sed -i "s/AZURE_OMS_CUSTOMER_ID/$AZURE_OMS_CUSTOMER_ID/g" "config/env/$ENV/secrets/azure-secret.yaml.generated"
sed -i "s/STORAGE_ACCOUNT_LOGS_KEY/$STORAGE_ACCOUNT_LOGS_KEY/g" "config/env/$ENV/secrets/azure-secret.yaml.generated"
sed -i "s/AZURE_ARCHIVE_CONTAINER/$AZURE_ARCHIVE_CONTAINER/g" "config/env/$ENV/secrets/azure-secret.yaml.generated"
sed -i "s/AZURE_ARCHIVE_STORAGE_ACCESSKEY/$AZURE_ARCHIVE_STORAGE_ACCESSKEY/g" "config/env/$ENV/secrets/azure-secret.yaml.generated"
