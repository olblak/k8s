#!/bin/bash

# shellcheck disable=SC1091
source ./scripts/helpers.sh


# Delete pods with the same app value than daemonsets that was recently updated
function delete_pod {
    for POD in $(kubectl get pods -l app="$1" -o name); do
        kubectl delete "$POD"
    done
}

# Apply two times daemonset configurations.
# we use daemonset generation value to check if some modification was applied between two runs
# If so, we delete associated pod.
# Daemonsets will then recreate them with correct configurations
function apply_daemonset {
    DAEMON_SET=$1
    NAME=$(kubectl describe -f "$DAEMON_SET" | grep 'Name:' | awk '{print $2}')
    GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation")
    kubectl apply -f "$DAEMON_SET"
    NEW_GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation")
    if [[ "$GENERATION" != "$NEW_GENERATION" ]];then
        delete_pod "$NAME"
    fi
}

function apply_resource {
   kubectl apply -f "$1" 
}

# Browse DEFINITIONS_PATH for kubernetes configurations files 
# Based on resource kind, we may have to apply different workflows
function run {
    while read -r file; do
        case "$(basename "$file")" in 
            "daemonset") apply_daemonset "$file";; 
            *) apply_resource "$file";; 
        esac

    done < <(find "$DEFINITIONS_PATH" -mindepth 1  -maxdepth 2 -name '*.yaml' -type f | sort)
}

run
