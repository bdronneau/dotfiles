#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../bin/utils.sh"

APP_NAME="gh"
APP_BIN_NAME="${APP_NAME}"
APP_BASE_PATH="${HOME}/opt/${APP_NAME}"
APP_BIN_PATH="${HOME}/opt/bin/${APP_BIN_NAME}"

clean() {
  rm -rf "${APP_BIN_PATH}"
  rm -rf "${APP_BASE_PATH}"
  rm -f "${HOME}/opt/bash-completion.d/gh"
}

install() {
  # renovate: datasource=github-tags depName=cli/cli
  local APP_VERSION_TAG="v2.102.0"
  local APP_VERSION="${APP_VERSION_TAG/v/}"
  local APP_BIN_VERSION_PATH="${APP_BASE_PATH}/${APP_BIN_NAME}_${APP_VERSION}"
  local RELEASE_URL="https://github.com/cli/cli/releases/download/${APP_VERSION_TAG}"
  local CHECKSUMS_URL="${RELEASE_URL}/gh_${APP_VERSION}_checksums.txt"

  if [[ ! -f "${APP_BIN_VERSION_PATH}" ]]; then
    mkdir -p "${APP_BASE_PATH}"
    mkdir -p "${HOME}/opt/bash-completion.d"

    local ARCHIVE_NAME
    if [[ "$(get_os)" == "darwin" ]]; then
      # macOS releases are only published as zip, url_tar can't handle them
      ARCHIVE_NAME="gh_${APP_VERSION}_macOS_$(get_arch amd64)"

      local TMP_DIR="${HOME}/opt/tmp/${ARCHIVE_NAME}"
      rm -rf "${TMP_DIR}"
      mkdir -p "${TMP_DIR}"

      download "${RELEASE_URL}/${ARCHIVE_NAME}.zip" "${TMP_DIR}/${ARCHIVE_NAME}.zip" "${CHECKSUMS_URL}"
      unzip -q "${TMP_DIR}/${ARCHIVE_NAME}.zip" -d "${TMP_DIR}"
      mv "${TMP_DIR}/${ARCHIVE_NAME}/bin/gh" "${APP_BIN_VERSION_PATH}"
      rm -rf "${TMP_DIR}"
    else
      ARCHIVE_NAME="gh_${APP_VERSION}_$(get_os)_$(get_arch amd64 arm64)"

      url_tar "${RELEASE_URL}/${ARCHIVE_NAME}.tar.gz" "${ARCHIVE_NAME}/bin/gh" "${APP_BIN_VERSION_PATH}" "${CHECKSUMS_URL}"
    fi
    chmod u+x "${APP_BIN_VERSION_PATH}"

    [[ -f "${APP_BIN_PATH}" ]] && rm -f "${APP_BIN_PATH}"

    # Activate version
    ln -Fs "${APP_BIN_VERSION_PATH}" "${APP_BIN_PATH}"

    "${APP_BIN_PATH}" completion -s bash > "${HOME}/opt/bash-completion.d/gh"
  fi
}
