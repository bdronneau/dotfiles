#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if ! [ -f "${HOME}/Library/Python/2.7/bin/pip" ]; then
    easy_install --user pip
    export PATH="${HOME}/Library/Python/2.7/bin/:${PATH}"
  fi

  if command -v pip > /dev/null 2>&1; then
    pip install --user virtualenvwrapper
  fi
}
