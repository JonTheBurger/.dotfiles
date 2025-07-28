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
    version="1.1.3"
  fi
  local URL="${URL-https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v${version}/Ghostty-${version}-$(uname -m).AppImage}"

  # download
  curl -Lo "/tmp/ghostty" "${URL}"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/ghostty" "${HOME}/.local/bin/ghostty"
  chmod +x "${HOME}/.local/bin/ghostty"

  # desktop
  cat <<EOF > "${HOME}/.local/share/applications/ghostty.desktop"
[Desktop Entry]
Version=${version}
Type=Application
Name=Ghostty
GenericName=Terminal Emulator
Comment=Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.
Exec=ghostty
Icon=com.mitchellh.ghostty
Categories=System;TerminalEmulator;
X-TerminalArgExec=--
X-TerminalArgTitle=--title
X-TerminalArgAppId=--class
X-TerminalArgDir=--working-directory
X-TerminalArgHold=--hold
EOF

  # cleanup
  rm -rf /tmp/ghostty
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/ghostty"
  rm -rf "${HOME}/.local/share/applications/ghostty.desktop"
}

main "$@"
