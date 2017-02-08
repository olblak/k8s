#!/usr/bin/env bats
#

@test "templates/secrets/azure-secret.yaml should exist" {
    run stat -c "%F" templates/secrets/datadog.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}

@test "templates/secrets/azure-secret.yaml should exist" {
    run stat -c "%F" templates/secrets/azure-secret.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}

@test "templates/secrets/azure-secret.yaml should exist" {
    run stat -c "%F" templates/secrets/azure-secret.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
