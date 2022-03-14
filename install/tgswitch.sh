#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

TGSWITCH_BIN="${HOME}/opt/bin/tgswitch"

clean() {
  rm -rf "${TGSWITCH_BIN}"
  rm -rf "${HOME}/opt/tgswitch"
}

install() {
  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  # renovate: datasource=github-tags depName=warrensbox/tgswitch
  local TGSWITCH_VERSION="0.5.389"
  if [[ ! -f "${HOME}/opt/tgswitch/tgswitch_${TGSWITCH_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/tgswitch"

    url_tar "https://github.com/warrensbox/tgswitch/releases/download/${TGSWITCH_VERSION}/tgswitch_${TGSWITCH_VERSION}_${OS}_amd64.tar.gz" "tgswitch" "${HOME}/opt/tgswitch/tgswitch_${TGSWITCH_VERSION}"

    if [[ -f "${TGSWITCH_BIN}" ]]; then
      rm -f "${TGSWITCH_BIN}"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tgswitch/tgswitch_${TGSWITCH_VERSION}" "${TGSWITCH_BIN}"
  fi
}
