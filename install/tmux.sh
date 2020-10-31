#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if [[ "${OSTYPE}" =~ ^darwin ]]; then
    brew install \
      tmux \
      reattach-to-user-namespace
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq tmux
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed tmux
  fi
}
