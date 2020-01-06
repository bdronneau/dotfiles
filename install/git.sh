#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v git > /dev/null 2>&1; then
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    curl -q -sS -o "${SCRIPT_DIR}/../sources/git-prompt" "https://raw.githubusercontent.com/git/git/v$(git --version | awk '{print $3}')/contrib/completion/git-prompt.sh"
  fi
}
