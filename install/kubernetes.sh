#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

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

  # renovate: datasource=github-tags depName=elsesiy/kubectl-view-secret
  local KUBECTL_VIEW_SECRET_VERSION=v0.9.0
  # renovate: datasource=github-tags depName=bergerx/kubectl-status
  local KUBECTL_STATUS_VERSION="v0.7.13"
  # renovate: datasource=github-tags depName=ahmetb/kubectl-tree
  local KUBECTL_TREE_VERSION="v0.4.6"
  # renovate: datasource=github-tags depName=davidB/kubectl-view-allocations
  local KUBECTL_ALLOCATIONS_VERSION="1.0.0"
  # renovate: datasource=github-releases depName=ahmetb/kubectx
  local KUBETOOLS_VERSION="v0.9.5"
  # renovate: datasource=github-releases depName=vibioh/kmux
  local KUBEMUX_VERSION="v0.14.3"
  # renovate: datasource=github-releases depName=FairwindsOps/pluto
  local PLUTO_VERSION_TAG="v5.22.7"
  local PLUTO_VERSION="${PLUTO_VERSION_TAG/v/}"
  # renovate: datasource=github-releases depName=zegl/kube-score
  local KUBE_SCORE_VERSION_TAG="v1.20.0"
  local KUBE_SCORE_VERSION="${KUBE_SCORE_VERSION_TAG/v/}"
  # renovate: datasource=github-releases depName=derailed/popeye
  local POPEYE_VERSION_TAG="v0.22.1"
  # renovenate: datasource=github-releases depName=pehlicd/crd-wizard
  local CRD_WIZARD_VERSION_TAG="v0.1.4"

  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  local ARCH
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

  if [[ ! -f "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    mkdir -p "${HOME}/opt/bash-completion.d"


    download "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/${ARCH}/kubectl" "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}"
    chmod u+x "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}"

    [[ -f "${KUBECTL_BIN}" ]] && rm -f "${KUBECTL_BIN}"

    # Activate version
    ln -Fs "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" "${KUBECTL_BIN}"

    # Generate bash completion
    "${KUBECTL_BIN}" completion bash > "${HOME}/opt/bash-completion.d/kubectl"
  fi

  local KUBECTX_BIN="${HOME}/opt/bin/kubectx"

  if [[ ! -f "${HOME}/opt/kubectl/kubectx_${KUBETOOLS_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    local kubectx_ARCHIVE="kubectx_${KUBETOOLS_VERSION}_${OS}_${ARCH}.tar.gz"
    url_tar "https://github.com/ahmetb/kubectx/releases/download/${KUBETOOLS_VERSION}/${kubectx_ARCHIVE}" "kubectx" "${HOME}/opt/kubectl/kubectx_${KUBETOOLS_VERSION}"

    # Activate version
    [ -f "${KUBECTX_BIN}" ] && rm -f "${KUBECTX_BIN}"
    ln -Fs "${HOME}/opt/kubectl/kubectx_${KUBETOOLS_VERSION}" "${KUBECTX_BIN}"
  fi

  local KUBENS_BIN="${HOME}/opt/bin/kubens"

  if [[ ! -f "${HOME}/opt/kubectl/kubens_${KUBETOOLS_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    local KUBENS_ARCHIVE="kubens_${KUBETOOLS_VERSION}_${OS}_${ARCH}.tar.gz"
    url_tar "https://github.com/ahmetb/kubectx/releases/download/${KUBETOOLS_VERSION}/${KUBENS_ARCHIVE}" "kubens" "${HOME}/opt/kubectl/kubens_${KUBETOOLS_VERSION}"

    # Activate version
    [ -f "${KUBENS_BIN}" ] && rm -f "${KUBENS_BIN}"
    ln -Fs "${HOME}/opt/kubectl/kubens_${KUBETOOLS_VERSION}" "${KUBENS_BIN}"
  fi

  if command -v kubectl > /dev/null 2>&1; then
    if [[ ! -f "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" ]]; then
      url_tar "https://github.com/elsesiy/kubectl-view-secret/releases/download/${KUBECTL_VIEW_SECRET_VERSION}/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_${OS}_${ARCH}.tar.gz" "kubectl-view-secret" "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" "${HOME}/opt/bin/kubectl-view_secret"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" ]]; then
      url_tar "https://github.com/bergerx/kubectl-status/releases/download/${KUBECTL_STATUS_VERSION}/status_${OS}_${ARCH}.tar.gz" "status" "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" "${HOME}/opt/bin/kubectl-status"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" ]]; then
      url_tar "https://github.com/ahmetb/kubectl-tree/releases/download/${KUBECTL_TREE_VERSION}/kubectl-tree_${KUBECTL_TREE_VERSION}_${OS}_${ARCH}.tar.gz" "kubectl-tree" "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" "${HOME}/opt/bin/kubectl-tree"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}" ]]; then
      KUBECTL_ALLOCATIONS_URL="https://github.com/davidB/kubectl-view-allocations/releases/download/${KUBECTL_ALLOCATIONS_VERSION}/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}"
      if [[ ${OS} =~ ^darwin ]]; then
        KUBECTL_ALLOCATIONS_URL+="-x86_64-apple-${OS}.tar.gz"
      else
        KUBECTL_ALLOCATIONS_URL+="-x86_64-unknown-${OS}-gnu.tar.gz"
      fi

      url_tar "${KUBECTL_ALLOCATIONS_URL}" "kubectl-view-allocations" "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}" "${HOME}/opt/bin/kubectl-view-allocations"
    fi
  fi

  if [[ ! -f "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"

    local KUBEMUX_ARCHIVE="kmux_${OS}_${ARCH}.tar.gz"
    url_tar "https://github.com/ViBiOh/kmux/releases/download/${KUBEMUX_VERSION}/${KUBEMUX_ARCHIVE}" "kmux" "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}"

    # Activate version
    [ -f "${HOME}/opt/bin/kubemux" ] && rm -f "${HOME}/opt/bin/kubemux"
    ln -Fs "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}" "${HOME}/opt/bin/kubemux"
    chmod u+x "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}"

    kubemux completion bash | sed 's|kmux|kubemux|g' > "${HOME}/opt/bash-completion.d/kubemux"
  fi

  if [[ ! -f "${HOME}/opt/kubectl/pluto-${PLUTO_VERSION}" ]]; then
    url_tar "https://github.com/FairwindsOps/pluto/releases/download/${PLUTO_VERSION_TAG}/pluto_${PLUTO_VERSION}_${OS}_${ARCH}.tar.gz" "pluto" "${HOME}/opt/kubectl/pluto-${PLUTO_VERSION}"
    ln -snf "${HOME}/opt/kubectl/pluto-${PLUTO_VERSION}" "${HOME}/opt/bin/pluto"
  fi

  if [[ ! -f "${HOME}/opt/kubectl/kube-score-${KUBE_SCORE_VERSION}" ]]; then
    url_tar "https://github.com/zegl/kube-score/releases/download/${KUBE_SCORE_VERSION_TAG}/kube-score_${KUBE_SCORE_VERSION}_${OS}_${ARCH}.tar.gz" "kube-score" "${HOME}/opt/kubectl/kube-score-${KUBE_SCORE_VERSION}"
    ln -snf "${HOME}/opt/kubectl/kube-score-${KUBE_SCORE_VERSION}" "${HOME}/opt/bin/kube-score"
  fi

  if [[ ! -f "${HOME}/opt/kubectl/popeye-${POPEYE_VERSION_TAG}" ]]; then
    url_tar "https://github.com/derailed/popeye/releases/download/${POPEYE_VERSION_TAG}/popeye_${OS}_${ARCH}.tar.gz" "popeye" "${HOME}/opt/kubectl/popeye-${POPEYE_VERSION_TAG}"
    ln -snf "${HOME}/opt/kubectl/popeye-${POPEYE_VERSION_TAG}" "${HOME}/opt/bin/popeye"
  fi

  if [[ ! -f "${HOME}/opt/kubectl/kubectl-crd-wizard-${CRD_WIZARD_VERSION_TAG}" ]]; then
    url_tar "https://github.com/pehlicd/crd-wizard/releases/download/${CRD_WIZARD_VERSION_TAG}/crd-wizard_${CRD_WIZARD_VERSION_TAG}_${OS}_${ARCH}.tar.gz" "crd-wizard" "${HOME}/opt/kubectl/kubectl-crd-wizard-${CRD_WIZARD_VERSION_TAG}"
    ln -snf "${HOME}/opt/kubectl/kubectl-crd-wizard-${CRD_WIZARD_VERSION_TAG}" "${HOME}/opt/bin/kubectl-crd-wizard"
  fi
}
