#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

install() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq jq
  elif command -v brew > /dev/null 2>&1; then
    brew install --quiet jq
  fi
}
