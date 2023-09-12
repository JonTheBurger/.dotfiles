#!/usr/bin/env bash
# ======================================================================================
## @file 30-awesome.sh
## Installs awesome window manager.
# UN-COMMENT FOR LSP SUPPORT
# . "detail/util.sh"
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/detail/util.sh"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs the ${CYAN}awesome window manager${NOFMT}, as well as some
typical associated programs for customization. Before I do anything, I'll tell you
${CYAN}what I'm about to do${NOFMT}, and ${CYAN}ask for permission before continuing${NOFMT}.
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
  local::install_awesome
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
## @fn local::install_awesome()
## @brief Install awesome.
# --------------------------------------------------------------------------------------
local::install_awesome() {
  declare -a PKGS_APT
  PKGS_APT+=(awesome)
  PKGS_APT+=(compton)
  PKGS_APT+=(luarocks)
  util::apt_install "${PKGS_APT[@]}"
}

main "$@"
