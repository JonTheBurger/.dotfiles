#!/usr/bin/env bash
# ======================================================================================
## @file 20-c++.sh
## C++ Development essentials.
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/util.sh
. "${SCRIPT_DIR}/detail/util.sh"

# ======================================================================================
# CONSTANTS
# ======================================================================================
## @var MOLD_VERSION Version of mold to install.
MOLD_VERSION="${MOLD_VERSION-2.0.0}"
## @var MOLD_URL Download source of mold.
MOLD_URL="${MOLD_URL-https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-$(uname -m)-linux.tar.gz}"

main() {
  local::parse_params "$@"
  util::setup

  # Print welcome text
  util::notice "Welcome!"
  util::info "
This script installs several applications I find useful for ${CYAN}C & C++${NOFMT} development.
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
  local::install_apt_essentails
  local::install_apt_clang
  local::install_apt_embedded
  local::install_apt_libs
  local::install_apt_qt
  local::install_mold
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
## @fn local::install_apt_essentials()
## @brief Install apt packages essential for C++ development.
# --------------------------------------------------------------------------------------
local::install_apt_essentails() {
  declare -a PKGS_APT
  PKGS_APT+=(build-essential)
  PKGS_APT+=(ccache)
  PKGS_APT+=(clang-format)
  PKGS_APT+=(clang-tidy)
  PKGS_APT+=(clangd)
  PKGS_APT+=(cmake)
  PKGS_APT+=(cmake-doc)
  PKGS_APT+=(cppcheck)
  PKGS_APT+=(doxygen)
  PKGS_APT+=(g++)
  PKGS_APT+=(gdb)
  PKGS_APT+=(gdb-multiarch)
  PKGS_APT+=(iwyu)
  PKGS_APT+=(mold)
  PKGS_APT+=(ninja-build)
  PKGS_APT+=(valgrind)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt_clang()
## @brief Install apt packages for developing with clang.
# --------------------------------------------------------------------------------------
local::install_apt_clang() {
  declare -a PKGS_APT
  PKGS_APT+=(clang)
  PKGS_APT+=(lld)
  PKGS_APT+=(lldb)
  PKGS_APT+=(libc++-dev)
  PKGS_APT+=(libclang-rt-dev)
  PKGS_APT+=(llvm)
  util::apt_install "${PKGS_APT[@]}"

  # Set up version-only packages, make non-versioned symlinks if applicable
  if [ -x "$(command -v /usr/bin/clang)" ]; then
    CLANG_VERSION=$(/usr/bin/clang --version | grep -o '[0-9]\+' | head -1)
    PKGS_APT=("libfuzzer-${CLANG_VERSION}-dev")
    util::apt_install "${PKGS_APT[@]}"
    sudo ln -s "/usr/bin/lldb-dap-${CLANG_VERSION}" /usr/local/bin/lldb-dap
  fi
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt_embedded()
## @brief Install apt packages for developing ARM EABI.
# --------------------------------------------------------------------------------------
local::install_apt_embedded() {
  declare -a PKGS_APT
  PKGS_APT+=(gdb-arm-none-eabi)
  PKGS_APT+=(gcc-arm-none-eabi)
  PKGS_APT+=(stutil)
  PKGS_APT+=(stlink-tools)
  PKGS_APT+=(srecord)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt_libs()
## @brief Install apt packages for some common libraries.
# --------------------------------------------------------------------------------------
local::install_apt_libs() {
  declare -a PKGS_APT
  PKGS_APT+=(catch2)
  PKGS_APT+=(libbenchmark-dev)
  PKGS_APT+=(libboost-all-dev)
  PKGS_APT+=(libfmt-dev)
  PKGS_APT+=(libgtest-dev)
  PKGS_APT+=(libspdlog-dev)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_apt_qt()
## @brief Install apt packages for Qt development.
# --------------------------------------------------------------------------------------
local::install_apt_qt() {
  declare -a PKGS_APT
  PKGS_APT+=(libqt6charts-dev)
  PKGS_APT+=(qt6-base-dev)
  PKGS_APT+=(qt6-base-dev-tools)
  util::apt_install "${PKGS_APT[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::install_mold()
## @brief Install mold from github.
# --------------------------------------------------------------------------------------
local::install_mold() {
  # Print Preamble
  util::notice "... mold ..."
  util::info "${CYAN}mold${NOFMT} is a ${CYAN}crazy fast linker${NOFMT}. I'll be downloading it from:
${CYAN}${MOLD_URL}${NOFMT}
"

  if util::prompt "Shall I install it"; then
    util::notice "... Installing ..."
    # download
    curl -Lo "/tmp/mold.tar.gz" "${MOLD_URL}"
    mkdir -p "/tmp/mold"
    tar -xf "/tmp/mold.tar.gz" --strip-components=1 -C "/tmp/mold"
    # install
    sudo cp -r /tmp/mold/* "/usr/local"
    sudo chmod +x "/usr/local/bin/mold"
    sudo ldconfig
    util::notice "-- mold: Installed --"
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
  rm -f /tmp/mold.tar.gz
  rm -rf /tmp/mold
}

main "$@"
