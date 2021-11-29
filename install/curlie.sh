#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

CURLIE_BIN="${HOME}/opt/bin/curlie"

clean() {
  rm -rf "${HOME}/opt/bin/curlie"
  rm -rf "${HOME}/opt/curlie"
}

install() {
  local CURLIE_VERSION=1.6.7
  if [[ ! -f "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/curlie"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    local CURLIE_ARCHIVE="curlie_${CURLIE_VERSION}_${OS}_amd64.tar.gz"
    download "https://github.com/rs/curlie/releases/download/v${CURLIE_VERSION}/${CURLIE_ARCHIVE}" "${CURLIE_ARCHIVE}"

    tar -C "/tmp" -xzf "${CURLIE_ARCHIVE}"
    rm "${CURLIE_ARCHIVE}"
    mv "/tmp/curlie" "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}"

    # Activate version
    [ -f "${CURLIE_BIN}" ] && rm -f "${CURLIE_BIN}"
    ln -Fs "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" "${CURLIE_BIN}"
  fi
}
