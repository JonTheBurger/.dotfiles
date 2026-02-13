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
    version="0.16.0"
  fi
  local URL="${URL-https://github.com/jetify-com/devbox/releases/download/0.16.0/devbox_0.16.0_linux_amd64.tar.gz}"

  # download
  curl -Lo "/tmp/devbox.tar.gz" "${URL}"
  mkdir -p "/tmp/devbox"
  tar -xf "/tmp/devbox.tar.gz" -C "/tmp/devbox"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/devbox/devbox" "${HOME}/.local/bin/devbox"
  chmod +x "${HOME}/.local/bin/devbox"

  # cleanup
  rm -f /tmp/devbox.tar.gz
  rm -rf /tmp/devbox
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/devbox"
}

main "$@"
