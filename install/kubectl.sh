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

  local KUBECTL_VIEW_SECRET_VERSION=0.6.0
  local KUBECTL_KAIL_VERSION=0.15.0
  local KUBECTL_STATUS_VERSION=0.4.1
  local KUBECTL_TREE_VERSION=0.4.0
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

  if command -v kubectl > /dev/null 2>&1; then
    if [[ ! -f "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
      download "https://github.com/elsesiy/kubectl-view-secret/releases/download/v${KUBECTL_VIEW_SECRET_VERSION}/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_${OS}_x86_64.tar.gz" "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_x86_64.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
      tar xf "kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}_x86_64.tar.gz"
      mv "kubectl-view-secret" "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}"
      ln -snF "${HOME}/opt/kubectl/kubectl-view_secret-${KUBECTL_VIEW_SECRET_VERSION}" "${HOME}/opt/bin/kubectl-view_secret"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-view-secret_${KUBECTL_VIEW_SECRET_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
      download "https://github.com/boz/kail/releases/download/v${KUBECTL_KAIL_VERSION}/kail_${KUBECTL_KAIL_VERSION}_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}/kail.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
      tar xf "kail.tar.gz"
      mv "kail" "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}"
      ln -snF "${HOME}/opt/kubectl/kubectl-kail-${KUBECTL_KAIL_VERSION}" "${HOME}/opt/bin/kubectl-kail"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-kail_${KUBECTL_KAIL_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
      download "https://github.com/bergerx/kubectl-status/releases/download/v${KUBECTL_STATUS_VERSION}/status_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}/status.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
      tar xf "status.tar.gz"
      mv "status" "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}"
      ln -snF "${HOME}/opt/kubectl/kubectl-status-${KUBECTL_STATUS_VERSION}" "${HOME}/opt/bin/kubectl-status"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-status_${KUBECTL_STATUS_VERSION}"
    fi

    if [[ ! -f "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" ]]; then
      mkdir "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
      download "https://github.com/ahmetb/kubectl-tree/releases/download/v${KUBECTL_TREE_VERSION}/kubectl-tree_v${KUBECTL_TREE_VERSION}_${OS}_amd64.tar.gz" "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}/tree.tar.gz"
      pushd "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
      tar xf "tree.tar.gz"
      mv "kubectl-tree" "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}"
      ln -snF "${HOME}/opt/kubectl/kubectl-tree-${KUBECTL_TREE_VERSION}" "${HOME}/opt/bin/kubectl-tree"
      popd
      rm -Rf "${HOME}/opt/tmp/kubectl-tree_${KUBECTL_TREE_VERSION}"
    fi
  fi
}
