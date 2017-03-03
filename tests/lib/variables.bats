#!/usr/bin/env bats
#
#
source ./scripts/helpers.sh

# Azure Variables
@test "Variable: PREFIX  must be defined" {
    run bash -c ": ${PREFIX:?}"
    [ $status -eq '0' ]
}
@test "Variable: LOCATION  must be defined" {
    run bash -c ": ${LOCATION:?}"
    [ $status -eq '0' ]
}
@test "Variable: ENV  must be defined" {
    run bash -c ": ${ENV:?}"
    [ $status -eq '0' ]
}
