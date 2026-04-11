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
    version="0.68.0"
  fi
  local URL="${URL-https://github.com/Wilfred/difftastic/releases/download/${version}/difft-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/difft.tar.gz" "${URL}"
  mkdir -p "/tmp/difft"
  tar -xf "/tmp/difft.tar.gz" -C "/tmp/difft"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/difft/difft" "${HOME}/.local/bin/difft"
  chmod +x "${HOME}/.local/bin/difft"

  # cleanup
  rm -f /tmp/difft.tar.gz
  rm -rf /tmp/difft
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/difft"
}

main "$@"
