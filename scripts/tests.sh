#!/bin/bash

## Ensure list of files exist and non empty
# shellcheck disable=SC1091
source  tests/vars/files
: "${FILES:?}"
for file in $FILES; do 
    export CHECK_FILE
    CHECK_FILE="$file"
    bats -p tests/lib/file.bats
done;

# Ensure directories exist
# shellcheck disable=SC1091
source  tests/vars/directories
: "${DIRECTORIES:?}"
for DIRECTORY in ${DIRECTORIES:?}; do 
    export DIRECTORY
    bats -p tests/lib/directory.bats
done;
## Ensuire all environment have same configurations
while read -r env; do 
    export TEST_ENV 
    TEST_ENV="$(basename "$env")" 
    # shellcheck disable=SC1091
    source  tests/vars/files
    : "${CONFIGURATION_FILES:?}"
    for file in $CONFIGURATION_FILES; do 
        export CHECK_FILE
        CHECK_FILE="$file"
        bats -p tests/lib/file.bats
    done;
done < <(find resources/configurations/ -mindepth 1 -maxdepth 1 -type d)


# Ensure environment files 
#shellcheck disable=SC1091
source  tests/vars/files
export FILES
export DIRECTORIES
bats -p tests/lib/scripts.bats
