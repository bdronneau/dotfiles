#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

TALOSCTL_BIN="${HOME}/opt/bin/talosctl"

clean() {
  rm -rf "${HOME}/opt/bash-completion.d/talosctl"
  rm -rf "${TALOSCTL_BIN}"
  rm -rf "${HOME}/opt/talosctl"
}

install() {
  # renovate: datasource=github-tags depName=siderolabs/talos
  local TALOSCTL_VERSION="v1.10.5" 

  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  local ARCH
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

  if [[ ! -f "${HOME}/opt/talos/talosctl_${TALOSCTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/talos"
    mkdir -p "${HOME}/opt/bash-completion.d"


    download "https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-${OS}-${ARCH}" "${HOME}/opt/talos/talosctl_${TALOSCTL_VERSION}"
    chmod u+x "${HOME}/opt/talos/talosctl_${TALOSCTL_VERSION}"

    [[ -f "${TALOSCTL_BIN}" ]] && rm -f "${TALOSCTL_BIN}"

    # Activate version
    ln -Fs "${HOME}/opt/talos/talosctl_${TALOSCTL_VERSION}" "${TALOSCTL_BIN}"

    # Generate bash completion
    "${TALOSCTL_BIN}" completion bash > "${HOME}/opt/bash-completion.d/talosctl"
  fi
}
