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
    version="10.3.0"
  fi
  local URL="${URL-https://github.com/sharkdp/fd/releases/download/v${version}/fd-v${version}-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/fd.tar.gz" "${URL}"
  mkdir -p "/tmp/fd"
  tar -xf "/tmp/fd.tar.gz" --strip-components=1 -C "/tmp/fd"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/fd/fd" "${HOME}/.local/bin/fd"
  chmod +x "${HOME}/.local/bin/fd"

  # share
  mkdir -p "${HOME}/.local/share/zsh/completions"
  mv -i "/tmp/fd/autocomplete"/* "${HOME}/.local/share/zsh/completions"
  mkdir -p "${HOME}/.local/share/man/man1"
  mv -i "/tmp/fd/fd.1" "${HOME}/.local/share/man/man1/fd.1"

  # cleanup
  rm -f /tmp/fd.tar.gz
  rm -rf /tmp/fd
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/fd"
}

main "$@"
