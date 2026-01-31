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
    version="1.18"
  fi
  local URL="${URL-https://www.fastbuild.org/downloads/v${version}/FASTBuild-Linux-x64-v${version}.zip}"

  # download
  curl -Lo "/tmp/FASTBuild.zip" "${URL}"
  mkdir -p "/tmp/FASTBuild"
  unzip "/tmp/FASTBuild.zip" -d "/tmp/FASTBuild"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/FASTBuild/fbuild"* "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/fbuild"*

  # cleanup
  rm -f /tmp/FASTBuild.zip
  rm -rf /tmp/FASTBuild
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/fbuild"
  rm -rf "${HOME}/.local/bin/fbuildworker"
}

main "$@"
