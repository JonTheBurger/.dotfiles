#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/installer.sh
. "${SCRIPT_DIR}/../detail/installer.sh"

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Installs the package.
## @param $version requested version to install, "latest" by default.
# --------------------------------------------------------------------------------------
local::do_install() {
  if [ "${version}" == "latest" ]; then
    version="0.42.2"
  fi
  local URL="${URL-https://github.com/zellij-org/zellij/releases/download/v${version}/zellij-$(uname -m)-unknown-linux-musl.tar.gz}"

  # download
  curl -Lo "/tmp/zellij.tar.gz" "${URL}"
  mkdir -p "/tmp/zellij"
  tar -xf "/tmp/zellij.tar.gz" -C "/tmp/zellij"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/zellij/zellij" "${HOME}/.local/bin/zellij"
  chmod +x "${HOME}/.local/bin/zellij"

  # cleanup
  rm -f /tmp/zellij.tar.gz
  rm -rf /tmp/zellij
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/zellij"
}

main "$@"
