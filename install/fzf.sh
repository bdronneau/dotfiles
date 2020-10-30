#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/opt/bin/fzf"
  rm -rf "${HOME}/opt/fzf"
}

install() {
  local FZF_VERSION=0.24.1
  if [[ ! -f "${HOME}/opt/fzf/fzf_${FZF_VERSION}" ]]; then
    mkdir -p "${HOME}/opt/fzf"

    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    curl -q -sSL --max-time 300 -O "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-${OS}_amd64.tar.gz"
    tar xf "fzf-${FZF_VERSION}-${OS}_amd64.tar.gz"
    rm "fzf-${FZF_VERSION}-${OS}_amd64.tar.gz"
    mv "fzf" "${HOME}/opt/fzf/fzf_${FZF_VERSION}"

    if [[ -f "${HOME}/opt/bin/fzf" ]]; then
      rm -f "${HOME}/opt/bin/fzf"
    fi

    curl -q -sSL --max-time 300 "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION}/shell/completion.bash" -o "${HOME}/opt/bash-completion.d/fzf.completion.bash"
    curl -q -sSL --max-time 300 "https://raw.githubusercontent.com/junegunn/fzf/${FZF_VERSION}/shell/key-bindings.bash" -o "${HOME}/opt/bash-completion.d/fzf.key-bindings.bash"

    # Activate version
    ln -Fs "${HOME}/opt/fzf/fzf_${FZF_VERSION}" "${HOME}/opt/bin/fzf"
  fi
}
