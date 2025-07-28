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
    version="0.4.4"
  fi
  local URL="${URL-https://github.com/kmonad/kmonad/releases/download/${version}/kmonad}"

  # download
  mkdir -p "${HOME}/.local/bin"
  curl -Lo "${HOME}/.local/bin/kmonad2" "${URL}"
  chmod +x "${HOME}/.local/bin/kmonad"

  # System
  sudo groupadd uinput
  sudo usermod -aG input "${USER}"
  sudo usermod -aG uinput "${USER}"
  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/kmonad.rules
  sudo modprobe uinput

  util::notice "You may need to log out and back in for group changes to take effect."
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/kmonad"
}

main "$@"
