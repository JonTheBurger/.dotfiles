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
    version="2026.2.5"
  fi
  local URL="${URL-https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-x64.tar.xz}"

  # download
  curl -Lo "/tmp/mise.tar.xz" "${URL}"
  mkdir -p "/tmp/mise"
  tar -xf "/tmp/mise.tar.xz" --strip-components=1 -C "/tmp/mise"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/mise/"* "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/mise"*

  # share
  mkdir -p "${HOME}/.local/share/fish/vendor_conf.d"
  mv -i "/tmp/mise/share/fish/vendor_conf.d/"* "${HOME}/.local/share/fish/vendor_conf.d/"

  # man
  mkdir -p "${HOME}/.local/man/man1"
  cp -r "/tmp/mise/man/"* "${HOME}/.local/man/"

  # cleanup
  rm -f /tmp/mise.tar.xz
  rm -rf /tmp/mise
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/mise"
  rm -rf "${HOME}/.local/bin/mise.d"
  rm -rf "${HOME}/.local/share/fish/vendor_conf.d/mise-activate.fish"
  rm -rf "${HOME}/.local/man/man1/mise.1"
}

main "$@"
