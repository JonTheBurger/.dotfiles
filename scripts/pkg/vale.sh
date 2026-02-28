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
    version="3.13.1"
  fi
  local URL="${URL-https://github.com/errata-ai/vale/releases/download/v${version}/vale_${version}_Linux_64-bit.tar.gz}"

  # download
  curl -Lo "/tmp/vale.tar.gz" "${URL}"
  mkdir -p "/tmp/vale"
  tar -xf "/tmp/vale.tar.gz" -C "/tmp/vale"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/vale/vale" "${HOME}/.local/bin/vale"
  chmod +x "${HOME}/.local/bin/vale"
  "${HOME}/.local/bin/vale" sync

  # cleanup
  rm -f /tmp/vale.tar.gz
  rm -rf /tmp/vale
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -f "${HOME}/.local/bin/vale"
}

main "$@"
