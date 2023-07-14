#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  local PACKAGES=('bash' 'bash-completion' 'htop' 'openssl' 'curl' 'vim' 'git-lfs')

  mkdir -p "${HOME}/opt/bin"

  cat > "${HOME}/.bash_profile" << END_OF_BASH_PROFILE
#!/usr/bin/env bash

if [[ -f ${HOME}/.bashrc ]]; then
  source "${HOME}/.bashrc"
fi
END_OF_BASH_PROFILE

  if [[ ${OSTYPE} =~ ^darwin ]]; then
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if ! command -v brew > /dev/null 2>&1; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
      # shellcheck source=/dev/null
      source "${SCRIPT_DIR}/../sources/_homebrew"
    fi

    brew update
    brew upgrade
    brew install "${PACKAGES[@]}"
    brew install --cask 1password 1password-cli nextcloud balenaetcher rectangle raycast firefox google-chrome postico cyberduck spotify discord obs slack iterm2
    brew install tailscale smug

    if [[ $(grep -c "$(brew --prefix)" "/etc/shells") -eq 0 ]]; then
      echo "+-------------------------+"
      echo "| changing shell for user |"
      echo "+-------------------------+"

      echo "$(brew --prefix)/bin/bash" | sudo tee -a "/etc/shells" > /dev/null
      chsh -s "$(brew --prefix)/bin/bash" -u "$(whoami)"
    fi
  elif command -v apt-get > /dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive

    sudo apt-get update
    sudo apt-get upgrade -y -qq
    sudo apt-get install -y -qq apt-transport-https curl wget nmap netcat net-tools

    sudo apt-get install -y -qq "${PACKAGES[@]}" dnsutils
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -Syuq --noconfirm
    sudo pacman -S --noconfirm --needed "${PACKAGES[@]}" \
      make \
      binutils \
      yay \
      git \
      netcat \
      dnsutils
  fi
}
