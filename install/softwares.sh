#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq firefox
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed firefox code
  fi

  if command -v code > /dev/null 2>&1; then
    code --install-extension bungcip.better-toml
    code --install-extension EditorConfig.EditorConfig
    code --install-extension esbenp.prettier-vscode
    code --install-extension golang.go
    code --install-extension hashicorp.terraform
    code --install-extension wholroyd.jinja
  fi
}
