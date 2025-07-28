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
    version="1.23.0"
  fi
  local URL="${URL-https://github.com/starship/starship/releases/download/v${version}/starship-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/starship.tar.gz" "${URL}"
  mkdir -p "/tmp/starship"
  tar -xf "/tmp/starship.tar.gz" -C "/tmp/starship"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/starship/starship" "${HOME}/.local/bin/starship"
  chmod +x "${HOME}/.local/bin/starship"

  # cleanup
  rm -f /tmp/starship.tar.gz
  rm -rf /tmp/starship
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/starship"
}

main "$@"
