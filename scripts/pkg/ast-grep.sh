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
    version="0.40.5"
  fi
  local URL="${URL-https://github.com/ast-grep/ast-grep/releases/download/${version}/app-$(uname -m)-unknown-linux-gnu.zip}"

  # download
  curl -Lo "/tmp/ast-grep.zip" "${URL}"
  mkdir "/tmp/ast-grep"
  unzip "/tmp/ast-grep.zip" -d "/tmp/ast-grep"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/ast-grep/ast-grep" "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/ast-grep"
  mv -i "/tmp/ast-grep/sg" "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/sg"

  # cleanup
  rm -rf /tmp/ast-grep.zip
  rm -rf /tmp/ast-grep
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/ast-grep"
  rm -rf "${HOME}/.local/bin/sg"
}

main "$@"
