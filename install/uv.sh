#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

APP_NAME="uv"
APP_BIN_NAME="${APP_NAME}"
APP_BASE_PATH="${HOME}/opt/${APP_NAME}"
APP_BIN_PATH="${HOME}/opt/bin/${APP_BIN_NAME}"

clean() {
  rm -rf "${APP_BIN_PATH}"
  rm -rf "${APP_BASE_PATH}"
}

install() {
  # renovate: datasource=github-tags depName=astral-sh/uv
  local APP_VERSION_TAG="0.9.2"
  local APP_VERSION="${APP_VERSION_TAG/v/}"
  local APP_BIN_VERSION_PATH="${APP_BASE_PATH}/${APP_BIN_NAME}_${APP_VERSION}"

  if [[ ! -f "${APP_BIN_VERSION_PATH}" ]]; then
    mkdir -p "${APP_BASE_PATH}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    url_tar "https://github.com/astral-sh/uv/releases/download/${APP_VERSION_TAG}/${APP_NAME}-$(get_arch amd64 aarch64)-$(get_os_name)-$(get_os).tar.gz" "${APP_BIN_NAME}-$(get_arch amd64 aarch64)-$(get_os_name)-$(get_os)/${APP_BIN_NAME}" "${APP_BIN_VERSION_PATH}"
    chmod u+x "${APP_BIN_VERSION_PATH}"

    [[ -f "${APP_BIN_PATH}" ]] && rm -f "${APP_BIN_PATH}"

    # Activate version
    ln -Fs "${APP_BIN_VERSION_PATH}" "${APP_BIN_PATH}"
  fi
}
