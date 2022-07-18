#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

FLUX_BIN="${HOME}/opt/bin/flux"
KUBESEAL_BIN="${HOME}/opt/bin/kubeseal"
FLUX_COMPLETION="${HOME}/opt/bash-completion.d/flux"

clean() {
  rm -rf "${FLUX_COMPLETION}"
  rm -rf "${FLUX_BIN}"
  rm -rf "${HOME}/opt/flux"
}

install() {
  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')

  # renovate: datasource=github-tags depName=fluxcd/flux2
  local FLUX_VERSION_TAG="v0.31.4"
  local FLUX_VERSION="${FLUX_VERSION_TAG/v/}"
  if [[ ! -f "${HOME}/opt/flux/flux_${FLUX_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/flux"
    url_tar "https://github.com/fluxcd/flux2/releases/download/${FLUX_VERSION_TAG}/flux_${FLUX_VERSION}_${OS}_amd64.tar.gz" "flux" "${HOME}/opt/flux/flux_${FLUX_VERSION}"

    if [[ -f "${FLUX_BIN}" ]]; then
      rm -f "${FLUX_BIN}"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/flux/flux_${FLUX_VERSION}" "${FLUX_BIN}"

    flux completion bash > "${FLUX_COMPLETION}"
  fi

  # renovate: datasource=github-tags depName=bitnami-labs/sealed-secrets
  local KUBESEAL_VERSION="v0.18.0"
  if [[ ! -f "${HOME}/opt/kubeseal/kubeseal_${KUBESEAL_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/kubeseal"
    url_tar "https://github.com/bitnami-labs/sealed-secrets/releases/download/${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION/v/}-${OS}-amd64.tar.gz" "kubeseal" "${HOME}/opt/kubeseal/kubeseal_${KUBESEAL_VERSION}"

    if [[ -f "${KUBESEAL_BIN}" ]]; then
      rm -f "${KUBESEAL_BIN}"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/kubeseal/kubeseal_${KUBESEAL_VERSION}" "${KUBESEAL_BIN}"

    chmod 0700  "${KUBESEAL_BIN}"
  fi
}
