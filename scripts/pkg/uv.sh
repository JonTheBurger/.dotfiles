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
    version="0.8.3"
  fi
  local URL="${URL-https://github.com/astral-sh/uv/releases/download/${version}/uv-$(uname -m)-unknown-linux-gnu.tar.gz}"

  # download
  curl -Lo "/tmp/uv.tar.gz" "${URL}"
  mkdir -p "/tmp/uv"
  tar -xf "/tmp/uv.tar.gz" --strip-components=1 -C "/tmp/uv"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/uv/uv" "${HOME}/.local/bin/uv"
  chmod +x "${HOME}/.local/bin/uv"
  mv -i "/tmp/uv/uvx" "${HOME}/.local/bin/uvx"
  chmod +x "${HOME}/.local/bin/uvx"

  # cleanup
  rm -f /tmp/uv.tar.gz
  rm -rf /tmp/uv
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/uv"
  rm -rf "${HOME}/.local/bin/uvx"
}

main "$@"
