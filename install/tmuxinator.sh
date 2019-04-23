#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
    if command -v gem > /dev/null 2>&1; then
        return
    fi

    if command -v tmuxinator > /dev/null 2>&1; then
        # Lock to 0.15.0 because OS X use ruby 2.3.X
        gem install --user-install tmuxinator -v 0.15.0
    fi

    if [[ ! -f "${HOME}/opt/bash-completion.d/tmuxinator.bash" ]]; then
        curl -o "${HOME}/opt/bash-completion.d/tmuxinator.bash" "https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash"
    fi
}

main