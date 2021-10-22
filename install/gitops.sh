#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

FLUX_BIN="${HOME}/opt/bin/flux"
FLUX_COMPLETION="${HOME}/opt/bash-completion.d/flux"

clean() {
  rm -rf "${FLUX_COMPLETION}"
  rm -rf "${FLUX_BIN}"
  rm -rf "${HOME}/opt/flux"
}

install() {
  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  local FLUX_VERSION="0.17.1"
  if [[ ! -f "${HOME}/opt/flux/flux_${FLUX_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/flux"
    url_tar "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_${OS}_amd64.tar.gz" "flux" "${HOME}/opt/flux/flux_${FLUX_VERSION}"

    if [[ -f "${FLUX_BIN}" ]]; then
      rm -f "${FLUX_BIN}"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/flux/flux_${FLUX_VERSION}" "${FLUX_BIN}"

    flux completion bash > "${FLUX_COMPLETION}"
  fi
}
