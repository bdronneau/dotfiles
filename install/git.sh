#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

install() {
  if command -v git > /dev/null 2>&1; then
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    download "https://raw.githubusercontent.com/git/git/v$(git --version | awk '{print $3}')/contrib/completion/git-prompt.sh" "${SCRIPT_DIR}/../sources/git-prompt"
    mkdir -p "${HOME}/opt/bash-completion.d"
    download "https://raw.githubusercontent.com/git/git/v$(git --version | awk '{print $3}')/contrib/completion/git-completion.bash" "${HOME}/opt/bash-completion.d/git"
  fi

  # renovate: datasource=github-tags depName=dandavison/delta
  local DELTA_VERSION="0.15.1"
  local DELTA_ARCHIVE="delta-${DELTA_VERSION}-x86_64"

  if [[ ${OSTYPE} =~ ^darwin ]]; then
    DELTA_ARCHIVE+="-apple-darwin"
  else
    DELTA_ARCHIVE+="-unknown-linux-musl"
  fi

  download "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${DELTA_ARCHIVE}.tar.gz" "${DELTA_ARCHIVE}.tar.gz"
  tar xzf "${DELTA_ARCHIVE}.tar.gz"
  mv "${DELTA_ARCHIVE}/delta" "${HOME}/opt/bin/delta"
  rm -rf "${DELTA_ARCHIVE}.tar.gz" "${DELTA_ARCHIVE}"
}
