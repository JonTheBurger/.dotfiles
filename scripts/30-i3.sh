#!/usr/bin/env bash
# ======================================================================================
## @file 30-i3.sh
## Installs i3 tiling window manager.
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/detail/util.sh"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs the ${CYAN}i3 tiling window manager${NOFMT}, as well as some
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
  local::install_i3
  local::install_ly
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
## @fn local::install_i3()
## @brief Install i3.
# --------------------------------------------------------------------------------------
local::install_i3() {
  declare -a PKGS_APT
  # Brightness (usermod -aG video $(whoami))
  PKGS_APT+=(brightnessctl)
  # Wallpaper
  PKGS_APT+=(feh)
  # Window Manager
  PKGS_APT+=(i3)
  # Media Playback
  PKGS_APT+=(playerctl)
  # Status Bar
  PKGS_APT+=(polybar)
  # Night-light mode
  PKGS_APT+=(redshift)
  # Application Launcher
  PKGS_APT+=(rofi)
  util::apt_install "${PKGS_APT[@]}"
}

local::install_ly() {
  util::notice "... LY Display Manager ..."
  util::info "${CYAN}ly${NOFMT} is an extremely lightweight display manager.
This is the program that handles logging in and selecting a window manager.
"

  if util::prompt "Shall I install it"; then
    if [ ! -f "/usr/lib/systemd/system/ly.service" ]; then
      declare -a PKGS_APT
      PKGS_APT+=(build-essential)
      PKGS_APT+=(libpam0g-dev)
      PKGS_APT+=(libxcb-xkb-dev)
      util::apt_install "${PKGS_APT[@]}"

      git clone --recurse-submodules https://github.com/fairyglade/ly /tmp/ly
      cd /tmp/ly
      sudo make install installsystemd
      sudo systemctl enable ly.service
    else
      util::notice "... Already Installed ..."
    fi
    util::notice "-- LY Display Manager: Installed --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

local::cleanup() {
  rm -rf /tmp/ly
}

main "$@"
