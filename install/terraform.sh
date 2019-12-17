#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  local TERRAFORM_VERSION=0.12.18
  if [[ ! -f "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/terraform"
    local OS=$(uname -s)

    curl -O "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS,,}_amd64.zip"
    unzip "terraform_${TERRAFORM_VERSION}_${OS,,}_amd64.zip"
    rm "terraform_${TERRAFORM_VERSION}_${OS,,}_amd64.zip"
    mv "terraform" "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}"

    if [[ -f "${HOME}/opt/bin/terraform" ]]; then
      rm -f "${HOME}/opt/bin/terraform"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}" "${HOME}/opt/bin/terraform"
  fi
}

main
