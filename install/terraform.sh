#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/opt/terraform*"
}

install() {
  local TERRAFORM_VERSION=0.13.4
  if [[ ! -f "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/terraform"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -q -sSL --max-time 300 -O "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${OS}_amd64.zip"
    unzip "terraform_${TERRAFORM_VERSION}_${OS}_amd64.zip"
    rm "terraform_${TERRAFORM_VERSION}_${OS}_amd64.zip"
    mv "terraform" "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}"

    if [[ -f "${HOME}/opt/bin/terraform" ]]; then
      rm -f "${HOME}/opt/bin/terraform"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/terraform/terraform_${TERRAFORM_VERSION}" "${HOME}/opt/bin/terraform"
  fi
}
