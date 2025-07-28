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
    version="0.31.0"
  fi
  local URL="${URL-https://github.com/jj-vcs/jj/releases/download/v${version}/jj-v${version}-$(uname -m)-unknown-linux-musl.tar.gz}"

  # download
  curl -Lo "/tmp/jj.tar.gz" "${URL}"
  mkdir -p "/tmp/jj"
  tar -xf "/tmp/jj.tar.gz" -C "/tmp/jj"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/jj/jj" "${HOME}/.local/bin/jj"
  chmod +x "${HOME}/.local/bin/jj"

  # cleanup
  rm -f /tmp/jj.tar.gz
  rm -rf /tmp/jj
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -f "${HOME}/.local/bin/jj"
}

main "$@"
