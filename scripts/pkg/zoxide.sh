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
    version="0.9.8"
  fi
  local URL="${URL-https://github.com/ajeetdsouza/zoxide/releases/download/v${version}/zoxide-${version}-$(uname -m)-unknown-linux-musl.tar.gz}"

  # download
  curl -Lo "/tmp/zoxide.tar.gz" "${URL}"
  mkdir -p "/tmp/zoxide"
  tar -xf "/tmp/zoxide.tar.gz" -C "/tmp/zoxide"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/zoxide/zoxide" "${HOME}/.local/bin/zoxide"
  chmod +x "${HOME}/.local/bin/zoxide"

  # cleanup
  rm -f /tmp/zoxide.tar.gz
  rm -rf /tmp/zoxide
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -f "${HOME}/.local/bin/zoxide"
}

main "$@"
