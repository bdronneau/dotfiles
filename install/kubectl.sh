#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  local KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  if [[ ! -f "${HOME}/opt/kubetcl/kubetcl_${KUBECTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubetcl"
    local OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -o "${HOME}/opt/kubetcl/kubetcl_${KUBECTL_VERSION}" "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/amd64/kubectl"
    chmod u+x "${HOME}/opt/kubetcl/kubetcl_${KUBECTL_VERSION}"
    
    # Activate version
    ln -Fs "${HOME}/opt/kubetcl/kubetcl_${KUBECTL_VERSION}" "${HOME}/opt/bin/kubetcl"

    # Generate bash completion
    "${HOME}/opt/bin/kubetcl" completion bash > "${HOME}/opt/bash-completion.d/kubetcl"
  fi
}

main
