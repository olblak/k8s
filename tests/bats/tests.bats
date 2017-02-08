#!/usr/bin/env bats

@test "All base64 encoded variables must be tested" {
    nbr_base64=$(grep '=$(' vars/base64.sh | wc -l)
    nbr_tests=$(grep '@test' tests/bats/base64.bats | wc -l)
    result=$(( nbr_tests - nbr_base64 - 1 ))
    echo $nbr_base64
    echo $nbr_tests
    echo $result
    [ $result -eq 0 ]
}
