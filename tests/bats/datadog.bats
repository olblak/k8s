#!/usr/bin/env bats
#
source .env

@test "Variable: DATADOG_API_KEY defined" {
    variable=="${DATADOG_API_KEY:-empty}"

    [ "$variable" != 'empty' ]
}
@test "Secret generation script exist" {
    run stat -c "%F" scripts/secrets/datadog.sh
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
@test "Secret templates configuration exist" {
    run stat -c "%F" templates/secrets/datadog.yaml
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
@test "Daemonset configuration exist" {
    run stat -c "%F" config/daemonsets/dd-agent.yaml 
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
