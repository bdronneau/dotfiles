#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  rm -rf "${HOME}/opt/bin/fzf"
  rm -rf "${HOME}/opt/fzf"
}

install() {
  local FZF_VERSION=0.28.0
  if [[ ! -f "${HOME}/opt/fzf/fzf_${FZF_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/fzf"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    local EXT
    EXT="tar.gz"

    if [ "${OS}" = "darwin" ]; then
        EXT="zip"
    fi

    download "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-${OS}_amd64.${EXT}" "fzf-${FZF_VERSION}-${OS}_amd64.${EXT}"

    if [ "${EXT}" = "tar.gz" ]; then
      tar xf "fzf-${FZF_VERSION}-${OS}_amd64.${EXT}"
    else
      unzip "fzf-${FZF_VERSION}-${OS}_amd64.${EXT}"
    fi

    mv "fzf" "${HOME}/opt/fzf/fzf_${FZF_VERSION}"
    rm "fzf-${FZF_VERSION}-${OS}_amd64.${EXT}"

    if [[ -f "${HOME}/opt/bin/fzf" ]]; then
      rm -f "${HOME}/opt/bin/fzf"
    fi

    download "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION}/shell/completion.bash" "${HOME}/opt/bash-completion.d/fzf.completion.bash"
    download "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION}/shell/key-bindings.bash" "${HOME}/opt/bash-completion.d/fzf.key-bindings.bash"

    # Activate version
    ln -Fs "${HOME}/opt/fzf/fzf_${FZF_VERSION}" "${HOME}/opt/bin/fzf"
  fi
}
