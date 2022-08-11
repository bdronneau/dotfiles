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
  # renovate: datasource=github-tags depName=boz/kail
  local KUBECTL_KAIL_VERSION_TAG=v0.15.0
  local KUBECTL_KAIL_VERSION="${KUBECTL_KAIL_VERSION_TAG/v/}"
  # renovate: datasource=github-tags depName=bergerx/kubectl-status
  local KUBECTL_STATUS_VERSION="v0.7.2"
  # renovate: datasource=github-tags depName=ahmetb/kubectl-tree
  local KUBECTL_TREE_VERSION="v0.4.2"
  # renovate: datasource=github-tags depName=davidB/kubectl-view-allocations
  local KUBECTL_ALLOCATIONS_VERSION=0.14.5
  # renovate: datasource=github-releases depName=ahmetb/kubectx
  local KUBETOOLS_VERSION="v0.9.4"
  # renovate: datasource=github-releases depName=vibioh/kube
  local KUBEMUX_VERSION="v0.0.2"

  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  if [[ ! -f "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"
    mkdir -p "${HOME}/opt/bash-completion.d"


    download "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${OS}/amd64/kubectl" "${HOME}/opt/kubectl/kubectl_${KUBECTL_VERSION}"
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

    local kubectx_ARCHIVE="kubectx_${KUBETOOLS_VERSION}_${OS}_x86_64.tar.gz"
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

    local KUBENS_ARCHIVE="kubens_${KUBETOOLS_VERSION}_${OS}_x86_64.tar.gz"
    url_tar "https://github.com/ahmetb/kubectx/releases/download/${KUBETOOLS_VERSION}/${KUBENS_ARCHIVE}" "kubens" "${HOME}/opt/kubectl/kubens_${KUBETOOLS_VERSION}"

    # Activate version
    [ -f "${KUBENS_BIN}" ] && rm -f "${KUBENS_BIN}"
    ln -Fs "${HOME}/opt/kubectl/kubens_${KUBETOOLS_VERSION}" "${KUBENS_BIN}"
  fi

  if command -v kubectl > /dev/null 2>&1; then
    if [[ ! -f "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
      download "https://github.com/elsesiy/kubectl-view-secret/releases/download/${KUBECTL_VIEW_SECRET_VERSION}/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_amd64.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
      tar xf "kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_amd64.tar.gz"
      mv "kubectl-view-secret" "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" "${HOME}/opt/bin/kubectl-view_secret"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
      download "https://github.com/boz/kail/releases/download/${KUBECTL_KAIL_VERSION_TAG}/kail_${KUBECTL_KAIL_VERSION}_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}/kail.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
      tar xf "kail.tar.gz"
      mv "kail" "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}" "${HOME}/opt/bin/kubectl-kail"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
      download "https://github.com/bergerx/kubectl-status/releases/download/${KUBECTL_STATUS_VERSION}/status_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}/status.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
      tar xf "status.tar.gz"
      mv "status" "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" "${HOME}/opt/bin/kubectl-status"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
      download "https://github.com/ahmetb/kubectl-tree/releases/download/${KUBECTL_TREE_VERSION}/kubectl-tree_${KUBECTL_TREE_VERSION}_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}/tree.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
      tar xf "tree.tar.gz"
      mv "kubectl-tree" "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" "${HOME}/opt/bin/kubectl-tree"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}" ]]; then
      KUBECTL_ALLOCATIONS_URL="https://github.com/davidB/kubectl-view-allocations/releases/download/${KUBECTL_ALLOCATIONS_VERSION}/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}"
      if [[ ${OS} =~ ^darwin ]]; then
        KUBECTL_ALLOCATIONS_URL+="-x86_64-apple-${OS}.tar.gz"
      else
        KUBECTL_ALLOCATIONS_URL+="-x86_64-unknown-${OS}-gnu.tar.gz"
      fi

      mkdir "${HOME}/opt/tmp/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}"
      download "${KUBECTL_ALLOCATIONS_URL}" "${HOME}/opt/tmp/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}/view-allocations.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}"
      tar xf "view-allocations.tar.gz"
      mv "kubectl-view-allocations" "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}"
      ln -snf "${HOME}/opt/kubectl/kubectl-view-allocations-${KUBECTL_ALLOCATIONS_VERSION}" "${HOME}/opt/bin/kubectl-view-allocations"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-view-allocations_${KUBECTL_ALLOCATIONS_VERSION}"
    fi
  fi

  if [[ ! -f "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubectl"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    download "https://github.com/ViBiOh/kube/releases/download/${KUBEMUX_VERSION}/kube_${OS}_amd64" "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}"

    # Activate version
    [ -f "${HOME}/opt/bin/kubemux" ] && rm -f "${HOME}/opt/bin/kubemux"
    ln -Fs "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}" "${HOME}/opt/bin/kubemux"
    chmod u+x "${HOME}/opt/kubectl/kubemux_${KUBEMUX_VERSION}"

    kubemux completion bash | sed 's|kube|kubemux|g' > "${HOME}/opt/bash-completion.d/kubemux"
  fi
}
