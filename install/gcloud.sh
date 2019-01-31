#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ ! -d "${HOME}/opt/google-cloud-sdk" ]]; then
    local GCLOUD_VERSION=225.0.0
    local OS=$(uname -s)
    local ARCH=$(uname -m)

    local GO_ARCHIVE="google-cloud-sdk-${GCLOUD_VERSION}-${OS,,}-${ARCH,,}.tar.gz"

    rm -rf "${HOME}/.config/gcloud"

    curl -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GO_ARCHIVE}"
    rm -rf "${HOME}/opt/google-cloud-sdk"
    tar -C "${HOME}/opt" -xzf "${GO_ARCHIVE}"
    rm -rf "${GO_ARCHIVE}"
  fi
}

main