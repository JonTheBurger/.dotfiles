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
  declare -a PKGS_APT
  PKGS_APT+=(zsh)
  PKGS_APT+=(zsh-autosuggestions)
  PKGS_APT+=(zsh-syntax-highlighting)
  util::apt_install "${PKGS_APT[@]}"

  declare -a PKGS_DNF
  PKGS_DNF+=(zsh)
  PKGS_DNF+=(zsh-autosuggestions)
  PKGS_DNF+=(zsh-syntax-highlighting)
  util::dnf_install "${PKGS_DNF[@]}"

  # Turn off ubuntu's call to compinit, since we do it ourselves
  touch "${HOME}/.zshenv"
  if ! grep -q skip_global_compinit "${HOME}/.zshenv"; then
    echo "skip_global_compinit=1" >>"${HOME}/.zshenv"
  fi

  local ZSH_PLUGIN_DIR="${HOME}/.local/share/zsh"
  mkdir -p "${ZSH_PLUGIN_DIR}"
  # Only clone & accept known hashes, else remove the plugin

  if [[ ! -d "${ZSH_PLUGIN_DIR}/zsh-completions" ]]; then
    git clone "https://github.com/zsh-users/zsh-completions.git" "${ZSH_PLUGIN_DIR}/zsh-completions"
    # v0.35.0
    git -C "${ZSH_PLUGIN_DIR}/zsh-completions" checkout 67921bc12502c1e7b0f156533fbac2cb51f6943d ||
      rm -rf "${ZSH_PLUGIN_DIR}/zsh-completions"
  fi

  if [[ ! -d "${ZSH_PLUGIN_DIR}/zsh-history-substring-search" ]]; then
    git clone "https://github.com/zsh-users/zsh-history-substring-search.git" "${ZSH_PLUGIN_DIR}/zsh-history-substring-search"
    # v1.1.0
    git -C "${ZSH_PLUGIN_DIR}/zsh-history-substring-search" checkout 400e58a87f72ecec14f783fbd29bc6be4ff1641c ||
      rm -rf "${ZSH_PLUGIN_DIR}/zsh-history-substring-search"
  fi

  if [[ ! -d "${ZSH_PLUGIN_DIR}/zsh-autopair" ]]; then
    git clone "https://github.com/hlissner/zsh-autopair.git" "${ZSH_PLUGIN_DIR}/zsh-autopair"
    # v1.0
    git -C "${ZSH_PLUGIN_DIR}/zsh-autopair" checkout 34a8bca0c18fcf3ab1561caef9790abffc1d3d49 ||
      rm -rf "${ZSH_PLUGIN_DIR}/zsh-autopair"
  fi
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  local ZSH_PLUGIN_DIR="${HOME}/.local/share/zsh"
  rm -rf "${ZSH_PLUGIN_DIR}/zsh-completions"
  rm -rf "${ZSH_PLUGIN_DIR}/zsh-history-substring-search"
  rm -rf "${ZSH_PLUGIN_DIR}/zsh-autopair"
}

main "$@"
