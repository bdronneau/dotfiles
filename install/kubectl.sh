#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

KUBECTL_BIN="${HOME}/opt/bin/kubectl"

clean() {
  rm -rf "${HOME}/opt/bash-completion.d/kubectl"
  rm -rf "${KUBECTL_BIN}"
  rm -rf "${HOME}/opt/kubectl"
  rm -rf "${HOME}/.kube"
}

install() {
  local KUBECTL_VERSION
  KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

  if [[ ! -f "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    mkdir -p "${HOME}/opt/bash-completion.d"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -q -sSL --max-time 300 -o "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/amd64/kubectl"
    chmod u+x "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}"

    [[ -f "${KUBECTL_BIN}" ]] && rm -f "${KUBECTL_BIN}"

    # Activate version
    ln -Fs "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" "${KUBECTL_BIN}"

    # Generate bash completion
    "${KUBECTL_BIN}" completion bash > "${HOME}/opt/bash-completion.d/kubectl"
  fi
}
