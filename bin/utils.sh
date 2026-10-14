#!/usr/bin/env bash

# download <url> <output> [integrity]
#
# integrity is optional and is either a literal sha256 or the URL of a checksums
# file published alongside the artifact. See verify_integrity.
download() {
    local url="$1"
    local output="$2"
    local integrity="${3-}"
    local status=0

    if command -v "curl" &> /dev/null; then

        print_debug "Download with: curl --max-time 300 -fLsSo ${output} ${url}"

        curl --max-time 300 -fLsSo "$output" "$url" || status=$?
        #                    ││││└─ write output to file
        #                    │││└─ show error messages
        #                    ││└─ don't show the progress meter
        #                    │└─ follow redirects
        #                    └─ fail on HTTP errors instead of saving the error page

    elif command -v "wget" &> /dev/null; then

        print_debug "Download with: wget -qO ${output} ${url}"

        wget -qO "$output" "$url" || status=$?
        #    │└─ write output to file
        #    └─ don't show output

    else
        printf "No tool for exec download\n"

        return 1
    fi

    # Never keep the output of a failed download: wget -O creates the file before it
    # knows the request failed, and curl can leave a partial file on a timeout. Every
    # install script guards on file existence, so leftovers look installed forever.
    if [[ ${status} -ne 0 ]]; then
        rm -f "${output}"
        printf "Failed to download %s (exit %s)\n" "${url}" "${status}" >&2

        return "${status}"
    fi

    if [[ -n ${integrity} ]]; then
        # basename of the url is the upstream asset name, which is what the
        # checksums file is keyed on.
        if ! verify_integrity "${output}" "${integrity}" "$(basename "${url}")"; then
            rm -f "${output}"

            return 1
        fi
    fi

    return 0
}

# url_tar <url> <bin_in_archive> <output> [integrity]
#
# integrity is passed through to download and is checked against the archive
# before anything is extracted from it.
url_tar() {
    local url="$1"
    local name
    name=$(basename "$1")
    local archive_bin="$2"
    local output="$3"
    local integrity="${4-}"
    local tmp_dir="${HOME}/opt/tmp/${name}"

    if [[ -d "${tmp_dir}" ]]; then
        rm -rf "${tmp_dir}"
    fi

    mkdir "${tmp_dir}"
    pushd "${tmp_dir}" || exit

    if ! download "$url" "${tmp_dir}/archive.tar.gz" "${integrity}"; then
        popd || exit
        rm -Rf "${tmp_dir}"

        return 1
    fi

    tar -xzf "${tmp_dir}/archive.tar.gz"
    mv "${archive_bin}" "${output}"

    popd || exit

    rm -Rf "${tmp_dir}"
}

# sha256_of <file> -- print the sha256 of a file
sha256_of() {
    local file="$1"

    if command -v shasum &> /dev/null; then
        shasum -a 256 "${file}" | awk '{ print $1 }'
    elif command -v sha256sum &> /dev/null; then
        sha256sum "${file}" | awk '{ print $1 }'
    else
        printf "No tool for sha256\n" >&2

        return 1
    fi
}

# sums_lookup <sums_file> <name> -- print the sha256 recorded for <name>
#
# Handles the three shapes upstreams publish: "<hash>  <name>" (checksums.txt,
# SHA256SUMS, sha256sum.txt), "<hash> *<name>" and single bare-hash files.
sums_lookup() {
    local sums_file="$1"
    local name="$2"
    local hash

    if [[ $(wc -w < "${sums_file}") -eq 1 ]]; then
        hash="$(tr -d '[:space:]' < "${sums_file}")"
    else
        hash="$(awk -v n="${name}" '{ f=$2; sub(/^\*/, "", f); if (f == n) { print $1; exit } }' "${sums_file}")"
    fi

    if [[ ! ${hash} =~ ^[0-9a-fA-F]{64}$ ]]; then
        printf "No sha256 recorded for %s\n" "${name}" >&2

        return 1
    fi

    printf -- "%s" "${hash}"
}

# verify_sha256 <file> <expected>
verify_sha256() {
    local file="$1"
    local expected="$2"
    local actual

    actual="$(sha256_of "${file}")" || return 1

    # tr instead of ${var,,} to stay compatible with bash 3.2
    actual="$(printf -- "%s" "${actual}" | tr '[:upper:]' '[:lower:]')"
    expected="$(printf -- "%s" "${expected}" | tr '[:upper:]' '[:lower:]')"

    if [[ "${actual}" != "${expected}" ]]; then
        printf "Checksum MISMATCH for %s\n  expected %s\n  actual   %s\n" "${file}" "${expected}" "${actual}" >&2

        return 1
    fi

    print_debug "Checksum OK ${file} (${actual})"

    return 0
}

# verify_integrity <file> <integrity> [name]
#
# integrity is either a literal sha256 or the URL of a checksums file. Fetching the
# checksums from the upstream release keeps nothing to maintain here: renovate bumps
# the version, the checksums URL follows it. That protects against a corrupted or
# truncated transfer and against fetching the wrong asset -- not against a
# compromised release, which needs signature verification instead.
verify_integrity() {
    local file="$1"
    local integrity="$2"
    local name="${3:-$(basename "${file}")}"
    local sums expected

    if [[ ${integrity} =~ ^[0-9a-fA-F]{64}$ ]]; then
        verify_sha256 "${file}" "${integrity}"

        return $?
    fi

    sums="$(mktemp)"

    if ! download "${integrity}" "${sums}"; then
        rm -f "${sums}"

        return 1
    fi

    if ! expected="$(sums_lookup "${sums}" "${name}")"; then
        rm -f "${sums}"

        return 1
    fi

    rm -f "${sums}"

    verify_sha256 "${file}" "${expected}"
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
