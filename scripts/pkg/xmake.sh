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
    version="3.0.6"
  fi
  local URL="${URL-https://github.com/xmake-io/xmake/releases/download/v${version}/xmake-bundle-v${version}3.0.6.linux.$(uname -m)}"

  mkdir -p "${HOME}/.local/bin"
  curl -Lo "${HOME}/.local/bin/xmake" "${URL}"
  chmod +x "${HOME}/.local/bin/xmake"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/xmake"
}

main "$@"
