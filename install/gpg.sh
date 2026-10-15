#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if [[ "${OSTYPE}" =~ ^darwin ]]; then
    brew install --quiet gnupg pinentry-mac ykman age
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y -qq gnupg scdaemon pcscd yubikey-manager age
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed gnupg pcsclite ccid yubikey-manager age
    sudo systemctl enable --now pcscd.socket
  fi

  if command -v gpg > /dev/null 2>&1; then
    mkdir -p "${HOME}/.gnupg"
    chmod 700 "${HOME}/.gnupg/"

    local AGENT_CONF='enable-ssh-support
default-cache-ttl 60
max-cache-ttl 120'

    if [[ "${OSTYPE}" =~ ^darwin ]]; then
      AGENT_CONF="pinentry-program $(brew --prefix)/bin/pinentry-mac
${AGENT_CONF}"
    fi

    printf '%s\n' "${AGENT_CONF}" > "${HOME}/.gnupg/gpg-agent.conf"

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

    gpgconf --kill gpg-agent
  fi
}
