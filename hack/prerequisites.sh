#!/bin/bash

set -euo pipefail

function binExist() {
    bin="${1}"

    if ! which ${bin} >/dev/null 2>&1; then
        echo "error: Binary ${bin} is not found."
        exit 1
    fi
}

function binMatchesVersion() {
    binVersionCmd="${1}"
    got="$(eval ${binVersionCmd})"
    expected="${2}"

    if ! [[ ${got} =~ ${expected} ]]; then
        echo "error: ${binVersionCmd} has version ${got}, expected ${expected}."
        exit 1
    fi
}

# Packer v1.8.X
binExist packer
binMatchesVersion "packer version" "v1.8."

# Terraform v1.1.X
binExist terraform
binMatchesVersion "terraform version" "1.1."
