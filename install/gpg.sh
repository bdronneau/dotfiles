#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if [[ "${OSTYPE}" =~ ^darwin ]]; then
    brew install --quiet gnupg
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq gnupg
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed gnupg
  fi

  if command -v gpg > /dev/null 2>&1; then
    mkdir -p "${HOME}/.gnupg"
    chmod 700 "${HOME}/.gnupg/"

    echo 'enable-ssh-support
  default-cache-ttl 43200
  max-cache-ttl 43200' > "${HOME}/.gnupg/gpg-agent.conf"

    echo 'personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
require-cross-certification
use-agent' > "${HOME}/.gnupg/gpg.conf"
  fi
}
