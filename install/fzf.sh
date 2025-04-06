#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/bin/fzf"
  rm -rf "${HOME}/opt/fzf"
}

install() {
  # renovate: datasource=github-tags depName=junegunn/fzf
  local FZF_VERSION_TAG="v0.61.1"
  local FZF_VERSION="${FZF_VERSION_TAG/v/}"
  if [[ ! -f "${HOME}/opt/fzf/fzf_${FZF_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/fzf"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    local EXT
    EXT="tar.gz"

    if [ "${OS}" = "darwin" ]; then
        EXT="zip"
    fi

    download "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION_TAG}/fzf-${FZF_VERSION}-${OS}_${ARCH}.${EXT}" "fzf-${FZF_VERSION}-${OS}_${ARCH}.${EXT}"

    if [ "${EXT}" = "tar.gz" ]; then
      tar xf "fzf-${FZF_VERSION}-${OS}_${ARCH}.${EXT}"
    else
      unzip "fzf-${FZF_VERSION}-${OS}_${ARCH}.${EXT}"
    fi

    mv "fzf" "${HOME}/opt/fzf/fzf_${FZF_VERSION}"
    rm "fzf-${FZF_VERSION}-${OS}_${ARCH}.${EXT}"

    if [[ -f "${HOME}/opt/bin/fzf" ]]; then
      rm -f "${HOME}/opt/bin/fzf"
    fi

    download "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION_TAG}/shell/completion.bash" "${HOME}/opt/bash-completion.d/fzf.completion.bash"
    download "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION_TAG}/shell/key-bindings.bash" "${HOME}/opt/bash-completion.d/fzf.key-bindings.bash"

    # Activate version
    ln -Fs "${HOME}/opt/fzf/fzf_${FZF_VERSION}" "${HOME}/opt/bin/fzf"
  fi
}
