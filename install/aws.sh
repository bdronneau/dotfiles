#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/.aws/sso/cache"
  rm -rf "${HOME}/.granted"
}

install() {
  if [[ ${OSTYPE} =~ ^darwin ]]; then
    brew install --quiet awscli
    # Granted has no darwin binary on GitHub, install it from its own tap.
    brew tap common-fate/granted
    brew install --quiet common-fate/granted/granted
    return
  fi

  local OS
  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  local ARCH
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

  # AWS CLI v2 (official bundled installer)
  if ! command -v aws > /dev/null 2>&1; then
    local AWS_ARCH="${ARCH}"
    [[ "${AWS_ARCH}" == "arm64" ]] && AWS_ARCH="aarch64"

    download "https://awscli.amazonaws.com/awscli-exe-${OS}-${AWS_ARCH}.zip" "${HOME}/opt/tmp/awscliv2.zip"
    unzip -qo "${HOME}/opt/tmp/awscliv2.zip" -d "${HOME}/opt/tmp"
    "${HOME}/opt/tmp/aws/install" --bin-dir "${HOME}/opt/bin" --install-dir "${HOME}/opt/aws-cli" --update
    rm -rf "${HOME}/opt/tmp/awscliv2.zip" "${HOME}/opt/tmp/aws"
  fi

  # Granted (assume / assumego)
  # renovate: datasource=github-releases depName=common-fate/granted
  local GRANTED_VERSION_TAG="v0.39.0"
  local GRANTED_VERSION="${GRANTED_VERSION_TAG/v/}"
  if [[ ! -f "${HOME}/opt/granted/granted_${GRANTED_VERSION}/granted" ]]; then
    # GitHub tarballs are named linux_x86_64 / linux_arm64
    local GRANTED_ARCH="${ARCH}"
    [[ "${GRANTED_ARCH}" == "aarch64" ]] && GRANTED_ARCH="arm64"

    mkdir -p "${HOME}/opt/granted/granted_${GRANTED_VERSION}"
    download "https://github.com/common-fate/granted/releases/download/${GRANTED_VERSION_TAG}/granted_${GRANTED_VERSION}_${OS}_${GRANTED_ARCH}.tar.gz" "${HOME}/opt/tmp/granted.tar.gz"
    tar -C "${HOME}/opt/granted/granted_${GRANTED_VERSION}" -xzf "${HOME}/opt/tmp/granted.tar.gz"
    rm -f "${HOME}/opt/tmp/granted.tar.gz"

    # Activate version: symlink assume, assumego and granted into opt/bin
    local file
    for file in assume assumego granted; do
      [[ -f "${HOME}/opt/bin/${file}" ]] && rm -f "${HOME}/opt/bin/${file}"
      ln -Fs "${HOME}/opt/granted/granted_${GRANTED_VERSION}/${file}" "${HOME}/opt/bin/${file}"
      chmod u+x "${HOME}/opt/granted/granted_${GRANTED_VERSION}/${file}"
    done
  fi
}
