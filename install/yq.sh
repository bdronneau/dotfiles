#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/opt/bin/yq*"
  rm -rf "${HOME}/opt/yq*"
}

install() {
  local YQ_VERSION=3.4.1
  if [[ ! -f "${HOME}/opt/yq/yq_${YQ_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/yq"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -sSL -q --max-time 300 -O "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_${OS}_amd64"
    mv "yq_${OS}_amd64" "${HOME}/opt/yq/yq_${YQ_VERSION}"

    if [[ -f "${HOME}/opt/bin/yq" ]]; then
      rm -f "${HOME}/opt/bin/yq"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/yq/yq_${YQ_VERSION}" "${HOME}/opt/bin/yq"
    chmod u+x "${HOME}/opt/bin/yq"
  fi
}
