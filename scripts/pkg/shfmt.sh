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
  local URL="${URL-https://github.com/patrickvane/shfmt/releases/download/master/shfmt_linux_amd64}"

  # download
  mkdir -p "${HOME}/.local/bin"
  curl -Lo "${HOME}/.local/bin/shfmt" "${URL}"
  chmod +x "${HOME}/.local/bin/shfmt"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/shfmt"
}

main "$@"
