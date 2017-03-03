#!/usr/bin/env bats
#

# Check that we have one secret generator per secret template
@test "$TEST_ENV: Expect scripts/secrets_generate/template/*.yaml == scripts/secrets_generator/*.sh " {
    TEMPLATES_NBR="$(find scripts/secrets_generator/templates -mindepth 1 -maxdepth 1 -name '*.yaml' | wc -l)"
    GENERATOR_NBR="$(find scripts/secrets_generator/ -mindepth 1 -maxdepth 1 -name '*.sh' | wc -l)"
    if [[ "$TEMPLATES_NBR" != "$GENERATOR_NBR" ]];then 
        echo "In scripts/secrets_generate"
        echo "Be sure to have one secret generator script per secret template"
    fi 
    run test "$TEMPLATES_NBR" = "$GENERATOR_NBR"
    [ "$status" -eq 0 ]
}

# Check that the current list of files correspond to what we defined in tests/vars/files
# The goal of this check is to discover if we add files whithout testing them
@test "Ensure list of files to test is correct" {
    CURRENT_NBR_FILES=$(\
        find . -type f ! -path './.git/*' ! -name '*.swp' ! -name '.gitignore' ! -path './.kube/*' ! -path './.bin/*' ! -name 'k8s.cfg' ! -path './resources/configurations/*' | sort |wc -w)
    IFS=' ' read -a NBR_FILES <<< "$FILES"
    read -a NBR_FILES <<< "$FILES"
    echo "$CURRENT_NBR_FILES vs ${#NBR_FILES[*]}"
    if [[ "$CURRENT_NBR_FILES" != "${#NBR_FILES[*]}" ]]; then
        echo "Current files do not match files defined in FILES variable from tests/vars/files"
        echo "$CURRENT_NBR_FILES vs ${#NBR_FILES[*]}"
    fi
    run test "$CURRENT_NBR_FILES" = "${#NBR_FILES[*]}"
    [ "$status" -eq 0 ]
}

# Check that the current list of directories correspond to what we defined in tests/vars/directories
# The goal of this check is to discover if we add directories whithout testing them
@test "Ensure list of directories to test is correct" {
    NEW_DIRECTORIES=$(\
        find . -type d ! -path './.git*' ! -path './.bin' ! -path './.kube*'\
        ! -name '.' ! -path './resources/configurations/*' -printf '%p ' | sort
        )
    IFS=' ' read -a NEW_NBR_DIRECTORIES <<< "$NEW_DIRECTORIES"
    IFS=' ' read -a NBR_DIRECTORIES <<< "$DIRECTORIES"
    if [[ "${#NEW_NBR_DIRECTORIES[*]}" != "${#NBR_DIRECTORIES[*]}" ]]; then
        echo "${#NEW_NBR_DIRECTORIES[*]}" != "${#NBR_DIRECTORIES[*]}"
        echo "Current directories do not match those defined in DIRECTORIES variable from tests/vars/directories"
    fi
    run test "${#NEW_NBR_DIRECTORIES[*]}" = "${#NBR_DIRECTORIES[*]}"
    [ "$status" -eq 0 ]
}
