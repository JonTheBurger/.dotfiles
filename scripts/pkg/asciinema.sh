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
    version="3.1.0"
  fi
  local URL="${URL-https://github.com/asciinema/asciinema/releases/download/v${version}/asciinema-$(uname -m)-unknown-linux-gnu}"

  # download
  curl -Lo "/tmp/asciinema" "${URL}"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/asciinema" "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/asciinema"

  # cleanup
  rm -f /tmp/asciinema
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/asciinema"
}

main "$@"
