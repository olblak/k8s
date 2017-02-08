#!/usr/bin/env bats
#
source ./scripts/helpers.sh

# Useless test
#@test "Should not be able to decode non base64 string" {
#    run bash -c "echo nonbase64 | base64 -d"
#    [ "$status" -ne "0" ] 
#}

@test  "STORAGE_ACCOUNT_KEY should be base64 encoded" {
    run bash -c "echo $STORAGE_ACCOUNT_KEY | base64 -d"
    [ "$status" -eq 0 ]
}

@test "STORAGE_ACCOUNT_NAME should be base64 encoded"  {
    run bash -c "echo $STORAGE_ACCOUNT_NAME | base64 -d"
    [ "$status" -eq 0 ]
}

@test "AZURE_OMS_CUSTOMER_ID should be base64 encoded" {
    run bash -c "echo $AZURE_OMS_CUSTOMER_ID | base64 -d"
    [ "$status" -eq 0 ]
}

@test "STORAGE_ACCOUNT_LOGS_KEY should be base64 encoded" {
    run bash -c "echo $STORAGE_ACCOUNT_LOGS_KEY | base64 -d"
    [ "$status" -eq 0 ]
}

@test "AZURE_OMS_CUSTOMER_ID should be base64 encoded" {
    run bash -c "echo $AZURE_OMS_CUSTOMER_ID | base64 -d"
    [ "$status" -eq 0 ]
}

@test "AZURE_ARCHIVE_CONTAINER should be base64 encoded" {
    run bash -c "echo $AZURE_ARCHIVE_CONTAINER | base64 -d"
    [ "$status" -eq 0 ]
}

@test "DATADOG_API_KEY should be base64 encoded" {
    run bash -c "echo ${DATADOG_API_KEY} | base64 -d"
    [ "$status" -eq 0 ]
}
