#!/usr/bin/env bats

@test "scripts/secrets/datadog.sh should exist" {
    run stat -c "%F" scripts/secrets/datadog.sh
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}

@test "scripts/secrets/azure.sh should exist" {
    run stat -c "%F" scripts/secrets/azure.sh
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
