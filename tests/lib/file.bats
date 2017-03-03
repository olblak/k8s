#!/usr/bin/env bats
#
@test "File: $CHECK_FILE should exist and not be empty" {
    run stat -c "%F" "$CHECK_FILE"
    [ "$status" -eq 0 ]
    [ "$output" = "regular file" ]
}


