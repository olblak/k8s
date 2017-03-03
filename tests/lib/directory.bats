#!/usr/bin/env bats
#
@test "Directory: $DIRECTORY should exist" {
    run stat -c "%F" "$DIRECTORY"
    [ "$status" -eq 0 ]
    [ "$output" = "directory" ]
}
