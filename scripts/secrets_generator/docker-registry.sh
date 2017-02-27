#!/bin/bash
 
set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

GENERATOR_PATH="$(dirname "$0")"

# Exit error if missing docker credentials
: "${DOCKER_REGISTRY_SERVER:?}"
: "${DOCKER_USER:?}"
: "${DOCKER_PASSWORD:?}"
: "${DOCKER_EMAIL:?}"

# Encode user:password
DOCKER_AUTH=$(echo -n "$DOCKER_USER:$DOCKER_PASSWORD"| base64 -w 0)

DOCKERCONFIGJSON="{\"auths\":{\"$DOCKER_REGISTRY_SERVER\":{\"auth\": \"$DOCKER_AUTH\",\"email\": \"$DOCKER_EMAIL\"}}}"

# Encode dockerconfigjson
DOCKERCONFIGJSON=$(echo -n "$DOCKERCONFIGJSON"| base64 -w 0)

SECRET_FILE=$(init_secret_file 'docker-registry')
# Create docker registry secret file
sed "s/DOCKERCONFIGJSON/${DOCKERCONFIGJSON}/g" "${GENERATOR_PATH}/templates/docker-registry.yaml" >> "$SECRET_FILE"
