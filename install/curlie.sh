#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  local CURLIE_VERSION=1.2.0
  if [[ ! -f "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/curlie"
    local OS=$(uname -s)

    local CURLIE_ARCHIVE="curlie_${CURLIE_VERSION}_${OS,,}_amd64.tar.gz"
    curl -O "https://github.com/rs/curlie/releases/download/v${CURLIE_VERSION}/${CURLIE_ARCHIVE}"

    tar -C "/tmp" -xzf "${CURLIE_ARCHIVE}"
    rm "${CURLIE_ARCHIVE}"
    mv "/tmp/curlie" "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}"

    # Activate version
    rm "${HOME}/opt/bin/curlie" || true
    ln -Fs "${HOME}/opt/curlie/curlie_${CURLIE_VERSION}" "${HOME}/opt/bin/curlie"
  fi
}

main