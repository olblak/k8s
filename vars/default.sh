#!/bin/sh
# All variables define in this script must respect following format
# Which ensure that variable will only be if the value = null or doesn't exist
#: "${VARIABLE}:=value"

: "${ENV:=dev}"
: "${SECRETS_PATH:=./env/$ENV/secrets}"
: "${LOCATION:=eastus}"
: "${PREFIX:=jenkinsinfra}"
