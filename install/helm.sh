#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/helm"
  rm -f "${HOME}/opt/bin/helm"
}

install() {
  # renovate: datasource=github-tags depName=helm/helm
  local HELM_VERSION="v4.0.4"
  # renovate: datasource=github-tags depName=hayorov/helm-gcs
  local HELM_PLUGIN_GCS_VERSION="0.6.3"

  if [[ ! -f "${HOME}/opt/helm/helm_${HELM_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/helm"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    download "https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz" "helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz" "https://get.helm.sh/helm-${HELM_VERSION}-${OS}-${ARCH}.tar.gz.sha256sum"

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
  fi

  # Helm plugins
  if ! grep -qE "^gcs\s+${HELM_PLUGIN_GCS_VERSION}\b" < <("${HOME}/opt/bin/helm" plugin list); then
    if grep -qE "^gcs\s" < <("${HOME}/opt/bin/helm" plugin list); then
      "${HOME}/opt/bin/helm" plugin uninstall gcs
    fi
    # Helm 4 verifies plugins by default, git sources don't support it
    "${HOME}/opt/bin/helm" plugin install https://github.com/hayorov/helm-gcs --version "${HELM_PLUGIN_GCS_VERSION}" --verify=false
  fi
}
