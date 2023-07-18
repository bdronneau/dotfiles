#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v brew > /dev/null 2>&1; then
    brew install --quiet colima
    colima nerdctl install --force --path "${HOME}/opt/bin/nerdctl"
  else
    printf "Colima is not handle by this OS\n"
  fi
}
