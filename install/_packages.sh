#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ "${OSTYPE}" =~ ^darwin ]]; then
    if ! command -v brew > /dev/null 2>&1; then
      mkdir "${HOME}/homebrew" && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "${HOME}/homebrew"
      # After install source path of homebrew for current run
      source "${SCRIPT_DIR}/../sources/_homebrew"
    fi

    brew update
    brew upgrade
    brew install \
      bash \
      bash-completion \
      git \
      htop \
      ncdu \
      git \
      openssl \
      siege \
      curl \
      jq \
      pass
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get upgrade -y -qq
    sudo apt-get install -y -qq apt-transport-https

    sudo apt-get install -y -qq \
      bash \
      bash-completion \
      git
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -Syuq --noconfirm
    sudo pacman -Sq --noconfirm --needed \
      make \
      binutils \
      yay \
      git \
      bash-completion \
      code \
      firefox \
      tmux \
      gnupg \
      netcat
  fi
}

main
