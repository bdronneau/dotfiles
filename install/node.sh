#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  if command -v npm > /dev/null 2>&1; then
    npm cache clean --force
  fi

  rm -rf "${HOME}/.babel.json"
  rm -rf "${HOME}/.node-gyp"
  rm -rf "${HOME}/.node_repl_history"
  rm -rf "${HOME}/.npm"
  rm -rf "${HOME}/.v8flags."*
  rm -rf "${HOME}/opt/n"
}

install() {
  # renovate: datasource=github-tags depName=tj/n
  local N_VERSION="v9.1.0"
  if [[ ! -f "${HOME}/opt/n/n_${N_VERSION}.sh" ]]; then
    mkdir -p "${HOME}/opt/n"
    mkdir -p "${HOME}/opt/n/node"

    download "https://raw.githubusercontent.com/tj/n/${N_VERSION}/bin/n" "${HOME}/opt/n/n_${N_VERSION}.sh"

    # Activate version
    ln -sfn "${HOME}/opt/n/n_${N_VERSION}.sh" "${HOME}/opt/bin/n"
    chmod u+x "${HOME}/opt/bin/n"
  fi
}
