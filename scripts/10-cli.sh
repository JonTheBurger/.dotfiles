#!/usr/bin/env bash
# ======================================================================================
## @file 10-cli.sh
## Command line essentials.
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/detail/util.sh"

main() {
  local::parse_params "$@"
  util::setup

  local::make_local_dirs

  if grep -qi 'ubuntu' /etc/os-release; then
    local::install_apt
    "${SCRIPT_DIR}/pkg/delta.sh"
    "${SCRIPT_DIR}/pkg/fd.sh"
    "${SCRIPT_DIR}/pkg/fzf.sh"
    "${SCRIPT_DIR}/pkg/uv.sh"
  elif grep -qi 'fedora' /etc/os-release; then
    local::install_dnf
  fi

  "${SCRIPT_DIR}/pkg/devbox.sh"
  "${SCRIPT_DIR}/pkg/eza.sh"
  "${SCRIPT_DIR}/pkg/fzf-git.sh"
  "${SCRIPT_DIR}/pkg/lazygit.sh"
  "${SCRIPT_DIR}/pkg/starship.sh"
  "${SCRIPT_DIR}/pkg/tmux.sh"
  "${SCRIPT_DIR}/pkg/yazi.sh"
  "${SCRIPT_DIR}/pkg/zoxide.sh"
  "${SCRIPT_DIR}/pkg/zsh.sh"
}

local::usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}")

Installs applications for command line productivity.
EOF
  exit
}

local::parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) local::usage ;;
    -v | --verbose) VERBOSE=1 ;;
    -q | --quiet) QUIET=1 ;;
    --no-color) NO_COLOR=1 ;;
    -?*) util::die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  return 0
}

# --------------------------------------------------------------------------------------
## @fn local::make_local_dirs()
## @brief Create ~/.local and friends
# --------------------------------------------------------------------------------------
local::make_local_dirs() {
  ## @var LOCAL_DIRS Directories to create under '~/.local'.
  declare -a LOCAL_DIRS
  LOCAL_DIRS+=(bin)
  LOCAL_DIRS+=(lib)
  LOCAL_DIRS+=(locale)
  LOCAL_DIRS+=(log)
  LOCAL_DIRS+=(opt)
  LOCAL_DIRS+=(share)
  LOCAL_DIRS+=(src)
  LOCAL_DIRS+=(state)

  for directory in "${LOCAL_DIRS[@]}"; do
    util::info "+ ${HOME}/.local/$directory"
    mkdir -p "${HOME}/.local/$directory"
  done
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt()
## @brief Install vital apt packages.
# --------------------------------------------------------------------------------------
local::install_apt() {
  ## @var PKGS_APT Apt packages to try and install. Names without a match are ignored.
  declare -a PKGS_APT
  PKGS_APT+=(apt-transport-https)
  PKGS_APT+=(aptitude)
  PKGS_APT+=(bat)
  PKGS_APT+=(batcat) # "batcat" was renamed "bat"
  PKGS_APT+=(btop)
  PKGS_APT+=(ca-certificates)
  PKGS_APT+=(curl)
  PKGS_APT+=(delta)
  PKGS_APT+=(dos2unix)
  PKGS_APT+=(fzf) # Almost certainly too out of date
  PKGS_APT+=(git)
  PKGS_APT+=(git-lfs)
  PKGS_APT+=(libfuse2) # For AppImage
  PKGS_APT+=(neovim)   # Almost certainly too out of date
  PKGS_APT+=(pipx)
  PKGS_APT+=(python3)
  PKGS_APT+=(python3-venv)
  PKGS_APT+=(ripgrep)
  PKGS_APT+=(ruby) # For tmux-jump
  PKGS_APT+=(software-properties-common)
  PKGS_APT+=(stow)
  PKGS_APT+=(tig)
  PKGS_APT+=(tmux)
  PKGS_APT+=(trash-cli)
  PKGS_APT+=(tree)
  PKGS_APT+=(unzip)
  PKGS_APT+=(vim)
  PKGS_APT+=(vim-gui-common) # For Clipboard
  PKGS_APT+=(wget)
  PKGS_APT+=(xclip) # For Clipboard
  PKGS_APT+=(xsel)  # For Clipboard
  PKGS_APT+=(zip)
  PKGS_APT+=(zsh)
  PKGS_APT+=(zsh-autosuggestions)
  PKGS_APT+=(zsh-syntax-highlighting)
  util::apt_install "${PKGS_APT[@]}"
}

local::install_dnf() {
  sudo dnf install \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
  sudo dnf install \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

  sudo dnf install \
    bat \
    btop \
    fd-find \
    fzf \
    git \
    git-lfs \
    tig \
    git-delta \
    neovim \
    stow \
    trash-cli \
    xxd \
    uv \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting
}

main "$@"
