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
    version="25.5.31"
  fi
  local URL="${URL-https://github.com/sxyazi/yazi/releases/download/v${version}/yazi-$(uname -m)-unknown-linux-gnu.zip}"

  # download
  curl -Lo "/tmp/yazi.zip" "${URL}"
  mkdir -p "/tmp/yazi"
  unzip "/tmp/yazi.zip" -d "/tmp/yazi"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i /tmp/yazi/*/ya* "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/ya*"

  # cleanup
  rm -f /tmp/yazi.zip
  rm -rf /tmp/yazi
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/ya"
  rm -rf "${HOME}/.local/bin/yazi"
}

main "$@"
