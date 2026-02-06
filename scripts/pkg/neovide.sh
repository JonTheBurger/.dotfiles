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
    version="0.15.2"
  fi
  local URL="${URL-https://github.com/neovide/neovide/releases/download/${version}/neovide-linux-$(uname -m).tar.gz}"

  # download
  curl -Lo "/tmp/neovide.tar.gz" "${URL}"
  mkdir -p "/tmp/neovide"
  tar -xf "/tmp/neovide.tar.gz" -C "/tmp/neovide"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mv -i "/tmp/neovide/neovide" "${HOME}/.local/bin/neovide"
  chmod +x "${HOME}/.local/bin/neovide"

  # destop
  cat<< EOF > "${HOME}/.local/share/applications/neovide.desktop"
[Desktop Entry]
Type=Application
Exec=neovide %F
Icon=neovide
Name=Neovide
Keywords=Text;Editor;
Categories=Utility;TextEditor;
Comment=No Nonsense Neovim Client in Rust
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
EOF
  chmod +x "${HOME}/.local/share/applications/neovide.desktop"

  # cleanup
  rm -f /tmp/neovide.tar.gz
  rm -rf /tmp/neovide
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/neovide"
  rm -rf "${HOME}/.local/share/applications/neovide.desktop"
}

main "$@"

