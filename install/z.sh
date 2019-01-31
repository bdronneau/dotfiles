#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ ! -f "${HOME}/opt/z/z.sh" ]]; then
    mkdir -p "${HOME}/opt/z"

    curl "https://raw.githubusercontent.com/rupa/z/master/z.sh" -o "${HOME}/opt/z/z.sh"
  fi
}

main

