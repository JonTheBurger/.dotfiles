#!/usr/bin/env bash
MAIN_FILE=$(basename "$(realpath "$0")")
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/util.sh"

main() {
  local::parse_params "$@"
  util::setup_colors

  if [ "$remove" -eq 0 ]; then
    util::info "${CYAN}${MAIN_FILE%.*}@${version}${NOFMT} Installing..."
    local::do_install "${version}"
    util::info "${CYAN}${MAIN_FILE%.*}${NOFMT}: [${GREEN}COMPLETE${NOFMT}]"
  else
    util::info "${YELLOW}${MAIN_FILE%.*}${NOFMT} Uninstalling..."
    local::do_uninstall
    util::info "${YELLOW}${MAIN_FILE%.*}${NOFMT}: [${GREEN}COMPLETE${NOFMT}]"
  fi
}

local::usage() {
  cat <<EOF
Usage: ${MAIN_FILE} [-h] [-q] [-v] [-r] [-V x.y.z]

Installs ${MAIN_FILE%.*}.

Available options:

-h, --help      Print this help and exit
-q, --quiet     Suppress script info messages
-v, --verbose   Print script debug info
-r, --remove    Remove the package
-V, --version   Package version to install (e.g. 1.2.3, defaults to "latest")
EOF
  exit
}

local::parse_params() {
  # default values of variables set from params
  remove=0
  version='latest'

  while :; do
    case "${1-}" in
    -h | --help) local::usage ;;
    -v | --verbose) VERBOSE=1 ;;
    -q | --quiet) QUIET=1 ;;
    --no-color) NO_COLOR=1 ;;
    -r | --remove) remove=1 ;;
    -V | --version)
      version="${2-}"
      shift
      ;;
    -?*) util::die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  return 0
}

