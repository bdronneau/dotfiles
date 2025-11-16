#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

APP_NAME="fzf"
APP_BIN_NAME="${APP_NAME}"
APP_BASE_PATH="${HOME}/opt/${APP_NAME}"
APP_BIN_PATH="${HOME}/opt/bin/${APP_BIN_NAME}"

clean() {
  rm -rf "${APP_BIN_PATH}"
  rm -rf "${APP_BASE_PATH}"
}

install() {
  # renovate: datasource=github-tags depName=junegunn/fzf
  local APP_VERSION_TAG="v0.67.0"
  local APP_VERSION="${APP_VERSION_TAG/v/}"
  local APP_BIN_VERSION_PATH="${APP_BASE_PATH}/${APP_BIN_NAME}_${APP_VERSION}"

  if [[ ! -f "${APP_BIN_VERSION_PATH}" ]]; then
    mkdir -p "${APP_BASE_PATH}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    url_tar "https://github.com/junegunn/fzf/releases/download/${APP_VERSION_TAG}/fzf-${APP_VERSION}-$(get_os)_$(get_arch amd64).tar.gz"  "${APP_BIN_NAME}" "${APP_BIN_VERSION_PATH}"
    chmod u+x "${APP_BIN_VERSION_PATH}"

    [[ -f "${APP_BIN_PATH}" ]] && rm -f "${APP_BIN_PATH}"

    # Activate version
    ln -Fs "${APP_BIN_VERSION_PATH}" "${APP_BIN_PATH}"

    download "https://raw.githubusercontent.com/junegunn/fzf/${APP_VERSION_TAG}/shell/completion.bash" "${HOME}/opt/bash-completion.d/fzf.completion.bash"
    download "https://raw.githubusercontent.com/junegunn/fzf/${APP_VERSION_TAG}/shell/key-bindings.bash" "${HOME}/opt/bash-completion.d/fzf.key-bindings.bash"
  fi
}
