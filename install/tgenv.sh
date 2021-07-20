#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/tgenv*"
}

install() {
  local TGENV_VERSION=0.0.3
  if [[ ! -d "${HOME}/opt/tgenv/tgenv-${TGENV_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/tgenv"

    mkdir "${HOME}/opt/tmp/tgenv_${TGENV_VERSION}"
    download "https://github.com/cunymatthieu/tgenv/archive/refs/tags/v${TGENV_VERSION}.zip" "${HOME}/opt/tmp/tgenv_${TGENV_VERSION}/tgenv_${TGENV_VERSION}.zip"

    pushd "${HOME}/opt/tmp/tgenv_${TGENV_VERSION}"
    unzip "tgenv_${TGENV_VERSION}.zip"
    mv "tgenv-${TGENV_VERSION}" "${HOME}/opt/tgenv/"
    popd
    rm -Rf "${HOME}/opt/tmp/tgenv_${TGENV_VERSION}"

    if [[ -f "${HOME}/opt/bin/tgenv" ]]; then
      rm -f "${HOME}/opt/bin/tgenv"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tgenv/tgenv-${TGENV_VERSION}/bin/tgenv" "${HOME}/opt/bin/tgenv"

    if [[ -L "${HOME}/opt/bin/terragrunt" ]]; then
      rm -f "${HOME}/opt/bin/terragrunt"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tgenv/tgenv-${TGENV_VERSION}/bin/terragrunt" "${HOME}/opt/bin/terragrunt"
  fi
}
