#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/.gsutil"
  rm -rf "${HOME}/.config/gcloud"
}

install() {
  if [[ ! -d "${HOME}/opt/google-cloud-sdk" ]]; then
    local GCLOUD_VERSION=245.0.0
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
    local GO_ARCHIVE
    GO_ARCHIVE="google-cloud-sdk-${GCLOUD_VERSION}-${OS}-${ARCH}.tar.gz"

    rm -rf "${HOME}/.config/gcloud"

    curl -q -sSL --max-time 300 -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GO_ARCHIVE}"
    rm -rf "${HOME}/opt/google-cloud-sdk"
    tar -C "${HOME}/opt" -xzf "${GO_ARCHIVE}"
    rm -rf "${GO_ARCHIVE}"
  fi
}
