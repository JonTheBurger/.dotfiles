#!/usr/bin/env bash
# ======================================================================================
## @file 10-cli.sh
## Command line essentials.
# UN-COMMENT FOR LSP SUPPORT
#. "detail/util.sh"
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/detail/util.sh"

# ======================================================================================
# CONSTANTS
# ======================================================================================
# Can be overridden from command line
## @var NVIM_VERSION Version of nvim to install.
NVIM_VERSION="${NVIM_VERSION-0.9.1}"
## @var NVIM_URL Download source of nvim.
NVIM_URL="${NVIM_URL-https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage}"
## @var FD_VERSION Version of fd to install.
FD_VERSION="${FD_VERSION-8.7.0}"
## @var FD_URL Download source of fd.
FD_URL="${FD_URL-https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-$(uname -m)-unknown-linux-gnu.tar.gz}"
## @var FZF_VERSION Version of fzf to install.
FZF_VERSION="${FZF_VERSION-0.42.0}"
## @var FZF_URL Download source of fzf.
FZF_URL="${FZF_URL-https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_$(dpkg --print-architecture).tar.gz}"
## @var FZF_GIT_URL Download source of fzf.git.
FZF_GIT_URL="${FZF_GIT_URL-https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh}"
## @var LAZYGIT_VERSION Download source of lazygit.
LAZYGIT_VERSION="${LAZYGIT_VERSION-0.40.2}"
## @var LAZYGIT_URL Version of lazygit to install.
LAZYGIT_URL="${LAZYGIT_URL-https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_$(uname -m).tar.gz}"
## @var TPM_URL TMux Plugin Manager Git URL.
TPM_URL="${TPM_URL-https://github.com/tmux-plugins/tpm}"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs several applications I find useful for ${CYAN}command line productivity${NOFMT}.
Some inclusions may come off as opinionated, but do not fear! Before I do anything, I'll
tell you ${CYAN}what I'm about to do${NOFMT}, and ${CYAN}ask for permission before continuing${NOFMT}.
"
  if util::prompt "Ready"; then
    util::println
    util::notice "Ok, let's get started!"
    util::println
  else
    util::notice "-- Au revoir! --"
    exit ${UTIL_SUCCESS}
  fi

  # Install Packages
  local::make_local_dirs
  local::install_apt
  local::install_nvim
  local::install_fd
  local::install_fzf
  local::install_lazygit
  local::install_tmux_plugin_manager
}

local::usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-q] [-v]

Installs applications for command line productivity.

Available options:

-h, --help      Print this help and exit
-q, --quiet     Suppress script info messages
-v, --verbose   Print script debug info
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

  # Print Preamble
  util::notice "... Local Directories ..."
  util::info "'${CYAN}~/.local${NOFMT}' is the user-specific variation of '${CYAN}/usr/${NOFMT}' and '${CYAN}/usr/local${NOFMT}'. These directories
are required to adequately install applications per-user. ${CYAN}These directories may be required for some later steps${NOFMT}.
"
  util::notice "I'm going to create directories under ~/.local:"
  for directory in "${LOCAL_DIRS[@]}"; do
    util::info "- ${HOME}/.local/$directory"
  done

  if util::prompt "Is this acceptable"; then
    # make dirs
    for directory in "${LOCAL_DIRS[@]}"; do
      mkdir -p "${HOME}/.local/$directory"
    done
    util::notice "-- Local Directories: Created --"
  else
    util::notice "-- Skipping --"
  fi
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
  PKGS_APT+=(aptitude)
  PKGS_APT+=(bat)
  PKGS_APT+=(batcat) # "batcat" was renamed "bat"
  PKGS_APT+=(ca-certificates)
  PKGS_APT+=(curl)
  PKGS_APT+=(dos2unix)
  PKGS_APT+=(fzf) # Almost certainly too out of date
  PKGS_APT+=(git)
  PKGS_APT+=(git-lfs)
  PKGS_APT+=(htop)
  PKGS_APT+=(libfuse2) # For AppImage
  PKGS_APT+=(neovim)   # Almost certainly too out of date
  PKGS_APT+=(nodejs)   # For some nvim Mason packages
  PKGS_APT+=(pipx)
  PKGS_APT+=(python3)
  PKGS_APT+=(python3-venv)
  PKGS_APT+=(ripgrep)
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

# --------------------------------------------------------------------------------------
## @fn local::install_nvim()
## @brief Install nvim from git.
# --------------------------------------------------------------------------------------
local::install_nvim() {
  # Print Preamble
  util::notice "... NeoVim ..."
  util::info "${CYAN}neovim${NOFMT} is a highly configurable text editor. Unlike classic vim, it can be configured with
lua in addition to vimscript, and has native ${CYAN}LSP${NOFMT} (language server protocol, used for auto-complete, warnings, etc.)
making it very popular for modern plugins. Some useful functionality requires a newer version (${CYAN}${NVIM_VERSION}${NOFMT}). I'll be downloading it from:
${CYAN}${NVIM_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # Ask before removing an existing nvim
    if [ -f "${HOME}/.local/bin/nvim" ]; then
      rm -i "${HOME}/.local/bin/nvim"
    fi
    # Only continue if nvim is not installed / was removed
    if [ ! -f "${HOME}/.local/bin/nvim" ]; then
      curl -Lo "${HOME}/.local/bin/nvim" "${NVIM_URL}"
      chmod +x "${HOME}/.local/bin/nvim"
    fi
    util::notice "-- NeoVim: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn local::install_fd()
## @brief Install fd from git.
# --------------------------------------------------------------------------------------
local::install_fd() {
  # Print Preamble
  util::notice "... fd ..."
  util::info "${CYAN}fd${NOFMT} is a fast replacement for ${CYAN}find${NOFMT}. The ${CYAN}telescope${NOFMT} plugin for ${CYAN}nvim${NOFMT} uses it. I'll be downloading it from:
${CYAN}${FD_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # download
    curl -Lo "/tmp/fd.tar.gz" "${FD_URL}"
    mkdir -p "/tmp/fd"
    tar -xf "/tmp/fd.tar.gz" --strip-components=1 -C "/tmp/fd"
    # exe
    mv -i "/tmp/fd/fd" "${HOME}/.local/bin/fd"
    chmod +x "${HOME}/.local/bin/fd"
    # completion
    mkdir -p "${HOME}/.local/share/bash-completion/completions"
    cp -i /tmp/fd/autocomplete/* "${HOME}/.local/share/bash-completion/completions"
    mkdir -p "${HOME}/.local/share/zsh/vendor-completions"
    mv -i /tmp/fd/autocomplete/* "${HOME}/.local/share/zsh/vendor-completions"
    # manpage
    mkdir -p "${HOME}/.local/share/man/man1"
    mv -i "/tmp/fd/fd.1" "${HOME}/.local/share/man/man1/fd.1"
    util::notice "-- fd: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
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
${CYAN}${FZF_URL}${NOFMT}.
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # FZF; Ask before removing an existing fzf
    if [ -f "${HOME}/.local/bin/fzf" ]; then
      rm -i "${HOME}/.local/bin/fzf"
    fi
    # Only continue if fzf is not installed / was removed
    if [ ! -f "${HOME}/.local/bin/fzf" ]; then
      curl -Lo "${HOME}/.local/bin/fzf" "${FZF_URL}"
      chmod +x "${HOME}/.local/bin/fzf"
    fi

    # FZF Git; Ask before removing an existing fzf-git
    if [ -f "${HOME}/.local/bin/fzf-git.sh" ]; then
      rm -i "${HOME}/.local/bin/fzf-git.sh"
    fi
    # Only continue if fzf is not installed / was removed
    if [ ! -f "${HOME}/.local/bin/fzf-git.sh" ]; then
      curl -Lo "${HOME}/.local/bin/fzf-git.sh" "${FZF_GIT_URL}"
    fi
    util::notice "-- Fuzzy Finder: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn local::install_lazygit()
## @brief Install lazygit from git.
# --------------------------------------------------------------------------------------
local::install_lazygit() {
  # Print Preamble
  util::notice "... Lazy Git ..."
  util::info "${CYAN}lazygit${NOFMT} is a curses-like terminal application for git. I'll be downloading it from:
${CYAN}${LAZYGIT_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # download
    curl -Lo "/tmp/lazygit.tar.gz" "${LAZYGIT_URL}"
    mkdir -p "/tmp/lazygit"
    tar -xf "/tmp/lazygit.tar.gz" -C "/tmp/lazygit"
    # exe
    mv -i "/tmp/lazygit/lazygit" "${HOME}/.local/bin/lazygit"
    chmod +x "${HOME}/.local/bin/lazygit"
    util::notice "-- Lazy Git: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn local::install_tmux_plugin_manager()
## @brief Install tpm from git.
# --------------------------------------------------------------------------------------
local::install_tmux_plugin_manager() {
  # Print Preamble
  util::notice "... TMux Plugin Manager ..."
  util::info "${CYAN}tpm${NOFMT}, a plugin manager for tmux. I'll be downloading it from:
${CYAN}${TPM_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
      util::notice "... Installing ..."
      git clone "${TPM_URL}" "${HOME}/.tmux/plugins/tpm"
    else
      util::notice "... Already Installed ..."
    fi
    util::notice "-- TMUX Plugin Manager: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn local::cleanup()
## @brief Callback executed upon script exit, even if a signal is raised.
# --------------------------------------------------------------------------------------
local::cleanup() {
  rm -f /tmp/fd.tar.gz
  rm -f /tmp/lazygit.tar.gz
  rm -rf /tmp/fd
  rm -rf /tmp/lazygit
}

main "$@"
