#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  if [[ -n ${GOPATH:-} ]]; then
    sudo rm -rf "${GOPATH}"
    mkdir -p "${GOPATH}"
  fi

  rm -rf "${HOME}/opt/go"
  rm -rf "${HOME}/.dlv"
}

install() {
  # renovate: datasource=github-tags depName=golang/go versioning=regex:^go(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)
  local GO_VERSION="go1.18.4"

  local OS
  OS="$(uname -s | tr "[:upper:]" "[:lower:]")"
  local ARCH
  ARCH="$(uname -m | tr "[:upper:]" "[:lower:]")"

  if [[ ${ARCH} = "x86_64" ]]; then
    ARCH="amd64"
  elif [[ ${ARCH} =~ ^armv.l$ ]]; then
    ARCH="armv6l"
  fi

  if [[ ! -d ${HOME}/opt/go ]]; then
    local GO_ARCHIVE="${GO_VERSION}.${OS}-${ARCH}.tar.gz"

    download "https://dl.google.com/go/${GO_ARCHIVE}" "${GO_ARCHIVE}"
    tar -C "${HOME}/opt" -xzf "${GO_ARCHIVE}"
    rm -rf "${GO_ARCHIVE}"
  fi

  local SCRIPT_DIR
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=/dev/null
  source "${SCRIPT_DIR}/../sources/golang"
  mkdir -p "${GOPATH}"

  if command -v go > /dev/null 2>&1; then
    if [[ ${ARCH} == "amd64" ]]; then
      go install github.com/go-delve/delve/cmd/dlv@latest
    fi

    GO111MODULE=on go install golang.org/x/tools/gopls@latest
    go install github.com/kisielk/errcheck@latest
    go install golang.org/x/lint/golint@latest
    go install golang.org/x/tools/cmd/goimports@latest
  fi
}
