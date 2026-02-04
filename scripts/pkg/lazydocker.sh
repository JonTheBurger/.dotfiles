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
    version="0.24.4"
  fi
  local URL="${URL-https://github.com/jesseduffield/lazydocker/releases/download/v${version}/lazydocker_${version}_Linux_$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/lazydocker.tar.gz" "${URL}"
  mkdir -p "/tmp/lazydocker"
  tar -xf "/tmp/lazydocker.tar.gz" -C "/tmp/lazydocker"

  # exe
  mv -i "/tmp/lazydocker/lazydocker" "${HOME}/.local/bin/lazydocker"
  chmod +x "${HOME}/.local/bin/lazydocker"

  # cleanup
  rm -rf /tmp/lazydocker
  rm -f /tmp/lazydocker.tar.gz
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/lazydocker"
}

main "$@"
