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
    version="0.11.0"
  fi
  local URL="${URL-https://github.com/arm/armls/releases/download/v${version}/armls-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/armls.tar.gz" "${URL}"
  mkdir -p "/tmp/armls"
  tar -xf "/tmp/armls.tar.gz" -C "/tmp/armls"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/armls/armls" "${HOME}/.local/bin/armls"
  chmod +x "${HOME}/.local/bin/armls"

  # cleanup
  rm -f /tmp/armls.tar.gz
  rm -rf /tmp/armls
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/armls"
}

main "$@"
