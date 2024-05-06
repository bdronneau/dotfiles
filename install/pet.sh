#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

APP_NAME="pet"
APP_BIN_NAME="${APP_NAME}"
APP_BIN_PATH="${HOME}/opt/bin/${APP_BIN_NAME}"

clean() {
  rm -rf "${HOME}/opt/${APP_BIN_NAME}"
}

install() {
  # renovate: datasource=github-tags depName=knqyf263/pet
  local APP_VERSION_TAG="v0.8.1"
  local APP_VERSION="${APP_VERSION_TAG/v/}"
  local APP_BIN_VERSION_PATH="${HOME}/opt/${APP_NAME}/APP_${APP_VERSION}"

  if [[ ! -f "${HOME}/opt/${APP_NAME}/${APP_NAME}_${APP_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/${APP_NAME}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    url_tar "https://github.com/knqyf263/pet/releases/download/${APP_VERSION_TAG}/${APP_NAME}_${APP_VERSION}_${OS}_${ARCH}.tar.gz" "${APP_BIN_NAME}" "${APP_BIN_VERSION_PATH}"
    chmod u+x "${APP_BIN_VERSION_PATH}"

    [[ -f "${APP_BIN_PATH}" ]] && rm -f "${APP_BIN_PATH}"

    # Activate version
    ln -Fs "${APP_BIN_VERSION_PATH}" "${APP_BIN_PATH}"
  fi
}
