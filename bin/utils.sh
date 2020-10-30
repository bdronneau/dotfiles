#!/usr/bin/env bash

download() {
    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then

        cmd="curl --max-time 300 -LsSo \"$output\" \"$url\" &> /dev/null"
        #                         │││└─ write output to file
        #                         ││└─ show error messages
        #                         │└─ don't show the progress meter
        #                         └─ follow redirects

        print_debug "Download with: ${cmd}"

        eval "${cmd}"

        return $?

    elif command -v "wget" &> /dev/null; then

        cmd="wget -qO \"$output\" \"$url\" &> /dev/null"
        #     │└─ write output to file
        #     └─ don't show output

        print_debug "Download with: ${cmd}"

        eval "${cmd}"

        return $?
    fi

    printf "No tool for exec download\n"

    return 1
}

# Logging stuff.
function print_debug()    {
    if [[ -n "${DOTFILES_DEBUG}" ]] && [[ "${DOTFILES_DEBUG}" == "true" ]]; then
    echo -e " \033[1;37m🔍\033[0m  $*";
    fi
}

print_title() {
  local line="--------------------------------------------------------------------------------"

  printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
  printf "%s%s%s\n" "| " "${1}" " |"
  printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
}
