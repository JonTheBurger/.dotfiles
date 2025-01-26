#!/usr/bin/env bash
# ======================================================================================
## @file 10-devbox.sh
## Uses devbox+nix to install command line tools.
# ======================================================================================
SCRIPT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/detail/util.sh"

# ======================================================================================
# CONSTANTS
# ======================================================================================
# Can be overridden from command line
## @var ARCH amd64-style architecture (**NOT** 'uname -m')
ARCH="${ARCH-$(dpkg --print-architecture)}"
## @var DEVBOX_VERSION Version of devbox to install.
DEVBOX_VERSION="${DEVBOX_VERSION-0.12.0}"
## @var NVIM_URL Download source of devbox.
DEVBOX_URL="${DEVBOX_URL-https://github.com/jetify-com/devbox/releases/download/${DEVBOX_VERSION}/devbox_${DEVBOX_VERSION}_linux_${ARCH}.tar.gz}"

main() {
  local::parse_params "$@"
  util::setup_colors

  local::install_devbox
}

local::usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-q] [-v]

SCRIPT DESCRIPTION HERE.

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

local::install_devbox() {
  curl -Lo "/tmp/devbox.tar.gz" "${DEVBOX_URL}"
  mkdir -p "/tmp/devbox"
  tar -xf "/tmp/devbox.tar.gz" -C "/tmp/devbox"
  mkdir -p "${HOME}/.local/bin"
  mv "/tmp/devbox/devbox" "${HOME}/.local/bin"
  "${HOME}/.local/bin/devbox" init
}

# --------------------------------------------------------------------------------------
## @fn local::cleanup()
## @brief Callback executed upon script exit, even if a signal is raised.
# --------------------------------------------------------------------------------------
local::cleanup() {
  rm -f /tmp/devbox.tar.gz
  rm -rf /tmp/devbox
}

main "$@"
