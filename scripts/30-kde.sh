#!/usr/bin/env bash
# ======================================================================================
## @file 30-kde.sh
## Installs KDE Desktop.
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
This script installs the customizable ${CYAN}KDE Desktop Environment${NOFMT}.
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
  local::install_kde_desktop
  local::install_kde_applications
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
## @fn local::install_kde_desktop()
## @brief Install KDE Desktop.
# --------------------------------------------------------------------------------------
local::install_kde_desktop() {
  declare -a PKGS_APT
  PKGS_APT+=(breeze-icon-theme)
  PKGS_APT+=(fonts-hack)
  PKGS_APT+=(fonts-noto)
  PKGS_APT+=(kde-config-cron)
  PKGS_APT+=(kde-config-gtk-style)
  PKGS_APT+=(kde-config-gtk-style-preview)
  PKGS_APT+=(kde-config-sddm)
  PKGS_APT+=(kdebase-runtime)
  PKGS_APT+=(kio-extras)
  PKGS_APT+=(plasma-desktop)
  PKGS_APT+=(plasma-workspace)
  PKGS_APT+=(pulseaudio)
  PKGS_APT+=(sddm)
  PKGS_APT+=(systemsettings)
  PKGS_APT+=(udisks2)
  PKGS_APT+=(unzip)
  PKGS_APT+=(upower)
  PKGS_APT+=(zip)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_kde_applications()
## @brief Install KDE desktop applications.
# --------------------------------------------------------------------------------------
local::install_kde_applications() {
  declare -a PKGS_APT
  PKGS_APT+=(ark)
  PKGS_APT+=(bismuth)
  PKGS_APT+=(dolphin)
  PKGS_APT+=(dolphin-plugins)
  PKGS_APT+=(gwenview)
  PKGS_APT+=(kate)
  PKGS_APT+=(kcalc)
  PKGS_APT+=(kde-spectacle)
  PKGS_APT+=(konsole)
  PKGS_APT+=(ksysguard)
  PKGS_APT+=(kwin-addons)
  PKGS_APT+=(kwin-x11)
  PKGS_APT+=(latte-dock)
  PKGS_APT+=(okular)
  PKGS_APT+=(partitionmanager)
  PKGS_APT+=(qt5-style-kvantum)
  util::apt_install "${PKGS_APT[@]}"
}

main "$@"
