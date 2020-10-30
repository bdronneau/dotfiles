#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/opt/bin/jq*"
  rm -rf "${HOME}/opt/jq*"
}

install() {
  local JQ_VERSION=1.6
  if [[ ! -f "${HOME}/opt/jq/jq_${JQ_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/jq"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -sSL -q --max-time 300 -O "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-${OS}64"
    mv "jq-${OS}64" "${HOME}/opt/jq/jq_${JQ_VERSION}"

    if [[ -f "${HOME}/opt/bin/jq" ]]; then
      rm -f "${HOME}/opt/bin/jq"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/jq/jq_${JQ_VERSION}" "${HOME}/opt/bin/jq"
    chmod u+x "${HOME}/opt/bin/jq"
  fi
}
