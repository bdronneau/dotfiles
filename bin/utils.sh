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

url_tar() {
    local url="$1"
    local name
    name=$(basename "$1")
    local archive_bin="$2"
    local output="$3"
    local tmp_dir="${HOME}/opt/tmp/${name}"

    if [[ -d "${tmp_dir}" ]]; then
        rm -rdi "${tmp_dir}"
    fi

    mkdir "${tmp_dir}"
    pushd "${tmp_dir}" || exit

    download "$url" "${tmp_dir}/archive.tar.gz"
    tar -xzf "${tmp_dir}/archive.tar.gz"
    mv "${archive_bin}" "${output}"

    popd || exit

    rm -Rf "${tmp_dir}"
}

# Logging stuff.
function print_debug() {
    if [[ "${DOTFILES_DEBUG:-}" == "true" ]]; then
    echo -e " \033[1;37m🔍\033[0m  $*";
    fi
}

print_title() {
  local line="--------------------------------------------------------------------------------"

  printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
  printf "%s%s%s\n" "| " "${1}" " |"
  printf "%s%s%s\n" "+-" "${line:0:${#1}}" "-+"
}

get_arch() {
    local ARCH
    ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')

    local X86_OVERRIDE="${1-}"
    shift || true

    local ARM_OVERRIDE="${1-}"
    shift || true

    if [[ -n "${X86_OVERRIDE}" && "${ARCH}" == "x86_64" ]]; then
        printf -- "%s" "${X86_OVERRIDE}"
    elif [[ -n "${ARM_OVERRIDE}" && "${ARCH}" == "arm64" ]]; then
        printf -- "%s" "${ARM_OVERRIDE}"
    else
        printf -- "%s" "${ARCH}"
    fi
}

get_os() {
    local OS
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')

    printf -- "%s" "${OS}"
}

get_os_name() {
    local OS_NAME

    if [[ "$(get_os)" == "darwin" ]]; then
      OS_NAME="apple"
    elif [[ "$(get_os)" == "linux" ]]; then
      OS_NAME="linux"
    fi

    printf -- "%s" "${OS_NAME}"
}
