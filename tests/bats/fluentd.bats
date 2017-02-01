#!/usr/bin/env bats
#
source .env

@test "Variable: STORAGE_ACCOUNT_LOGS_KEY defined" {
    variable="${STORAGE_ACCOUNT_LOGS_KEY:-empty}"
    [ "$variable" != 'empty' ]
}

@test "File templates/secrets/azure-secret.yaml exist" {
    run stat -c "%F" templates/secrets/azure-secret.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}

@test "Secret generation script exist" {
    run stat -c "%F" scripts/secrets/azure.sh
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
@test "Secret templates configuration exist" {
    run stat -c "%F" templates/secrets/azure-secret.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
@test "Daemonset configuration exist" {
    run stat -c "%F" config/daemonsets/fluentd.yaml 
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
