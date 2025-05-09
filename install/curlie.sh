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
  # renovate: datasource=github-tags depName=rs/curlie
  local CURLIE_VERSION="v1.8.2"
  if [[ ! -f "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/curlie"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    if [[ ${ARCH} = "x86_64" ]]; then
      ARCH="amd64"
    fi

    local CURLIE_ARCHIVE="curlie_${CURLIE_VERSION/v/}_${OS}_${ARCH}.tar.gz"
    download "https://github.com/rs/curlie/releases/download/${CURLIE_VERSION}/${CURLIE_ARCHIVE}" "${CURLIE_ARCHIVE}"

    tar -C "/tmp" -xzf "${CURLIE_ARCHIVE}"
    rm "${CURLIE_ARCHIVE}"
    mv "/tmp/curlie" "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}"

    # Activate version
    [ -f "${CURLIE_BIN}" ] && rm -f "${CURLIE_BIN}"
    ln -Fs "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" "${CURLIE_BIN}"
  fi
}
