#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/pyenv"
}

requirements() {
  if command -v apt-get > /dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y -qq make \
      build-essential \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      wget \
      curl \
      llvm \
      libncursesw5-dev \
      xz-utils \
      tk-dev \
      libxml2-dev \
      libxmlsec1-dev \
      libffi-dev \
      liblzma-dev
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed base-devel openssl zlib xz
  fi
}

install() {
  # renovate: datasource=github-tags depName=pyenv/pyenv
  local PYENV_VERSION="v2.4.13"

  if [[ ! -d "${HOME}/opt/pyenv/${PYENV_VERSION}" ]]; then
    requirements

    mkdir -p "${HOME}/opt/pyenv/"

    git clone -q --depth 1 --branch ${PYENV_VERSION} https://github.com/pyenv/pyenv "${HOME}/opt/pyenv/${PYENV_VERSION}"

    if [[ -h "${HOME}/opt/bin/pyenv" ]]; then
      rm -f "${HOME}/opt/bin/pyenv"
    fi

    # Try to compile a dynamic Bash extension to speed up Pyenv. Don't worry if it fails; Pyenv will still work normally
    pushd "${HOME}/opt/pyenv/${PYENV_VERSION}"
    src/configure || true
    make -C src || true
    popd

    # Activate version
    ln -Fs "${HOME}/opt/pyenv/${PYENV_VERSION}/bin/pyenv" "${HOME}/opt/bin/pyenv"
  fi

  if [[ ! -d "${HOME}/opt/pyenv/${PYENV_VERSION}/plugins/pyenv-virtualenv" ]]; then
    git clone -q --depth 1 https://github.com/pyenv/pyenv-virtualenv.git "${HOME}/opt/pyenv/${PYENV_VERSION}/plugins/pyenv-virtualenv"
    pushd "${HOME}/opt/pyenv/${PYENV_VERSION}/plugins/pyenv-virtualenv"
    PREFIX="${HOME}/opt/pyenv/${PYENV_VERSION}" ./install.sh
    popd
  fi
}
