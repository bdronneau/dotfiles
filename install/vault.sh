#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/vault*"
}

install() {
  # renovate: datasource=github-tags depName=hashicorp/vault
  local VAULT_VERSION_TAG="v1.13.3"
  local VAULT_VERSION="${VAULT_VERSION_TAG/v/}"

  if [[ ! -f "${HOME}/opt/vault/vault_${VAULT_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/vault"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    download "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_${OS}_amd64.zip" "vault_${VAULT_VERSION}_${OS}_amd64.zip"
    unzip "vault_${VAULT_VERSION}_${OS}_amd64.zip"
    rm "vault_${VAULT_VERSION}_${OS}_amd64.zip"
    mv "vault" "${HOME}/opt/vault/vault_${VAULT_VERSION}"

    if [[ -f "${HOME}/opt/bin/vault" ]]; then
      rm -f "${HOME}/opt/bin/vault"
    fi

    # Activate version
    ln -Fs "${HOME}/opt/vault/vault_${VAULT_VERSION}" "${HOME}/opt/bin/vault"
  fi
}
