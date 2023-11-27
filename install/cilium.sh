#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

CILIUM_CLI_BIN_NAME="cilium"
CILIUM_CLI_BIN_PATH="${HOME}/opt/bin/${CILIUM_CLI_BIN_NAME}"

clean() {
  rm -rf "${HOME}/opt/bash-completion.d/cilium"
  rm -rf "${CILIUM_CLI_BIN_PATH}"
  rm -rf "${HOME}/opt/cilium"
}

install() {
  # renovate: datasource=github-tags depName=cilium/cilium-cli
  local CILIUM_CLI_VERSION="v0.15.14"
  local CILIUM_CLI_BIN_VERSION_PATH="${HOME}/opt/cilium/cilium_${CILIUM_CLI_VERSION}"
  local CILIUM_CLI_BIN_NAME="cilium"

  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  local ARCH
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

  if [[ ! -f "${CILIUM_CLI_BIN_VERSION_PATH}" ]]; then
    mkdir -p "${HOME}/opt/${CILIUM_CLI_BIN_NAME}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    url_tar "https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-${OS}-${ARCH}.tar.gz" "${CILIUM_CLI_BIN_NAME}" "${CILIUM_CLI_BIN_VERSION_PATH}"
    chmod u+x "${CILIUM_CLI_BIN_VERSION_PATH}"

    [[ -f "${CILIUM_CLI_BIN_PATH}" ]] && rm -f "${CILIUM_CLI_BIN_PATH}"

    # Activate version
    ln -Fs "${CILIUM_CLI_BIN_VERSION_PATH}" "${CILIUM_CLI_BIN_PATH}"

    # Generate bash completion
    "${CILIUM_CLI_BIN_PATH}" completion bash > "${HOME}/opt/bash-completion.d/${CILIUM_CLI_BIN_NAME}"
  fi
}
