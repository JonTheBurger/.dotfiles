#!/usr/bin/env bash
# ======================================================================================
## @file 20-c#.sh
## C# essentials.
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/detail/util.sh"

# ======================================================================================
# CONSTANTS
# ======================================================================================
# Can be overridden from command line
## @var NETCOREDBG_VERSION Version of nvim to install.
NETCOREDBG_VERSION="${NETCOREDBG_VERSION-3.0.0-1012}"
## @var NETCOREDBG_URL Download source of nvim.
NETCOREDBG_URL="${NETCOREDBG_URL-https://github.com/Samsung/netcoredbg/releases/download/${NETCOREDBG_VERSION}/netcoredbg-linux-$(dpkg --print-architecture).tar.gz}"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs several applications I find useful for ${CYAN}C#${NOFMT} development.
Before I do anything, I'll tell you ${CYAN}what I'm about to do${NOFMT}, and ${CYAN}ask for
permission before continuing${NOFMT}.
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
  local::install_netcoredbg
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
## @brief Install apt packages for C# development.
# --------------------------------------------------------------------------------------
local::install_apt() {
  ## @var PKGS_APT Apt packages to try and install. Names without a match are ignored.
  declare -a PKGS_APT
  PKGS_APT+=(libunwind-dev)
  PKGS_APT+=(libuv1-dev)
  PKGS_APT+=(libuvc-dev)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_snap.
## @brief Install snap packages for C# development.
# --------------------------------------------------------------------------------------
local::install_snap() {
  ## @var PKGS_SNAP Snap packages to install in --classic mode.
  declare -a PKGS_SNAP
  PKGS_SNAP+=(dotnet-sdk)
  util::snap_install "${PKGS_SNAP[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_netcoredbg.
## @brief Install snap packages for C# development.
# --------------------------------------------------------------------------------------
local::install_netcoredbg() {
  # Print Preamble
  util::notice "... netcoredbg ..."
  util::info "${CYAN}netcoredbg${NOFMT} GBD MI compatible debugger for C#. This enables debugging in neovim. I'll be downloading it from:
${CYAN}${NETCOREDBG_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # download
    curl -Lo "/tmp/netcoredbg.tar.gz" "${NETCOREDBG_URL}"
    mkdir -p "/tmp/netcoredbg"
    tar -xf "/tmp/netcoredbg.tar.gz" --strip-components=1 -C "/tmp/netcoredbg"
    # exe
    mkdir -p "${HOME}/.local/bin"
    mv -i /tmp/netcoredbg/* "${HOME}/.local/bin"
    chmod +x "${HOME}/.local/bin/netcoredbg"
    util::notice "-- netcoredbg: Installed --"
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
  rm -f /tmp/netcoredbg.tar.gz
  rm -rf /tmp/netcoredbg
}

main "$@"
