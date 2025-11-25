#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/bin/yq*"
  rm -rf "${HOME}/opt/yq*"
}

install() {
  # renovate: datasource=github-tags depName=mikefarah/yq
  local YQ_VERSION="v4.49.2"
  if [[ ! -f "${HOME}/opt/yq/yq_${YQ_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/yq"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    download "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${OS}_${ARCH}" "yq_${OS}_${ARCH}"
    mv "yq_${OS}_${ARCH}" "${HOME}/opt/yq/yq_${YQ_VERSION}"

    if [[ -f "${HOME}/opt/bin/yq" ]]; then
      rm -f "${HOME}/opt/bin/yq"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/yq/yq_${YQ_VERSION}" "${HOME}/opt/bin/yq"
    chmod u+x "${HOME}/opt/bin/yq"
  fi
}
