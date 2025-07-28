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
  local URL="${URL-https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh}"
  if [ ! -f "${HOME}/.local/bin/fzf-git.sh" ]; then
    curl -Lo "${HOME}/.local/bin/fzf-git.sh" "${URL}"
  fi
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/fzf-git.sh"
}

main "$@"
