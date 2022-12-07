#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

TFSWITCH_BIN="${HOME}/opt/bin/tfswitch"

clean() {
  rm -rf "${TFSWITCH_BIN}"
  rm -rf "${HOME}/opt/tfswitch"
}

install() {
  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  # renovate: datasource=github-tags depName=warrensbox/terraform-switcher
  local TFSWITCH_VERSION="0.13.1300"
  if [[ ! -f "${HOME}/opt/tfswitch/tfswitch_${TFSWITCH_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/tfswitch"

    url_tar "https://github.com/warrensbox/terraform-switcher/releases/download/${TFSWITCH_VERSION}/terraform-switcher_${TFSWITCH_VERSION}_${OS}_amd64.tar.gz" "tfswitch" "${HOME}/opt/tfswitch/tfswitch_${TFSWITCH_VERSION}"

    if [[ -f "${TFSWITCH_BIN}" ]]; then
      rm -f "${TFSWITCH_BIN}"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/tfswitch/tfswitch_${TFSWITCH_VERSION}" "${TFSWITCH_BIN}"
  fi
}
