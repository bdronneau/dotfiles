#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

install() {
  if [[ ! -f "${HOME}/opt/fz/fz.sh" ]]; then
    mkdir -p "${HOME}/opt/fz"

    download "https://raw.githubusercontent.com/changyuheng/fz/master/fz.sh" -o "${HOME}/opt/fz/fz.sh"
  fi
}
