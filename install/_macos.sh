#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if ! [[ ${OSTYPE} =~ ^darwin ]]; then
    return
  fi

  defaults write com.apple.screencapture show-thumbnail -bool false
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
}
