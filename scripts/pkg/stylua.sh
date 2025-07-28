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
    version="2.1.0"
  fi
  local URL="${URL-https://github.com/JohnnyMorganz/StyLua/releases/download/v${version}/stylua-linux-$(uname -m).zip}"

  # download
  curl -Lo "/tmp/stylua.zip" "${URL}"
  mkdir -p "/tmp/stylua"
  unzip "/tmp/stylua.zip" -d "/tmp/stylua"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i /tmp/stylua/stylua "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/stylua"

  # cleanup
  rm -f /tmp/stylua.zip
  rm -rf /tmp/stylua
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/stylua"
}

main "$@"
