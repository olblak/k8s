#!/bin/bash

set +e

# shellcheck disable=SC1091
source ./scripts/helpers.sh

find ./config/env/$ENV/secrets -name '*.yaml' -delete
find ./config/env/$ENV/secrets -name '*.yaml.generated' -delete
