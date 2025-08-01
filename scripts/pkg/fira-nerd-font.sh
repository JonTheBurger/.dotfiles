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
    version="3.4.0"
  fi
  local URL="${URL-https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FiraMono.zip}"
  mkdir -p "${HOME}/.local/share/fonts"
  curl -Lo "/tmp/fira-nerd.zip" "${URL}"
  unzip "/tmp/fira-nerd.zip" '*.otf' -d "${HOME}/.local/share/fonts"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/share/fonts/"FiraMonoNerdFont*
}

main "$@"
