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
    version="0.63.2"
  fi
  local URL="${URL-https://github.com/prefix-dev/pixi/releases/download/v${version}/pixi-$(uname -m)-unknown-linux-musl.tar.gz}"

  # download
  curl -Lo "/tmp/pixi.tar.gz" "${URL}"
  mkdir -p "/tmp/pixi"
  tar -xf "/tmp/pixi.tar.gz" -C "/tmp/pixi"

  # exe
  mv -i "/tmp/pixi/pixi" "${HOME}/.local/bin/pixi"
  chmod +x "${HOME}/.local/bin/pixi"

  # cleanup
  rm -rf /tmp/pixi
  rm -f /tmp/pixi.tar.gz
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/pixi"
}

main "$@"
