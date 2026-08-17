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
    version="0.41.0"
  fi
  local URL="${URL-https://github.com/lumen-oss/lux/releases/download/v${version}/lx_${version}_$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/lx.tar.gz" "${URL}"
  tar -xf "/tmp/lx.tar.gz" --strip-components=1 -C "${HOME}/.local"

  # cleanup
  rm -f /tmp/lx.tar.gz
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -f "${HOME}/.local/bin/lx"
  rm -rf "${HOME}/.local/share/lux-lua"
  rm -rf "${HOME}/.local/lib/lux-lua"*
}

main "$@"
