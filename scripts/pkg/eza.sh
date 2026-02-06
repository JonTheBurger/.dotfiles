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
    version="0.23.4"
  fi
  local URL="${URL-https://github.com/eza-community/eza/releases/download/v${version}/eza_$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/eza.tar.gz" "${URL}"
  mkdir -p "/tmp/eza"
  tar -xf "/tmp/eza.tar.gz" -C "/tmp/eza"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/eza/eza" "${HOME}/.local/bin/eza"
  chmod +x "${HOME}/.local/bin/eza"

  # cleanup
  rm -f /tmp/eza.tar.gz
  rm -rf /tmp/eza

  # download 2
  local URL2="${URL2-https://github.com/eza-community/eza/releases/download/v${version}/completions-${version}.tar.gz}"
  curl -Lo "/tmp/eza-cmp.tar.gz" "${URL2}"
  mkdir -p "/tmp/eza-cmp"
  tar -xf "/tmp/eza-cmp.tar.gz" -C "/tmp/eza-cmp"

  # share
  mkdir -p "${HOME}/.local/share/zsh/completions"
  mv -i "/tmp/eza-cmp/target/completions-${version}"/* "${HOME}/.local/share/zsh/completions"

  # cleanup 2
  rm -f /tmp/eza-cmp.tar.gz
  rm -rf /tmp/eza-cmp
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/eza"
}

main "$@"
