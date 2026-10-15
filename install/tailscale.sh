#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if ! [[ ${OSTYPE} =~ ^darwin ]] || ! command -v brew > /dev/null 2>&1; then
    return
  fi

  if brew list --cask tailscale-app > /dev/null 2>&1; then
    return
  fi

  if [[ -d /Applications/Tailscale.app/Contents/_MASReceipt ]]; then
    printf "Tailscale from the App Store is installed: quit it and delete /Applications/Tailscale.app first\n" >&2
    return 1
  fi

  # The formula's CLI in /opt/homebrew/bin would shadow the app's /usr/local/bin/tailscale
  if brew list --formula tailscale > /dev/null 2>&1; then
    brew uninstall --formula tailscale
  fi

  brew install --quiet --cask tailscale-app
}
