#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/tfenv*"
}

install() {
  local TFENV_VERSION=2.2.2
  if [[ ! -d "${HOME}/opt/tfenv/tfenv-${TFENV_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/tfenv"

    mkdir "${HOME}/opt/tmp/tfenv_${TFENV_VERSION}"
    download "https://github.com/tfutils/tfenv/archive/refs/tags/v${TFENV_VERSION}.zip" "${HOME}/opt/tmp/tfenv_${TFENV_VERSION}/tfenv_${TFENV_VERSION}.zip"

    pushd "${HOME}/opt/tmp/tfenv_${TFENV_VERSION}"
    unzip "tfenv_${TFENV_VERSION}.zip"
    mv "tfenv-${TFENV_VERSION}" "${HOME}/opt/tfenv/"
    popd
    rm -Rf "${HOME}/opt/tmp/tfenv_${TFENV_VERSION}"

    if [[ -f "${HOME}/opt/bin/tfenv" ]]; then
      rm -f "${HOME}/opt/bin/tfenv"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tfenv/tfenv-${TFENV_VERSION}/bin/tfenv" "${HOME}/opt/bin/tfenv"

    if [[ -f "${HOME}/opt/bin/terraform" ]]; then
      rm -f "${HOME}/opt/bin/terraform"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tfenv/tfenv-${TFENV_VERSION}/bin/terraform" "${HOME}/opt/bin/terraform"
  fi
}
