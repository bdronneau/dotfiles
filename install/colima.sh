#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v brew > /dev/null 2>&1; then
    brew install --quiet colima docker docker-buildx
    colima nerdctl install --force --path "${HOME}/opt/bin/nerdctl"
    mkdir -p ~/.docker/cli-plugins
    ln -sfn /opt/homebrew/opt/docker-buildx/bin/docker-buildx ~/.docker/cli-plugins/docker-buildx
  else
    printf "Colima is not handle by this OS\n"
  fi
}
