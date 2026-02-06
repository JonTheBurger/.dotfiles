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
    version="0.67.0"
  fi
  local URL="${URL-https://github.com/junegunn/fzf/releases/download/v${version}/fzf-${version}-linux_amd64.tar.gz}"


  # download
  curl -Lo "/tmp/fzf.tar.gz" "${URL}"
  mkdir -p "/tmp/fzf"
  tar -xf "/tmp/fzf.tar.gz" -C "/tmp/fzf"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/fzf/fzf" "${HOME}/.local/bin/fzf"
  chmod +x "${HOME}/.local/bin/fzf"

  # cleanup
  rm -f /tmp/fzf.tar.gz
  rm -rf /tmp/fzf
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/fzf"
}

main "$@"
