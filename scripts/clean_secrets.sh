#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

find "$CONFIGURATIONS_PATH" -name 'secrets.yaml' -delete
find "$CONFIGURATIONS_PATH" -name 'secret.yaml' -delete
find "$CONFIGURATIONS_PATH" -name '*.yaml.generated' -delete
