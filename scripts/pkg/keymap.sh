#!/usr/bin/env bash
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=scripts/detail/installer.sh
. "${SCRIPT_DIR}/../detail/installer.sh"

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Installs the package.
## @param $version requested version to install, "latest" by default.
# --------------------------------------------------------------------------------------
local::do_install() {
  if [ "${version}" == "latest" ]; then
    version="latest"
  fi
  local URL="${URL-https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz}"

  # packages
  local::install_apt
  local::install_dnf
  local::install_pacman

  # udev
  sudo groupadd plugdev || true
  sudo usermod -aG plugdev "$USER"
  cat << EOF | sudo tee /etc/udev/rules.d/50-zsa.rules
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy rules for live training over webusb (Not needed for firmware v21+)
  # Rule for all ZSA keyboards
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
  # Rule for the Moonlander
  SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
  # Rule for the Ergodox EZ
  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
  # Rule for the Planck EZ
  SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

# Wally Flashing rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
# Keymapp Flashing rules for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu", GROUP="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE="0666", GROUP="plugdev"
EOF
  printf "\e[33m -- YOU WILL NEED TO REBOOT FOR UDEV CHANGES TO TAKE EFFECT -- \e[0m\n"

  # download
  curl -Lo "/tmp/keymap.tar.gz" "${URL}"
  mkdir -p "/tmp/keymap"
  tar -xf "/tmp/keymap.tar.gz" -C "/tmp/keymap"

  # exe
  mkdir -p "${HOME}/.local/bin"
  mkdir -p "${HOME}/.local/share/icons/"
  mkdir -p "${HOME}/.local/share/applications/"
  cp -ir "/tmp/keymap/keymap"* "${HOME}/.local/bin/"
  chmod +x "${HOME}/.local/bin/keymap"*
  cp -ir "/tmp/keymap/icon.png" "${HOME}/.local/share/icons/keymapp.png"

  # application
  cat <<EOF >"${HOME}/.local/share/applications/keymapp.desktop"
[Desktop Entry]
Name=Keymapp
Comment=Configure and flash your ZSA keyboard (Moonlander, Ergodox EZ, Planck EZ, Voyager)
Exec=${HOME}/.local/bin/keymapp
Icon=keymapp
Terminal=false
Type=Application
Categories=Utility;Settings;HardwareSettings;
Keywords=zsa;keyboard;keymap;moonlander;ergodox;planck;voyager;
StartupWMClass=keymapp
EOF
  chmod +x "${HOME}/.local/share/applications/keymapp.desktop"
  update-desktop-database "${HOME}/.local/share/applications/"

  # cleanup
  rm -f /tmp/keymap.tar.gz
  rm -rf /tmp/keymap
}

local::install_apt() {
  declare -a PKGS_APT
  PKGS_APT+=(libwebkit2gtk-4.1-0)
  PKGS_APT+=(libgtk-3-0)
  PKGS_APT+=(libusb-1.0-0)
  util::apt_install "${PKGS_APT[@]}"
}

local::install_dnf() {
  declare -a PKGS_DNF
  PKGS_DNF+=(gtk)
  PKGS_DNF+=(webkit2gtk4.1)
  PKGS_DNF+=(libusb)
  util::dnf_install "${PKGS_DNF[@]}"
}

local::install_pacman() {
  declare -a PKGS_PAC
  PKGS_PAC+=(libusb)
  PKGS_PAC+=(webkit2gtk-4.1)
  PKGS_PAC+=(gtk3)
  util::pacman_install "${PKGS_PAC[@]}"
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -f "${HOME}/.local/bin/keymapp"
  rm -f "${HOME}/.local/share/applications/keymapp.desktop"
  rm -f "${HOME}/.local/share/icons/keymapp.png"
  sudo rm -f /etc/udev/rules.d/50-zsa.rules
}

main "$@"
