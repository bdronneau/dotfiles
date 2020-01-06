#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/.z"
  rm -rf "${HOME}/opt/z"
}

install() {
  if [[ ! -f "${HOME}/opt/z/z.sh" ]]; then
    mkdir -p "${HOME}/opt/z"

    curl "https://raw.githubusercontent.com/rupa/z/master/z.sh" -o "${HOME}/opt/z/z.sh"
  fi
}
