#!/usr/bin/env bats
#
source ./scripts/helpers.sh

@test "Connect to kubernetes cluster" {
    run kubectl cluster-info
    [ "$status" -eq 0 ]
}

@test "File: vars/config exist " {
    run stat -c "%F" vars/config.sh
    [ "$status" -eq 0 ]
    [ "$output" = "regular file" ]
}

@test "File: vars/default.sh should exist" {
    run stat -c "%F" vars/default.sh
    [ "$status" -eq 0 ]
    [ "$output" = "regular file" ]
}

@test "File: vars/base64.sh should exist" {
    run stat -c "%F" vars/base64.sh
    [ "$status" -eq 0 ]
    [ "$output" = "regular file" ]
}

@test "Gitignore: contain vars/config.sh" {
    run /bin/bash -c "grep vars/config.sh .gitignore"
    [ "$status" -eq 0 ]
}

@test "Gitignore: contain config/secrets" {
    run grep config/secrets .gitignore
    [ "$status" -eq 0 ]
    [ "$output" = "config/secrets" ]
}

@test "Daemonset configuration exist" {
    run stat -c "%F" config/daemonsets/dd-agent.yaml 
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}

@test "Daemonset configuration exist" {
    run stat -c "%F" config/daemonsets/fluentd.yaml 
    [ "$status" -eq 0 ] 
    [ "$output" = "regular file" ]
}
