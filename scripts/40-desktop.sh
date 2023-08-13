#!/usr/bin/env bash
# ======================================================================================
## @file 40-desktop.sh
## Installs Linux Desktop applications.
# UN-COMMENT FOR LSP SUPPORT
#. "detail/util.sh"
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/detail/util.sh"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs several applications I find useful for ${CYAN}Linux Desktop${NOFMT}.
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
  local::install_apt
  local::install_editors
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
## @fn local::install_apt()
## @brief Install apt packages for desktop.
# --------------------------------------------------------------------------------------
local::install_apt() {
  declare -a PKGS_APT
  PKGS_APT+=(dolphin)
  PKGS_APT+=(dolphin-plugins)
  PKGS_APT+=(kitty)
  #PKGS_APT+=(fonts-noto-color-emoji)
  PKGS_APT+=(x11-xserver-utils)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_editors.
## @brief Install snap packages for desktop.
# --------------------------------------------------------------------------------------
local::install_editors() {
  # Snap non-classic
  declare -a PKGS_SNAP
  PKGS_SNAP=(chromium)
  util::notice "I'm going to install snap packages in strict mode:"
  for pkg in "${PKGS_SNAP[@]}"; do
    util::info "- $pkg"
  done

  if util::prompt "Is this acceptable"; then
    util::notice "... Installing ..."
    for pkg in "${PKGS_SNAP[@]}"; do
      util::info "- $pkg"
      sudo snap install ${pkg}
    done
    util::notice "-- Installation Complete! --"
  else
    util::notice "-- Skipping --"
  fi
  util::println

  # Snap classic
  PKGS_SNAP=()
  PKGS_SNAP+=(code)
  PKGS_SNAP+=(pycharm-community)
  util::snap_install "${PKGS_SNAP[@]}"

  # Apt Packages
  declare -a PKGS_APT
  PKGS_APT+=(qtcreator)
  util::apt_install "${PKGS_APT[@]}"
}

local::install_fonts() {
  echo https://www.nerdfonts.com/font-downloads
}

local::install_quake_term() {
  echo https://github.com/gotbletu/shownotes/blob/master/any_term_dropdown.sh
}

main "$@"