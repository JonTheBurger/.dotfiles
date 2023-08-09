#!/usr/bin/env bash
# ======================================================================================
## @file 10-cli.sh
## Command line essentials.
# ======================================================================================
SCRIPT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
. "${SCRIPT_DIR}/detail/util.sh"

# ======================================================================================
# CONSTANTS
# ======================================================================================
#uname -m
## @var
FZF_VERSION=${FZF_VERSION-0.42.0}
FZF_URL="${FZF_URL-https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_$(dpkg --print-architecture).tar.gz}"
FZF_GIT_URL="${FZF_GIT_URL-https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh}"

main() {
  local::parse_params "$@"
  util::setup

  # DEBUG
  local::make_local_dirs
  local::install_fzf
  return

  # Print welcome text
  util::notice "Welcome!"
  util::println
  util::info "This script installs several applications I find useful for ${CYAN}command line productivity${NOFMT}."
  util::info "Some inclusions may come off as opinionated, but do not fear! Before I do anything, I'll "
  util::info "tell you ${CYAN}what I'm about to do${NOFMT}, and ${CYAN}ask for permission before continuing${NOFMT}."
  util::println
  if util::prompt "Sound good?"; then
    util::notice "Ok, let's get started!"
  else
    util::notice "-- Au revoir! --"
    exit ${UTIL_SUCCESS}
  fi

  # Install Packages
  util::install_apt
  #local::install_neovim
  #local::install_fd
  local::install_fzf
  #local::install_lazygit
}

local::usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v]

Installs applications for command line productivity.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
EOF
  exit
}

local::parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) local::usage ;;
    -v | --verbose) VERBOSE=1 ;;
    --no-color) NO_COLOR=1 ;;
    -?*) util::die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  return 0
}

#   fzf
#   fzf-git
#   fd
#   nvim
#   lazygit
#   lazydocker

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

  # Print Preamble
  util::notice "... Local Directories ..."
  util::info "'${CYAN}~/.local${NOFMT}' is the user-specific variation of '${CYAN}/usr/${NOFMT}' and '${CYAN}/usr/local${NOFMT}'. These directories
are required to adequately install applications per-user. ${CYAN}These directories are required to continue${NOFMT}."
  util::notice "I'm going to create the following directories:"
  for directory in "${LOCAL_DIRS[@]}"; do
    util::info "- ${HOME}/.local/$directory"
  done

  if util::prompt "Is this acceptable"; then
    for directory in "${LOCAL_DIRS[@]}"; do
      mkdir -p "${HOME}/.local/$directory"
    done
  else
    util::notice "-- Exiting --"
    exit ${UTIL_FAILURE}
  fi
  util::notice "-- Local Directories: Created --"
  util::println
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt()
## @brief Install vital apt packages.
# --------------------------------------------------------------------------------------
local::install_apt() {
  ## @var PKGS_APT Apt packages to try and install. Names without a match are ignored.
  declare -a PKGS_APT
  PKGS_APT+=(apt-transport-https)
  PKGS_APT+=(bat)
  PKGS_APT+=(batcat) # "batcat" was renamed "bat"
  PKGS_APT+=(ca-certificates)
  PKGS_APT+=(curl)
  PKGS_APT+=(dos2unix)
  PKGS_APT+=(fzf) # Almost certainly too out of date
  PKGS_APT+=(git)
  PKGS_APT+=(git-lfs)
  PKGS_APT+=(htop)
  PKGS_APT+=(libfuze2) # For AppImage
  PKGS_APT+=(neovim)   # Almost certainly too out of date
  PKGS_APT+=(pipx)
  PKGS_APT+=(python3)
  PKGS_APT+=(python3-venv)
  PKGS_APT+=(ripgrep)
  PKGS_APT+=(software-properties-common)
  PKGS_APT+=(stow)
  PKGS_APT+=(tig)
  PKGS_APT+=(tmux)
  PKGS_APT+=(tree)
  PKGS_APT+=(unzip)
  PKGS_APT+=(vim)
  PKGS_APT+=(vim-gui-common) # For Clipboard
  PKGS_APT+=(wget)
  PKGS_APT+=(xclip) # For Clipboard
  PKGS_APT+=(xsel)  # For Clipboard
  PKGS_APT+=(zsh)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_fzf()
## @brief Install fzf from git.
# --------------------------------------------------------------------------------------
local::install_fzf() {
  # Print Preamble
  util::notice "... Fuzzy Finder ..."
  util::info "${CYAN}fzf${NOFMT} is a '${CYAN}fuzzy finder${NOFMT}' program. When used, it opens an interactive, filtering search
box for input. When integrated with your shell, the following shortcuts will be added:
- ${CYAN}Ctrl+R${NOFMT}: Search command history, put result on command line
- ${CYAN}Ctrl+T${NOFMT}: Search files, put result on command line
- ${CYAN}Alt+C${NOFMT}:  Search directories, ${CYAN}cd${NOFMT} to result
As well as the following Git integrations (put result on command line):
- ${CYAN}CTRL-G, CTRL-F${NOFMT}: Search Git Files
- ${CYAN}CTRL-G, CTRL-B${NOFMT}: Search Git Branches
- ${CYAN}CTRL-G, CTRL-T${NOFMT}: Search Git Tags
- ${CYAN}CTRL-G, CTRL-R${NOFMT}: Search Git Remotes
- ${CYAN}CTRL-G, CTRL-H${NOFMT}: Search Git commit Hashes
- ${CYAN}CTRL-G, CTRL-S${NOFMT}: Search Git Stashes
- ${CYAN}CTRL-G, CTRL-L${NOFMT}: Search Git reflogs
- ${CYAN}CTRL-G, CTRL-E${NOFMT}: Search Git Each ref (git for-each-ref)
Additionally, ${CYAN}vim plugins${NOFMT} often use fzf. Apt contains this package, but
some useful functionality requires a newer version (${CYAN}${FZF_VERSION}${NOFMT}). I'll be downloading it from:
${CYAN}${FZF_URL}${NOFMT}."
  util::println

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
  else
    util::notice "-- Skipping --"
    return
  fi

  curl -Lo "${HOME}/.local/bin/fzf-git.sh" "${FZF_GIT_URL}"
  util::notice "-- Fuzzy Finder: Installed --"
  util::println
}

main "$@"
