#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SYMLINK_PATH="${HOME}"

main() {
  echo '+----------+'
  echo '| symlinks |'
  echo '+----------+'
  for file in "${SCRIPT_DIR}/symlinks"/*; do
    basenameFile=$(basename "${file}")
    [ -r "${file}" ] && [ -e "${file}" ] && rm -f "${SYMLINK_PATH}/.${basenameFile}" && ln -s "${file}" "${SYMLINK_PATH}/.${basenameFile}"
  done

  set +u
  set +e
  PS1='$' source "${SYMLINK_PATH}/.bashrc"
  set -e
  set -u

  LC_ALL="C"
  LANG="C"

  local line='--------------------------------------------------------------------------------'

  for file in "${SCRIPT_DIR}/install"/*; do
    local basenameFile=$(basename ${file%.*})
    printf "%s%s%s\n" "+-" "${line:0:${#basenameFile}}" "-+"
    printf "%s%s%s\n" "| " ${basenameFile} " |"
    printf "%s%s%s\n" "+-" "${line:0:${#basenameFile}}" "-+"

    [ -r "${file}" ] && [ -x "${file}" ] && "${file}"
  done

  echo '+---------+'
  echo '| cleanup |'
  echo '+---------+'
  if [[ "${OSTYPE}" =~ ^darwin ]]; then
    brew cleanup
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get autoremove -y
    sudo apt-get clean all
  fi
}

main
