#!/usr/bin/env bash
# ======================================================================================
## @file 20-python.sh
## Python Development essentials.
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
This script installs several applications I find useful for ${CYAN}python${NOFMT} development.
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
  local::install_snap
  local::install_pipx
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
## @brief Install apt packages for python development.
# --------------------------------------------------------------------------------------
local::install_apt() {
  ## @var PKGS_APT Apt packages to try and install. Names without a match are ignored.
  declare -a PKGS_APT
  PKGS_APT+=(black)
  PKGS_APT+=(pipx)
  PKGS_APT+=(ptpython) # Better repl
  PKGS_APT+=(python-is-python3)
  PKGS_APT+=(python3)
  PKGS_APT+=(python3-debugpy)
  PKGS_APT+=(python3-dev)
  PKGS_APT+=(python3-hatch-requirements-txt)
  PKGS_APT+=(python3-hatch-vcs)
  PKGS_APT+=(python3-hatchling)
  PKGS_APT+=(python3-mypy)
  PKGS_APT+=(python3-pip)
  # PKGS_APT+=(python3-pylsp)
  # PKGS_APT+=(python3-pylsp-black)
  # PKGS_APT+=(python3-pylsp-mypy)
  # PKGS_APT+=(python3-pylsp-ruff)
  PKGS_APT+=(python3-venv)
  # ruff > isort flake8 autoflake pydocstyle
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_snap.
## @brief Install snap packages for python development.
# --------------------------------------------------------------------------------------
local::install_snap() {
  ## @var PKGS_SNAP Snap packages to install in --classic mode.
  declare -a PKGS_SNAP
  PKGS_SNAP+=(pyright)
  util::snap_install "${PKGS_SNAP[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_pipx.
## @brief Install pip programs for python development.
# --------------------------------------------------------------------------------------
local::install_pipx() {
  ## @var PKGS_PIPX pip applications to install to the local user.
  declare -a PKGS_PIPX
  PKGS_PIPX+=(ruff)
  PKGS_PIPX+=(ruff-lsp)
  util::pipx_install "${PKGS_PIPX[@]}"
}

main "$@"
