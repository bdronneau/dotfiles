#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

GOPASS_BIN="${HOME}/opt/bin/gopass"

clean() {
  rm -rf "${HOME}/opt/bin/gopass"
  rm -rf "${HOME}/opt/gopass"
}

install() {
  # renovate: datasource=github-tags depName=gopasspw/gopass
  local GOPASS_VERSION="v1.14.3"
  if [[ ! -f "${HOME}/opt/gopass/gopass_${GOPASS_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/gopass"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    local GOPASS_ARCHIVE="gopass-${GOPASS_VERSION/v/}-${OS}-amd64.tar.gz"
    url_tar "https://github.com/gopasspw/gopass/releases/download/${GOPASS_VERSION}/${GOPASS_ARCHIVE}" "gopass" "${HOME}/opt/gopass/gopass_${GOPASS_VERSION}"

    # Activate version
    [ -f "${GOPASS_BIN}" ] && rm -f "${GOPASS_BIN}"
    ln -Fs "${HOME}/opt/gopass/gopass_${GOPASS_VERSION}" "${GOPASS_BIN}"

    # Generate bash completion
    "${GOPASS_BIN}" completion bash > "${HOME}/opt/bash-completion.d/gopass"
  fi
}
