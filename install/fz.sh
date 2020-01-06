#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if [[ ! -f "${HOME}/opt/fz/fz.sh" ]]; then
    mkdir -p "${HOME}/opt/fz"

    curl "https://raw.githubusercontent.com/changyuheng/fz/master/fz.sh" -o "${HOME}/opt/fz/fz.sh"
  fi
}
