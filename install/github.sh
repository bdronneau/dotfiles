#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

install() {
    if command -v brew > /dev/null 2>&1; then
            brew install gh
    elif command -v apt-get > /dev/null 2>&1; then
        curl -o /usr/share/keyrings/githubcli-archive-keyring.gpg -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y
    fi

    gh completion -s bash > "${HOME}/opt/bash-completion.d/gh"

    if [ -z "${GITHUB_TOKEN}" ]
    then
        echo "No GITHUB_TOKEN skip extension installation"
    else
        gh extension install dlvhdr/gh-dash --force
        gh extension install rsese/gh-actions-status --force
    fi
}
