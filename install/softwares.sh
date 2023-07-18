#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install wget gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo sh -c 'install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/'
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt-get install -y -qq firefox keepassxc code
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed firefox code flatpak
  elif command -v brew > /dev/null 2>&1; then
    brew install --quiet keepassxc
  fi

  if command -v code > /dev/null 2>&1; then
    code --install-extension bungcip.better-toml
    code --install-extension EditorConfig.EditorConfig
    code --install-extension esbenp.prettier-vscode
    code --install-extension golang.go
    code --install-extension hashicorp.terraform
    code --install-extension wholroyd.jinja
    code --install-extension waderyan.gitblame
    code --install-extension 4ops.terraform
  fi

  if command -v flatpak > /dev/null 2>&1; then
    flatpak install us.zoom.Zoom --or-update --noninteractive
    flatpak install com.slack.Slack --or-update --noninteractive
  fi
}
