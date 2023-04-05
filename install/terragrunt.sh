#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/terragrunt*"
}

install() {
  # renovate: datasource=github-tags depName=gruntwork-io/terragrunt
  local TERRAGRUNT_VERSION="v0.45.2"
  if [[ ! -f "${HOME}/opt/terragrunt/terragrunt_${TERRAGRUNT_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/terragrunt"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    download "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}//terragrunt_${OS}_amd64" "${HOME}/opt/terragrunt/terragrunt_${TERRAGRUNT_VERSION}"

    chmod u+x "${HOME}/opt/terragrunt/terragrunt_${TERRAGRUNT_VERSION}"

    if [[ -f "${HOME}/opt/bin/terragrunt" ]]; then
      rm -f "${HOME}/opt/bin/terragrunt"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/terragrunt/terragrunt_${TERRAGRUNT_VERSION}" "${HOME}/opt/bin/terragrunt"
  fi
}
