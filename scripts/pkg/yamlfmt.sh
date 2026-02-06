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
    version="0.21.0"
  fi
  local URL="${URL-https://github.com/google/yamlfmt/releases/download/v${version}/yamlfmt_${version}_Linux_$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/yamlfmt.tar.gz" "${URL}"
  mkdir -p "/tmp/yamlfmt"
  tar -xf "/tmp/yamlfmt.tar.gz" -C "/tmp/yamlfmt"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/yamlfmt/yamlfmt" "${HOME}/.local/bin/yamlfmt"
  chmod +x "${HOME}/.local/bin/yamlfmt"

  # cleanup
  rm -f /tmp/yamlfmt.tar.gz
  rm -rf /tmp/yamlfmt
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/yamlfmt"
}

main "$@"
