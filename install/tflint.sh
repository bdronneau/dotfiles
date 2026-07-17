#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

TFLINT_BIN="${HOME}/opt/bin/tflint"

clean() {
  rm -rf "${HOME}/opt/tflint"
  rm -f "${TFLINT_BIN}"
}

install() {
  # renovate: datasource=github-tags depName=terraform-linters/tflint
  local TFLINT_VERSION="v0.61.0"

  local OS
  OS="$(get_os)"
  local ARCH
  ARCH="$(get_arch amd64)"

  if [[ ! -f "${HOME}/opt/tflint/tflint_${TFLINT_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/tflint"
    mkdir -p "${HOME}/opt/tmp/tflint_${TFLINT_VERSION}"

    download "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_${OS}_${ARCH}.zip" "${HOME}/opt/tmp/tflint_${TFLINT_VERSION}/tflint.zip"

    pushd "${HOME}/opt/tmp/tflint_${TFLINT_VERSION}"
    unzip "tflint.zip"
    mv "tflint" "${HOME}/opt/tflint/tflint_${TFLINT_VERSION}"
    popd
    rm -Rf "${HOME}/opt/tmp/tflint_${TFLINT_VERSION}"

    chmod u+x "${HOME}/opt/tflint/tflint_${TFLINT_VERSION}"

    [[ -f "${TFLINT_BIN}" ]] && rm -f "${TFLINT_BIN}"

    # Activate version
    ln -Fs "${HOME}/opt/tflint/tflint_${TFLINT_VERSION}" "${TFLINT_BIN}"
  fi
}
