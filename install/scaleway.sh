#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

SCW_BIN="${HOME}/opt/bin/scw"

clean() {
  rm -rf "${HOME}/opt/bin/scaleway"
  rm -rf "${HOME}/opt/scaleway"
}

install() {
  # renovate: datasource=github-releases depName=scaleway/scaleway-cli
  local SCW_VERSION_TAG="v2.20.0"
  local SCW_VERSION="${SCW_VERSION_TAG/v/}"
  if [[ ! -f "${HOME}/opt/scaleway/scaleway_${SCW_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/scaleway"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    local SCW_ARCHIVE="/scaleway-cli_${SCW_VERSION}_${OS}_${ARCH}"
    download "https://github.com/scaleway/scaleway-cli/releases/download/${SCW_VERSION_TAG}/${SCW_ARCHIVE}" "${HOME}/opt/scaleway/scaleway_${SCW_VERSION}"

    # Activate version
    [ -f "${SCW_BIN}" ] && rm -f "${SCW_BIN}"
    ln -Fs "${HOME}/opt/scaleway/scaleway_${SCW_VERSION}" "${SCW_BIN}"

    chmod u+x "${SCW_BIN}"

    # Generate bash completion
    scw autocomplete script shell=bash > "${HOME}/opt/bash-completion.d/scaleway"
  fi
}
