#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
    if command -v gem > /dev/null 2>&1; then
        gem install --user-install tmuxinator
    fi

    if [[ ! -f "${HOME}/opt/bash-completion.d/tmuxinator.bash" ]]; then
        curl -o "${HOME}/opt/bash-completion.d/tmuxinator.bash" "https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash"
    fi
    
}

main