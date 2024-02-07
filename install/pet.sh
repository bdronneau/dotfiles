#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

PET_BIN_NAME="pet"
PET_BIN_PATH="${HOME}/opt/bin/${PET_BIN_NAME}"

clean() {
  rm -rf "${HOME}/opt/${PET_BIN_NAME}"
  # rm -rf "${HOME}/opt/bash-completion.d/${PET_BIN_NAME}"
}

install() {
  # renovate: datasource=github-tags depName=knqyf263/pet
  local PET_VERSION_TAG="v0.6.0"
  local PET_VERSION="${PET_VERSION_TAG/v/}"
  local PET_BIN_VERSION_PATH="${HOME}/opt/pet/pet_${PET_VERSION}"

  if [[ ! -f "${HOME}/opt/pet/pet_${PET_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/${PET_BIN_NAME}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    url_tar "https://github.com/knqyf263/pet/releases/download/${PET_VERSION_TAG}/pet_${PET_VERSION}_${OS}_${ARCH}.tar.gz" "${PET_BIN_NAME}" "${PET_BIN_VERSION_PATH}"
    chmod u+x "${PET_BIN_VERSION_PATH}"

    [[ -f "${PET_BIN_PATH}" ]] && rm -f "${PET_BIN_PATH}"

    # Activate version
    ln -Fs "${PET_BIN_VERSION_PATH}" "${PET_BIN_PATH}"
  fi
}
