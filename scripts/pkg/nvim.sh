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
    version="0.11.3"
  fi
  local URL="${URL-https://github.com/neovim/neovim/releases/download/v${version}/nvim-linux-$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/nvim.tar.gz" "${URL}"
  mkdir -p "/tmp/nvim"
  tar -xf "/tmp/nvim.tar.gz" --strip-components=1 -C "/tmp/nvim"

  # exe
  mkdir -p "${HOME}/.local/opt"
  mv -i "/tmp/nvim" "${HOME}/.local/opt/nvim"
  mkdir -p "${HOME}/.local/bin"
  ln -s "${HOME}/.local/opt/nvim/bin/nvim" "${HOME}/.local/bin/nvim"
  chmod +x "${HOME}/.local/opt/nvim/bin/nvim"

  # cleanup
  rm -f /tmp/nvim.tar.gz
  rm -rf /tmp/nvim
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/nvim"
  rm -rf "${HOME}/.local/opt/nvim"
}

main "$@"
