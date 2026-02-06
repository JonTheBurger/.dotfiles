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
  local DOTNET_SDK_VERSION=9.0
  if [ "${version}" == "latest" ]; then
    version="4.6"
  fi
  local URL="${URL-https://github.com/godotengine/godot/releases/download/${version}-stable/Godot_v${version}-stable_mono_linux_$(uname -m).zip}"

  # download
  curl -Lo "/tmp/godot.zip" "${URL}"
  mkdir -p "/tmp/godot"
  unzip "/tmp/godot.zip" -d "/tmp/godot"

  # exe
  mkdir -p "${HOME}/.local/opt"
  mv /tmp/godot/* "${HOME}/.local/opt"
  mkdir -p "${HOME}/.local/bin"
  ln -s "${HOME}/.local/opt/Godot_v${version}-stable_mono_linux_$(uname -m)/Godot_v${version}-stable_mono_linux.$(uname -m)" "${HOME}/.local/bin/godot"

  # system
  if grep -qi 'fedora' /etc/os-release; then
    declare -a PKGS_DNF
    PKGS_DNF+=("dotnet-sdk-${DOTNET_SDK_VERSION}")
    # PKGS_DNF+=("dotnet-sdk-aot-${DOTNET_SDK_VERSION}")
    util::dnf_install "${PKGS_DNF[@]}"
  elif grep -qi 'ubuntu' /etc/os-release; then
    sudo add-apt-repository ppa:dotnet/backports
    sudo apt-get update && sudo apt-get install -y dotnet-sdk-${DOTNET_SDK_VERSION}
  fi

  # desktop
  cat <<EOF > "${HOME}/.local/share/applications/org.godotengine.Godot.desktop"
[Desktop Entry]
Name=Godot Engine
GenericName=Libre game engine
GenericName[el]=Ελεύθερη μηχανή παιχνιδιού
GenericName[fr]=Moteur de jeu libre
GenericName[ja]=自由なゲームエンジン
GenericName[nl]=Libre game-engine
GenericName[pl]=Darmowy silnik gier
GenericName[ru]=Свободный игровой движок
GenericName[uk]=Вільний ігровий рушій
GenericName[zh_CN]=自由的游戏引擎
Comment=Multi-platform 2D and 3D game engine with a feature-rich editor
Comment[el]=2D και 3D μηχανή παιχνιδιού πολλαπλών πλατφορμών με επεξεργαστή πλούσιο σε χαρακτηριστικά
Comment[fr]=Moteur de jeu 2D et 3D multiplateforme avec un éditeur riche en fonctionnalités
Comment[ja]=多機能なエディタを備えたマルチプラットフォーム対応の2D・3Dゲームエンジン
Comment[nl]=Multi-platform 2D- en 3D-game-engine met een veelzijdige editor
Comment[pl]=Wieloplatformowy silnik gier 2D i 3D z wielofunkcyjnym edytorem
Comment[ru]=Кроссплатформенный движок с многофункциональным редактором для 2D- и 3D-игр
Comment[uk]=Багатофункціональний кросплатформний рушій для створення 2D та 3D ігор
Comment[zh_CN]=多平台 2D 和 3D 游戏引擎，带有功能丰富的编辑器
Exec=godot %f
Icon=godot
Terminal=false
Type=Application
MimeType=application/x-godot-project;
Categories=Development;IDE;
StartupWMClass=Godot
EOF

  # cleanup
  rm -rf /tmp/godot.zip
  rm -rf /tmp/godot
}

# --------------------------------------------------------------------------------------
## @fn local::do_install()
## @brief Removes the package.
# --------------------------------------------------------------------------------------
local::do_uninstall() {
  rm -rf "${HOME}/.local/bin/godot"
  rm -rf "${HOME}/.local/share/applications/org.godotengine.Godot.desktop"
  rm -rf "${HOME}/.local/opt/Godot_v"*
}

main "$@"
