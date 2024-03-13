#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/.gsutil"
  rm -rf "${HOME}/.config/gcloud"
}

install() {
  if [[ ! -d "${HOME}/opt/google-cloud-sdk" ]]; then
    local GCLOUD_VERSION="468.0.0"
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
}
