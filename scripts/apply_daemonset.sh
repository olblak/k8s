#!/bin/bash

DAEMONSETS_PATH="./config/daemonsets"

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
function apply {
    DAEMON_SET=$1
    BASENAME=$(basename "$DAEMON_SET")
    NAME=${BASENAME%.*}
    GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.spec.template.spec.containers[?(@.name==\"$NAME\")].image}")
    kubectl apply -f "$DAEMON_SET"
    NEW_GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.spec.template.spec.containers[?(@.name==\"$NAME\")].image}")
    if [[ "$GENERATION" != "$NEW_GENERATION" ]];then
        delete_pod "$NAME"
    fi
}

# Browse $DAEMONSETS_PATH for daemonset configuration
function run {
    while IFS= read -r -d '' daemonset 
    do
        apply "$daemonset"
    done < <(find $DAEMONSETS_PATH -name '*.yaml' -print0)
}

run
