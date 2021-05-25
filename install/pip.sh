#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v pip3 > /dev/null 2>&1; then
    pip3 install -U pip
    pip3 install --user virtualenvwrapper virtualenv==20.0.23
  fi
}
