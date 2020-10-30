#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

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
  local N_VERSION=6.7.0
  if [[ ! -f "${HOME}/opt/n/n_${N_VERSION}.sh" ]]; then
    mkdir -p "${HOME}/opt/n"

    curl -q -sSL --max-time 300 "https://raw.githubusercontent.com/tj/n/v${N_VERSION}/bin/n" -o "${HOME}/opt/n/n_${N_VERSION}.sh"

    # Activate version
    ln -sfn "${HOME}/opt/n/n_${N_VERSION}.sh" "${HOME}/opt/bin/n"
    chmod u+x "${HOME}/opt/bin/n"
  fi
}
