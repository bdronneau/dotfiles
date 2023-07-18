#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v brew > /dev/null 2>&1; then
    brew install --quiet shellcheck
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq shellcheck
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -Sq --noconfirm --needed shellcheck
  fi
}
