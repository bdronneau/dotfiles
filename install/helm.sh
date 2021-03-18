#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/helm*"
}

install() {
  local HELM_VERSION=v3.5.3
  if [[ ! -f "${HOME}/opt/helm/helm_${HELM_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/helm"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    download "https://get.helm.sh/helm-${HELM_VERSION}-${OS}-amd64.tar.gz" "helm-${HELM_VERSION}-${OS}-amd64.tar.gz"

    # Temp directory for extraction
    if [[ ! -d "helm-${HELM_VERSION}" ]]; then
      mkdir "helm-${HELM_VERSION}"
    fi

    tar -C "helm-${HELM_VERSION}" -xf "helm-${HELM_VERSION}-${OS}-amd64.tar.gz"
    rm "helm-${HELM_VERSION}-${OS}-amd64.tar.gz"
    mv "helm-${HELM_VERSION}/${OS}-amd64/helm" "${HOME}/opt/helm/helm_${HELM_VERSION}"
    rm -Rf "helm-${HELM_VERSION}"

    if [[ -f "${HOME}/opt/bin/helm" ]]; then
      rm -f "${HOME}/opt/bin/helm"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/helm/helm_${HELM_VERSION}" "${HOME}/opt/bin/helm"

    # Generate bash completion
    "${HOME}/opt/bin/helm" completion bash > "${HOME}/opt/bash-completion.d/helm"
  fi
}
