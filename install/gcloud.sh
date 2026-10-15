#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/.gsutil"
  rm -rf "${HOME}/.config/gcloud"
}

install() {
  # gcloud wants Python 3.14 on macOS (else it runs a sudo installer), managed by uv (see _uv.sh)
  if ! command -v uv > /dev/null 2>&1; then
    printf "uv is required to install gcloud, set DOTFILES__UV=true\n" >&2
    return 1
  fi

  uv python install 3.14
  CLOUDSDK_PYTHON="$(uv python find 3.14)"
  export CLOUDSDK_PYTHON

  if [[ ! -d "${HOME}/opt/google-cloud-sdk" ]]; then
    local GCLOUD_VERSION="589.0.0"
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    # Handle architecture specific to macOS
    if [[ "$OS" == "darwin" && "$ARCH" == "arm64" ]]; then
      ARCH="arm"
    fi

    local GO_ARCHIVE
    GO_ARCHIVE="google-cloud-sdk-${GCLOUD_VERSION}-${OS}-${ARCH}.tar.gz"

    rm -rf "${HOME}/.config/gcloud"

    download "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GO_ARCHIVE}" "${GO_ARCHIVE}"
    rm -rf "${HOME}/opt/google-cloud-sdk"
    tar -C "${HOME}/opt" -xzf "${GO_ARCHIVE}"
    rm -rf "${GO_ARCHIVE}"
  fi

  if command -v gcloud > /dev/null 2>&1; then
    gcloud components update --quiet
  fi

  gcloud components install gke-gcloud-auth-plugin
}
