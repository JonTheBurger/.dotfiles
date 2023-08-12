#!/usr/bin/env bash
# ======================================================================================
## @file util.sh
## Utility functions and default boilerplate for shell scripts.
# ======================================================================================
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive

# ======================================================================================
# CONSTANTS
# ======================================================================================
## @var UTIL_SUCCESS 0, indicating success.
UTIL_SUCCESS=0
## @var UTIL_FAILURE 1, indicating failure.
UTIL_FAILURE=1
## @var UTIL_SIGS Default signals trapped by util.sh.
UTIL_SIGS="SIGINT SIGTERM ERR EXIT"

# ======================================================================================
# FUNCTIONS
# ======================================================================================
# --------------------------------------------------------------------------------------
## @fn util::setup()
## @brief Initializes the utility library. Please call this before using any functions!
# --------------------------------------------------------------------------------------
util::setup() {
  util::setup_colors
}

# --------------------------------------------------------------------------------------
## @fn util::setup_colors()
## @brief Initializes color vars when not a tty and NO_COLOR is not set.
# --------------------------------------------------------------------------------------
util::setup_colors() {
  if [[ -t 2 ]] && [[ -z ${NO_COLOR-} ]] && [[ ${TERM-} != "dumb" ]]; then
    NOFMT='\033[0m'
    RED='\033[0;31m'
    ORANGE='\033[0;33m'
    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    CYAN='\033[0;36m'
  else
    export NOFMT=''
    export RED=''
    export ORANGE=''
    export YELLOW=''
    export GREEN=''
    export BLUE=''
    export PURPLE=''
    export CYAN=''
  fi
}

# --------------------------------------------------------------------------------------
## @fn util::prompt()
## @brief Ask the user a yes or no question.
## @param query The question to ask the user; empty by default.
## @code{sh}
##     if util::prompt "Should I do it"; then
##       util::println "Ok, I'll do it"
##     else
##       util::println "Nevermind, I won't do anything"
##     fi
## @endcode
# --------------------------------------------------------------------------------------
util::prompt() {
  echo >&2 -en "${CYAN}${1-} (y/n)? ${NOFMT}"
  read -r response

  if [ "$response" != "${response#[Yy]}" ]; then
    return "${UTIL_SUCCESS}"
  else
    return "${UTIL_FAILURE}"
  fi
}

# --------------------------------------------------------------------------------------
## @fn util::apt_install()
## @brief Installs apt packages, misnamed packages are ignored (useful for migrated
## package names.
## @param try_install List of packages to try and install.
# --------------------------------------------------------------------------------------
util::apt_install() {
  # Prepend '-e ' to each element
  local -a try_install=("$@")
  try_install=("${try_install[@]/#/-e }")

  # Match each against the apt package list
  local installable
  # shellcheck disable=SC2068
  installable=$(
    apt-cache --generate pkgnames |
      grep --line-regexp --fixed-strings ${try_install[@]} |
      sort
  )

  # Install
  util::notice "I'm going to install apt packages:"
  for pkg in ${installable}; do
    util::info "- $pkg"
  done

  if util::prompt "Is this acceptable"; then
    util::notice "... Installing ..."
    # shellcheck disable=SC2086
    sudo apt-get install -y ${installable}
    util::notice "-- Installation Complete! --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn util::snap_install()
## @brief Installs snap packages in --classic mode.
## @param packages List of packages to install.
# --------------------------------------------------------------------------------------
util::snap_install() {
  util::notice "I'm going to install snap packages:"
  for pkg in $@; do
    util::info "- $pkg"
  done

  if util::prompt "Is this acceptable"; then
    util::notice "... Installing ..."
    for pkg in $@; do
      util::info "- $pkg"
      sudo snap install --classic ${pkg}
    done
    util::notice "-- Installation Complete! --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn util::pipx_install()
## @brief Installs pip packages into separate virtual environments for the current user.
## @param packages List of packages to install.
# --------------------------------------------------------------------------------------
util::pipx_install() {
  util::notice "I'm going to install executables from pip into separated venvs:"
  for pkg in $@; do
    util::info "- $pkg"
  done

  if util::prompt "Is this acceptable"; then
    util::notice "... Installing ..."
    for pkg in $@; do
      util::info "- $pkg"
      pipx install ${pkg}
    done
    util::notice "-- Installation Complete! --"
  else
    util::notice "-- Skipping --"
  fi
  util::println
}

# --------------------------------------------------------------------------------------
## @fn util::print()
## @brief Prints to stderr; use for output not intended to be parsed.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::print() {
  echo >&2 -en "${1-}"
}

# --------------------------------------------------------------------------------------
## @fn util::println()
## @brief Prints to stderr; use for output not intended to be parsed.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::println() {
  util::print "${1-}\n"
}

# --------------------------------------------------------------------------------------
## @fn util::debug()
## @brief Prints to stderr; use for output not intended to be parsed.
## Information only printed when VERBOSE is on.
## @param msg Message to display. --------------------------------------------------------------------------------------
util::debug() {
  if [ -n "${VERBOSE+x}" ]; then
    util::println "${PURPLE}${1-}${NOFMT}"
  fi
}

# --------------------------------------------------------------------------------------
## @fn util::info()
## @brief Prints to stderr; use for output not intended to be parsed.
## Use to inform the user of progress. Suppressed with --quiet.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::info() {
  if [ -z "${QUIET-}" ]; then
    util::println "${1-}"
  fi
}

# --------------------------------------------------------------------------------------
## @fn util::notice()
## @brief Prints to stderr; use for output not intended to be parsed.
## Use to inform the user of state changes.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::notice() {
  util::println "${GREEN}${1-}${NOFMT}"
}

# --------------------------------------------------------------------------------------
## @fn util::warning()
## @brief Prints to stderr; use for output not intended to be parsed.
## Use to alert the user that an unexpected, recoverable condition occured.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::warning() {
  util::println "${YELLOW}${1-}${NOFMT}"
}

# --------------------------------------------------------------------------------------
## @fn util::error()
## @brief Prints to stderr; use for output not intended to be parsed.
## Use to alert the user that something has gone wrong with the script.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::error() {
  util::println "${RED}${1-}${NOFMT}"
}

# --------------------------------------------------------------------------------------
## @fn util::critical()
## @brief Prints to stderr; use for output not intended to be parsed.
## Use to tell the user why the script is exiting.
## @param msg Message to display.
# --------------------------------------------------------------------------------------
util::critical() {
  util::println "${ORANGE}${1-}${NOFMT}"
}

# --------------------------------------------------------------------------------------
## @fn util::die()
## @brief Aborts the script
## @param msg Message to display; empty string by default.
## @param code Exit code; 1 by default.
# --------------------------------------------------------------------------------------
util::die() {
  local msg="${1-}"
  local code="${2-1}"
  util::critical "$msg"
  exit "$code"
}

# --------------------------------------------------------------------------------------
## @fn util::nop()
## @brief Does nothing :^)
# --------------------------------------------------------------------------------------
util::nop() {
  true
}

# --------------------------------------------------------------------------------------
## @fn local::cleanup()
## @brief Callback executed upon script exit, even if a signal is raised.
##        Users should consider overriding this function by defining it.
# --------------------------------------------------------------------------------------
local::cleanup() {
  util::nop
}

# --------------------------------------------------------------------------------------
## @fn local::on_trap()
## @private
## @brief Un-traps and calls the possibly overridden local::cleanup() function.
# --------------------------------------------------------------------------------------
util::on_trap() {
  # shellcheck disable=SC2086
  trap - ${UTIL_SIGS}
  local sig="${1}"
  local::cleanup "${sig}"
  if [[ ${sig} != "EXIT" ]]; then
    util::die "\n${sig}"
  fi
}

# --------------------------------------------------------------------------------------
## @fn local::trap()
## @private
## @brief Sets up signal trapping with util::on_trap().
# --------------------------------------------------------------------------------------
util::trap() {
  for sig; do
    # shellcheck disable=2064
    trap "util::on_trap ${sig}" "${sig}"
  done
}
# Setup our signal handler here
# shellcheck disable=SC2086
util::trap ${UTIL_SIGS}
