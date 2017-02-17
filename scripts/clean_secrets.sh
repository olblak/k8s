#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

find "$SECRETS_PATH" -name '*.yaml' -delete
find "$SECRETS_PATH" -name '*.yaml.generated' -delete
