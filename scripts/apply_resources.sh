#!/bin/bash

# shellcheck disable=SC1091
source ./scripts/helpers.sh


# Delete pods with the same app value provided by arguments
function delete_pod {
    for POD in $(kubectl get pods -l "$1" -o name); do
        kubectl delete "$POD"
    done
    echo "New $POD pods will be recreated soon by daemonset"
}

# Apply two times daemonset configurations.
# we use daemonset generation value to check if some modification was applied between two runs
# If so, we delete associated pod.
# Daemonsets will then recreate them with correct configurations
function apply_daemonset {
    DAEMON_SET=$1
    NAME=$(kubectl describe -f "$DAEMON_SET" | grep 'Name:' | awk '{print $2}' 2>/dev/null)
    NAMESPACE=$(kubectl describe -f "$DAEMON_SET" | grep 'Namespace:' | awk '{print $2}' 2>/dev/null)
    GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation}")
    kubectl apply -f "$DAEMON_SET"
    NEW_GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation}")
    if [[ "$GENERATION" != "$NEW_GENERATION" ]];then
        echo "$DAEMON_SET changed: $NAME  pods need to be recreated"
        delete_pod "app=$NAME"
    fi
}

# Default behaviour to apply a kubernetes resource
function apply_resource {
   kubectl apply -f "$1" 
}

function check_resources_directory {
    if [ ! -d "$RESOURCES_PATH" ]; then 
        echo "No $ENV configurations found"; 
        exit 0
    fi
}


# Check if secret or configmap changed, if so restart all pods with label app=$NAME
function apply_config {
    CONFIG=$1
    NAME=$(kubectl describe -f "$CONFIG" | grep 'Name:' | awk '{print $2}' 2>/dev/null)
    NAMESPACE=$(kubectl describe -f "$CONFIG" | grep 'Namespace:' | awk '{print $2}' 2>/dev/null)
    FILE=$(basename "$CONFIG")
    KIND=${FILE/.yaml/}
    GENERATION=$(kubectl get "$KIND" "$NAME" --namespace "$NAMESPACE" -o jsonpath="{.metadata.resourceVersion}" 2>/dev/null)
    kubectl apply -f "$CONFIG"
    NEW_GENERATION=$(kubectl get "$KIND" "$NAME" --namespace "$NAMESPACE" -o jsonpath="{.metadata.resourceVersion}")
    if [[ "$GENERATION" != "$NEW_GENERATION" ]];then
        echo "$NAME changed: $NAME  pods need to be restarted"
        delete_pod "$KIND-$NAME=linked"
    fi
}

# Browse DEFINITIONS_PATH for kubernetes configurations files 
# Based on resource kind, we may have to apply different workflows
function run {
    while read -r file; do
        case "$(basename "$file")" in 
            "daemonset.yaml") 
                apply_daemonset "$file"
                ;; 
            "secret.yaml"|"configmap.yaml") 
                apply_config "$file"
                ;; 
            *) 
                apply_resource "$file"
                ;; 
        esac

    done < <(find "$RESOURCES_PATH" -mindepth 1  -maxdepth 2 -name '*.yaml' -type f | sort)
}

if [ $# -eq 0 ]; then
    echo "Missing arguments"
fi

while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        "--all"|"-a")
            RESOURCES_PATH="$SYSTEMS_PATH"
            check_resources_directory
            run
            RESOURCES_PATH="$CONFIGURATIONS_PATH"
            check_resources_directory
            run
            RESOURCES_PATH="$DEFINITIONS_PATH"
            check_resources_directory
            run
            get_public_ip
            exit 0
        ;;
        "--configurations"|"-c")
            RESOURCES_PATH="$CONFIGURATIONS_PATH"
            check_resources_directory
            run
            exit 0
        ;;
        "--definitions"|"-d")
            RESOURCES_PATH="$DEFINITIONS_PATH"
            check_resources_directory
            run
            get_public_ip
            exit 0
        ;;
        "--systems"|"-s")
            RESOURCES_PATH="$SYSTEMS_PATH"
            check_resources_directory
            run
            exit 0
        ;;
        *)
            echo "Wrong argument"
            exit 1
        ;;
    esac
done
