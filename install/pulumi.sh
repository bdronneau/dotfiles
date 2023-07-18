#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

clean() {
  brew uninstall pulumi
}

install() {
  brew install --quiet pulumi/tap/pulumi
}
