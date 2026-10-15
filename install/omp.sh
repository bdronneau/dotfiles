#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

APP_MISE_TOOL="github:can1357/oh-my-pi"

clean() {
  if command -v mise > /dev/null 2>&1; then
    mise unuse --global "${APP_MISE_TOOL}"
  fi
}

install() {
  if ! command -v mise > /dev/null 2>&1 && command -v brew > /dev/null 2>&1; then
    brew install --quiet mise
  fi

  if ! command -v mise > /dev/null 2>&1; then
    printf "mise is required to install oh-my-pi\n" >&2
    return 1
  fi

  # Pins the tool in ~/.config/mise/config.toml and installs the latest release
  mise use --global "${APP_MISE_TOOL}@latest"
}
