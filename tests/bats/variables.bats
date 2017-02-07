#!/usr/bin/env bats
#
#
# Datadog Variable
#
source vars/config.sh
source vars/default.sh

@test "Variable: DATADOG_API_KEY  should be defined" {
    run bash -c ": ${DATADOG_API_KEY:?}"
    [ $status -eq '0' ]
}

# Azure Variables
@test "Variable: PREFIX  should be defined" {
    run bash -c ": ${PREFIX:?}"
    [ $status -eq '0' ]
}
@test "Variable: LOCATION  should be defined" {
    run bash -c ": ${LOCATION:?}"
    [ $status -eq '0' ]
}

# Fluentd Variables
@test "Variable: AZURE_ARCHIVE_CONTAINER  should be defined" {
    run bash -c ": ${AZURE_ARCHIVE_CONTAINER:?}"
    [ $status -eq '0' ]
}
@test "Variable: STORAGE_ACCOUNT_KEY  should be defined" {
    run bash -c ": ${STORAGE_ACCOUNT_KEY:?}"
    [ $status -eq '0' ]
}
@test "Variable: STORAGE_ACCOUNT_NAME  should be defined" {
    run bash -c ": ${STORAGE_ACCOUNT_NAME:?}"
    [ $status -eq '0' ]
}
@test "Variable: AZURE_OMS_CUSTOMER_ID  should be defined" {
    run bash -c ": ${AZURE_OMS_CUSTOMER_ID:?}"
    [ $status -eq '0' ]
}
@test "Variable: STORAGE_ACCOUNT_LOGS_KEY  should be defined" {
    run bash -c ": ${STORAGE_ACCOUNT_LOGS_KEY:?}"
    [ $status -eq '0' ]
}
