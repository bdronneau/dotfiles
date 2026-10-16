#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install wget gpg
    wget --https-only --max-redirect=0 -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo sh -c 'install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/'
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt-get install -y -qq firefox keepassxc code
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed firefox code flatpak
  elif command -v brew > /dev/null 2>&1; then
    brew install --quiet keepassxc
    brew install --quiet --cask ghostty visual-studio-code claude-code claude docker-desktop
    HOMEBREW_CASK_OPTS="" brew install --quiet --cask google-chrome
  fi

  if command -v code > /dev/null 2>&1; then
    local extensions=(
      4ops.terraform
      a-h.templ
      anthropic.claude-code
      continue.continue
      editorconfig.editorconfig
      esbenp.prettier-vscode
      golang.go
      hashicorp.terraform
      mohsen1.prettify-json
      ms-python.debugpy
      ms-python.python
      ms-python.vscode-pylance
      ms-python.vscode-python-envs
      redhat.ansible
      redhat.vscode-yaml
      tamasfe.even-better-toml
      waderyan.gitblame
      wholroyd.jinja
    )
    local install_args=()
    local extension
    for extension in "${extensions[@]}"; do
      install_args+=(--install-extension "${extension}")
    done

    # Single invocation, and drop Electron's noisy url.parse() deprecation warning
    code "${install_args[@]}" 2>&1 | { grep -vE 'DeprecationWarning|--trace-deprecation' || true; }
  fi

  if command -v flatpak > /dev/null 2>&1; then
    flatpak install us.zoom.Zoom --or-update --noninteractive
    flatpak install com.slack.Slack --or-update --noninteractive
  fi
}
