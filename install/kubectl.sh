#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
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

main
