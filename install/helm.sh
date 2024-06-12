#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/helm*"
}

install() {
  # renovate: datasource=github-tags depName=helm/helm
  local HELM_VERSION="v3.15.2"
  # renovate: datasource=github-tags depName=hayorov/helm-gcs
  local HELM_PLUGIN_GCS_VERSION="0.4.3"

  if [[ ! -f "${HOME}/opt/helm/helm_${HELM_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/helm"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    download "https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz" "helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz"

    # Temp directory for extraction
    if [[ ! -d "helm-${HELM_VERSION}" ]]; then
      mkdir "helm-${HELM_VERSION}"
    fi

    tar -C "helm-${HELM_VERSION}" -xf "helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz"
    rm "helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz"
    mv "helm-${HELM_VERSION}/${OS}-${ARCH}/helm" "${HOME}/opt/helm/helm_${HELM_VERSION}"
    rm -Rf "helm-${HELM_VERSION}"

    if [[ -f "${HOME}/opt/bin/helm" ]]; then
      rm -f "${HOME}/opt/bin/helm"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/helm/helm_${HELM_VERSION}" "${HOME}/opt/bin/helm"

    # Generate bash completion
    "${HOME}/opt/bin/helm" completion bash > "${HOME}/opt/bash-completion.d/helm"

    # Helm plugins
    helm plugin uninstall gcs || true
    helm plugin install https://github.com/hayorov/helm-gcs --version ${HELM_PLUGIN_GCS_VERSION}
  fi
}
