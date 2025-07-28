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
    version="0.53.0"
  fi
  local URL="${URL-https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/lazygit.tar.gz" "${URL}"
  mkdir -p "/tmp/lazygit"
  tar -xf "/tmp/lazygit.tar.gz" -C "/tmp/lazygit"

  # exe
  mv -i "/tmp/lazygit/lazygit" "${HOME}/.local/bin/lazygit"
  chmod +x "${HOME}/.local/bin/lazygit"

  # cleanup
  rm -rf /tmp/lazygit
  rm -f /tmp/lazygit.tar.gz
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/lazygit"
}

main "$@"
