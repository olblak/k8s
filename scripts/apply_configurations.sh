#!/bin/bash

# shellcheck disable=SC1091
source ./scripts/helpers.sh

# Delete pods with the same app value than daemonsets that was recently updated
function restart_pod {
    for POD in $(kubectl get pods -l app="$1" -o name); do
        kubectl delete "$POD"
    done
}

function apply_resource {
   kubectl apply -f "$1" 
}

# Browse DEFINITIONS_PATH for kubernetes configurations files 
# Based on resource kind, we may have to apply different workflows
function run {
    echo "Apply $ENV configurations"
    if [ ! -d "$CONFIGURATION_PATH" ]; then 
        echo "No $ENV configurations found"; 
        exit 0
    fi
    TORESTART=false
    while read -r file; do
        NAME="$(dirname "$file")"
        apply_resource "$file" 
        NEW_NAME="$(dirname "$file")"
        if [[ "$NAME" != "$NEW_NAME" && $TORESTART ]]; then
            TORESTART=false
            restart_pod "$NAME"
        fi

    done < <(find "$CONFIGURATIONS_PATH" -mindepth 1  -maxdepth 2 -name '*.yaml' -type f | sort)
}

run
