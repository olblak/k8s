#!/bin/sh
# All variables define in this script must respect following format
# Which ensure that variable will only be if the value = null or doesn't exist
#: "${VARIABLE}:=value"

: "${SECRETS_PATH:=./config/secrets}"

# Get azure value
: "${AZURE_ARCHIVE_CONTAINER:=k8slogs}"
: "${STORAGE_ACCOUNT_KEY:=$(az storage account keys list -n "${PREFIX}jenkinslogs" -g "${PREFIX}logs" -o json --query 'keys[0].value' | sed 's/\"//g' | sed 's/\r//g')}"
: "${STORAGE_ACCOUNT_NAME:=$(az storage account show -g "${PREFIX}logs" -n "${PREFIX}jenkinslogs" -o json --query name | sed 's/\"//g' | sed 's/\r//g')}"
: "${AZURE_OMS_CUSTOMER_ID:=$(az resource  show --resource-type Microsoft.OperationalInsights/workspaces --resource-group "${PREFIX}logs" -n "${PREFIX}logs" -o json  --query properties.customerId | sed 's/\"//g' | sed 's/\r//g')}"
