#!/bin/bash

# shellcheck disable=SC1091
source ./scripts/helpers.sh


# Delete pods with the same app value than daemonsets that was recently updated
function delete_pod {
    for POD in $(kubectl get pods -l app="$1" -o name); do
        kubectl delete "$POD"
    done
    echo "New $POD pods will be recreated soon by daemonset"
}

# Delete pods with the same app value than daemonsets that was recently updated
function restart_pod {
    for POD in $(kubectl get pods -l app="$1" -o name); do
        kubectl restart "$POD"
    done
}

# Apply two times daemonset configurations.
# we use daemonset generation value to check if some modification was applied between two runs
# If so, we delete associated pod.
# Daemonsets will then recreate them with correct configurations
function apply_daemonset {
    DAEMON_SET=$1
    NAME=$(kubectl describe -f "$DAEMON_SET" | grep 'Name:' | awk '{print $2}')
    GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation}")
    kubectl apply -f "$DAEMON_SET"
    NEW_GENERATION=$(kubectl get daemonset "$NAME" -o jsonpath="{.metadata.generation}")
    if [[ "$GENERATION" != "$NEW_GENERATION" ]];then
        echo "$DAEMON_SET changed: $NAME  pods need to be reload"
        delete_pod "$NAME"
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

# Check if the environment that we deploy do not miss configurations files
# Show error if current environment have less configuration files than others
# Show warning if other environment have less configuration than current one

function check_configurations_files_nbr {
    echo "Verifying that $ENV have enough configurations files"
    ENV_NBR=$(find "$CONFIGURATIONS_PATH" -mindepth 1 -maxdepth 2 -type f -name '*.yaml'| wc -l)
    CONSISTENT=0
    while read -r environment; do 
        if [[ "$CONFIGURATIONS_PATH" != "${environment}/" ]]; then
            NAME=$(basename "$environment")
            NBR=$(find "$environment" -mindepth 1 -maxdepth 2 -type f -name '*.yaml' | wc -l)
            if [ "$ENV_NBR" -lt "$NBR" ]; then 
                CONSISTENT=1
                echo "ERROR: Compare to $NAME: $ENV is missing $(( NBR - ENV_NBR )) configurations ($ENV_NBR vs $NBR)"
                echo $((NBR-ENV_NBR))
            elif [ "$ENV_NBR" -gt "$NBR" ]; then
                echo "WARNING: Compare to $ENV: $NAME is missing $(( ENV_NBR - NBR )) configurations"
            fi
        fi
    done < <(find "$(dirname "$CONFIGURATIONS_PATH")" -mindepth 1 -maxdepth 1 -type d)

    if [[ $CONSISTENT -eq 1 ]]; then
        exit 1
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
        "--configurations"|"-c")
            RESOURCES_PATH="$CONFIGURATIONS_PATH"
            check_configurations_files_nbr
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
        "--all"|"-a")
            RESOURCES_PATH="$CONFIGURATIONS_PATH"
            check_configurations_files_nbr
            check_resources_directory
            run
            RESOURCES_PATH="$DEFINITIONS_PATH"
            check_resources_directory
            run
            get_public_ip
            exit 0
        ;;
        *)
            echo "Wrong argument"
            exit 1
        ;;
    esac
done
