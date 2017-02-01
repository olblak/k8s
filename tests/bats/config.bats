#!/usr/bin/env bats
#
source .env

@test "Variable: PREFIX defined" {
    run echo "${PREFIX:-empty}"

    [ "$output" != 'empty' ]
}

@test "Variable: LOCATION defined" {
    result="${LOCATION:-empty}"
    [ "$result" != 'empty' ]
}

@test "Connect to kubernetes cluster" {
    run kubectl cluster-info
    [ "$status" -eq 0 ]
}

@test "File: .env exist and not empty" {
    run stat -c "%F" .env
    [ "$status" -eq 0 ]
    [ "$output" = "regular file" ]
}

@test "Gitignore: contain .env" {
    run grep .env .gitignore
    [ "$status" -eq 0 ]
    [ "$output" = ".env" ]
}

@test "Gitignore: contain config/secrets" {
    run grep config/secrets .gitignore
    [ "$status" -eq 0 ]
    [ "$output" = "config/secrets" ]
}
