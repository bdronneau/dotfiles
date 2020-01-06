#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/opt/bash-completion.d/kubectl"
  rm -rf "${HOME}/opt/bin/kubectl"
  rm -rf "${HOME}/opt/kubectl"
}

install() {
  local KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  if [[ ! -f "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    local OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -o "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/amd64/kubectl"
    chmod u+x "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}"

    if [[ -f "${HOME}/opt/bin/terraform" ]]; then
      rm -f "${HOME}/opt/bin/kubectl"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" "${HOME}/opt/bin/kubectl"

    # Generate bash completion
    "${HOME}/opt/bin/kubectl" completion bash > "${HOME}/opt/bash-completion.d/kubectl"
  fi
}
