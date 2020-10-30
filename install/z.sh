#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/.z"
  rm -rf "${HOME}/opt/z"
}

install() {
  if [[ ! -f "${HOME}/opt/z/z.sh" ]]; then
    mkdir -p "${HOME}/opt/z"

    download "https://raw.githubusercontent.com/rupa/z/master/z.sh" "${HOME}/opt/z/z.sh"
  fi
}
