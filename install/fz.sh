#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ ! -f "${HOME}/opt/fz/fz.sh" ]]; then
    mkdir -p "${HOME}/opt/fz"

    curl "https://raw.githubusercontent.com/changyuheng/fz/master/fz.sh" -o "${HOME}/opt/fz/fz.sh"
  fi
}

main

