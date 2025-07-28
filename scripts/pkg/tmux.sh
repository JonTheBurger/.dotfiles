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
  mkdir -p "${HOME}/.local/share/tmux/plugins"

  declare -a PKGS_APT
  PKGS_APT+=(tmux)
  PKGS_APT+=(ruby)
  util::apt_install "${PKGS_APT[@]}"

  declare -a PKGS_DNF
  PKGS_DNF+=(tmux)
  PKGS_DNF+=(ruby)
  util::dnf_install "${PKGS_DNF[@]}"

  if [ ! -d "${HOME}/.local/share/tmux/plugins/tmux-jump" ]; then
    git clone https://github.com/schasse/tmux-jump "${HOME}/.local/share/tmux/plugins/tmux-jump"
  fi
  git -C "${HOME}/.local/share/tmux/plugins/tmux-jump" checkout "2ff4940f043cd4ad80fa25c6efa33063fb3b386b"

  if [ ! -d "${HOME}/.local/share/tmux/plugins/catppuccin" ]; then
    git clone https://github.com/catppuccin/tmux.git "${HOME}/.local/share/tmux/plugins/catppuccin"
  fi
  git -C "${HOME}/.local/share/tmux/plugins/catppuccin" checkout "4ca26b774bc2e945fce4ccb909245dffeea7a9bf"

  if [ ! -d "${HOME}/.local/share/tmux/plugins/catppuccin" ]; then
    git clone https://github.com/catppuccin/tmux.git "${HOME}/.local/share/tmux/plugins/catppuccin"
  fi
  git -C "${HOME}/.local/share/tmux/plugins/catppuccin" checkout "4ca26b774bc2e945fce4ccb909245dffeea7a9bf"

  if [ ! -d "${HOME}/.local/share/tmux/plugins/tmux-floax" ]; then
    git clone https://github.com/omerxx/tmux-floax.git "${HOME}/.local/share/tmux/plugins/tmux-floax"
  fi
  git -C "${HOME}/.local/share/tmux/plugins/tmux-floax" checkout "61c7f466b9a4ceed56f99d403250164170d586cd"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/share/tmux/plugins"
}

main "$@"
