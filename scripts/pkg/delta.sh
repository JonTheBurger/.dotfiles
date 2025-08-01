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
    version="0.18.2"
  fi
  local URL="${URL-https://github.com/dandavison/delta/releases/download/${version}/delta-${version}-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/delta.tar.gz" "${URL}"
  mkdir -p "/tmp/delta"
  tar -xf "/tmp/delta.tar.gz" --strip-components=1 -C "/tmp/delta"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/delta/delta" "${HOME}/.local/bin/delta"
  chmod +x "${HOME}/.local/bin/delta"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/delta"
}

main "$@"
