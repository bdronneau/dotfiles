#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if ! [ -f "${HOME}/Library/Python/2.7/bin/pip" ]; then
    easy_install --user pip
    export PATH="${HOME}/Library/Python/2.7/bin/:${PATH}"
  fi

  if command -v pip > /dev/null 2>&1; then
    pip install --user virtualenvwrapper
  fi
}

main