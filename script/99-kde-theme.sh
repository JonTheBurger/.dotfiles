#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
home="/home/$SUDO_USER"
function unsudo() {
  sudo -Hu $SUDO_USER $@
}

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y \
      dolphin-plugins \
      papirus-icon-theme \
      xdotool
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

if [ ! -d /tmp/Layan ]; then
    unsudo git clone --depth 1 https://github.com/vinceliuice/Layan-kde.git /tmp/Layan
fi

# Look & Feel
#sudo -Hu $SUDO_USER lookandfeeltool --apply org.kde.breezedark.desktop

# SDDM Theme
if [ ! -d "/usr/share/sddm/themes/sddm-sugar-candy-master" ]; then
    wget https://framagit.org/MarianArlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz -O /tmp/sddm-sugar-candy-master.tar.gz
    tar -xf /tmp/sddm-sugar-candy-master.tar.gz -C /usr/share/sddm/themes
    kwriteconfig5 --file /etc/sddm.conf --group Theme --key Current sddm-sugar-candy-master
    echo 'ForceHideCompletePassword="true"' > /usr/share/sddm/themes/sddm-sugar-candy-master/theme.conf.user
fi

# Kvantum Theme
if [ ! -d "${home}/.config/Kvantum/Layan" ]; then
    unsudo mkdir -p ${home}/.config/Kvantum/Layan
    unsudo cp /tmp/Layan/Kvantum/Layan/Layan.kvconfig ${home}/.config/Kvantum/Layan
    unsudo cp /tmp/Layan/Kvantum/Layan/Layan.svg ${home}/.config/Kvantum/Layan
fi
unsudo kwriteconfig5 --file ${home}/.config/Kvantum/kvantum.kvconfig --group General --key theme Layan
unsudo kwriteconfig5 --file ${home}/.config/Kvantum/Layan/Layan.kvconfig --group Hacks --key transparent_dolphin_view --type bool true

# Widget Style
unsudo kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle 'kvantum-dark'

# Color Scheme
if [ ! -d "${home}/.local/share/color-schemes/Layan.colors" ]; then
    unsudo mkdir -p ${home}/.local/share/color-schemes
    unsudo cp /tmp/Layan/color-schemes/Layan.colors ${home}/.local/share/color-schemes
fi
unsudo kwriteconfig5 --file kdeglobals --group General --key ColorScheme Layan

# Window Decorations
if [ ! -d "${home}/.local/share/aurorae/themes/Sweet" ]; then
    unsudo git clone --depth 1 --branch nova https://github.com/EliverLara/Sweet.git /tmp/Sweet
    unsudo mkdir -p ${home}/.local/share/aurorae/themes
    unsudo cp -r /tmp/Sweet/kde/aurorae/Sweet-Dark-transparent ${home}/.local/share/aurorae/themes/Sweet-Dark-transparent
    unsudo kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key theme '__aurorae__svg__Sweet-Dark-transparent'
fi
# Add "Keep Above" button on left side of window decoration
unsudo kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft 'MF'
# Slightly larger buttons
unsudo kwriteconfig5 --file auroraerc --group Sweet-Dark-transparent --key ButtonSize 2

# Icons
unsudo kwriteconfig5 --file kdeglobals --group Icons --key Theme 'Papirus-Dark'
unsudo kwriteconfig5 --file kdeglobals --group Emoticons --key emoticonsTheme 'EmojiOne'

# Faster animations
unsudo kwriteconfig5 --file kwinrc --group Compositing --key AnimationSpeed 3
unsudo kwriteconfig5 --file kwinrc --group Compositing --key Backend OpenGL
unsudo kwriteconfig5 --file kwinrc --group Compositing --key GLCore --type bool true
# Vsync only when cheap
unsudo kwriteconfig5 --file kwinrc --group Compositing --key GLPreferBufferSwap e
# "Crisp" scale method
unsudo kwriteconfig5 --file kwinrc --group Compositing --key GLTextureFilter 0

# Reduce noise for "Blur" desktop effect
unsudo kwriteconfig5 --file kwinrc --group Effect-Blur --key NoiseStrength 2
# Make "Present Windows" effect faster
unsudo kwriteconfig5 --file kwinrc --group Effect-PresentWindows --key Accuracy 6
# Make "Present Windows" middle click -> close window
unsudo kwriteconfig5 --file kwinrc --group MiddleButtonWindow --key Accuracy 6
# Disable several desktop effects
unsudo kwriteconfig5 --file kwinrc --group Plugins --key contrastEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadeEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadingpopupsEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_loginEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_logoutEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_maximizeEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_morphingpopupsEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_squashEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_windowapertureEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key minimizeallEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key resizeEnabled --type bool true
unsudo kwriteconfig5 --file kwinrc --group Plugins --key screenedgeEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key slidingpopupsEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key synchronizeskipswitcherEnabled --type bool false
unsudo kwriteconfig5 --file kwinrc --group Plugins --key videowallEnabled --type bool false

# Disable autolocking the screen after T minutes
unsudo kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock --type bool false

# 4 virtual desktops
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Id_2 $(uuidgen)
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Id_3 $(uuidgen)
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Id_4 $(uuidgen)
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Name_1 NW
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Name_2 NE
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Name_3 SW
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Name_4 SE
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Number 4
unsudo kwriteconfig5 --file kwinrc --group Desktops --key Rows 2

# Disable screen edge actions
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key Bottom None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key BottomLeft None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key BottomRight None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key Left None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key Right None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key Top None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key TopLeft None
unsudo kwriteconfig5 --file kwinrc --group ElectricBorders --key TopRight None

# Mousewheel on window decoration changes opacity
unsudo kwriteconfig5 --file kwinrc --group MouseBindings --key CommandTitlebarWheel "Change Opacity"

# Use thumbnail Alt+Tab switcher
unsudo kwriteconfig5 --file kwinrc --group TabBox --key LayoutName thumbnails

# Disable baloo file indexing
unsudo kwriteconfig5 --file baloofilerc --group "Basic Settings" --key Indexing-Enabled --type bool false

# Disable most krunner search locations
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "CharacterRunnerEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "DictionaryEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "Kill RunnerEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "PowerDevilEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "Spell CheckerEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "baloosearchEnabled" --type bool true
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "bookmarksEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "browsertabsEnabled" --type bool true
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "calculatorEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "desktopsessionsEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "katesessionsEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "konsoleprofilesEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "krunner_appstreamEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "kwinEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "locationsEnabled" --type bool true
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.activitiesEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.datetimeEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.windowedwidgetsEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "placesEnabled" --type bool true
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "plasma-desktopEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "recentdocumentsEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "servicesEnabled" --type bool true
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "shellEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "unitconverterEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "webshortcutsEnabled" --type bool false
unsudo kwriteconfig5 --file krunnerrc --group Plugins --key "windowsEnabled" --type bool false

# Shortcuts - Switch Virtual Desktop (Meta+Ctrl+Shift+H/J/K/L || Meta+Ctrl+Arrows)
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" $'Meta+Ctrl+Down\tMeta+Ctrl+Shift+J,Meta+Ctrl+Down,Switch One Desktop Down'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" $'Meta+Ctrl+Up\tMeta+Ctrl+Shift+K,Meta+Ctrl+Up,Switch One Desktop Up'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" $'Meta+Ctrl+Left\tMeta+Ctrl+Shift+H,Meta+Ctrl+Left,Switch One Desktop to the Left'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" $'Meta+Ctrl+Right\tMeta+Ctrl+Shift+L,Meta+Ctrl+Right,Switch One Desktop to the Right'
# Shortcuts - Switch to Window (Meta+Alt+H/J/K/L)
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Down" $'Meta+Alt+Down\tMeta+Alt+J,Meta+Alt+Down,Switch to Window Below'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Left" $'Meta+Alt+Left\tMeta+Alt+H,Meta+Alt+Left,Switch to Window to the Left'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Right" $'Meta+Alt+Right\tMeta+Alt+L,Meta+Alt+Right,Switch to Window to the Right'
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Up" $'Meta+Alt+Up\tMeta+Alt+K,Meta+Alt+Up,Switch to Window Above'
# Shortcuts - Show Desktop Grid (Meta+Tab)
unsudo kwriteconfig5 --file kglobalshortcutsrc --group plasmashell --key "next activity" ",Meta+Tab,Walk through activities"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key ShowDesktopGrid "Meta+Tab,Ctrl+F8,Show Desktop Grid"
# Shortcuts - Present All Windows (Meta+Space)
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "ExposeAll" $'Meta+Space\tLaunch (C),Ctrl+F10\tLaunch (C),Toggle Present Windows (All desktops)'

# Install KWin Script Krohnkite Tiling
if [ ! -d ${home}/.local/share/kwin/scripts/krohnkite ]; then
    unsudo wget -P /tmp https://github.com/esjeon/krohnkite/releases/download/v0.7/krohnkite-0.7.kwinscript
    unsudo plasmapkg2 -t kwinscript -i /tmp/krohnkite-0.7.kwinscript
    unsudo mkdir -p ${home}/.local/share/kservices5/
    unsudo ln -s ${home}/.local/share/kwin/scripts/krohnkite/metadata.desktop ${home}/.local/share/kservices5/krohnkite.desktop
fi
# Enable Krohnkite Plugin
unsudo kwriteconfig5 --file kwinrc --group Plugins --key "krohnkiteEnabled" --type bool true
# Configure Krohnkite
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key enableFloatingLayout --type bool true
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key enableQuarterLayout --type bool true
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key layoutPerDesktop --type bool true
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key maximizeSoleTile --type bool true
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key noTileBorder --type bool true
unsudo kwriteconfig5 --file kwinrc --group Script-krohnkite --key pollMouseXdotool --type bool true
# Set Global Shortcuts
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Cycle Layout" "Meta+/,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Decrease" "Meta+Shift+O,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Down/Next" "Meta+J,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Float" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Float All" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Floating Layout" "Meta+Shift+F,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Grow Height" "Meta+Ctrl+J,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Grow Width" "Meta+Ctrl+L,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Increase" "Meta+Shift+I,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Left" "Meta+H,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Monocle Layout" ",none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Down/Next" "Meta+Shift+J,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Left" "Meta+Shift+H,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Right" "Meta+Shift+L,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Up/Prev" "Meta+Shift+K,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Next Layout" "Meta+\\,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Previous Layout" "Meta+|,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Quarter Layout" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Right" "Meta+G,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Set master" "Meta+Return,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Shrink Height" "Meta+Ctrl+K,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Shrink Width" "Meta+Ctrl+H,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Spread Layout" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Stair Layout" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Three Column Layout" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Tile Layout" "none,none,"
unsudo kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Up/Prev" "Meta+K,none,"

# Install plasmoids
# System Load Viewer - https://store.kde.org/s/KDE%20Store/p/1474921
unsudo /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1474921
# Event Calendar - https://store.kde.org/s/KDE%20Store/p/998901
unsudo /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/998901
# Window Title Applet - https://store.kde.org/s/KDE%20Store/p/1274218
unsudo /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1274218
# Simple Menu - https://store.kde.org/s/KDE%20Store/p/1169537
unsudo /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1169537
# TODO: Edit ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu/contents/ui/MenuRepresentation.qml

# Setup latte-dock
unsudo kwriteconfig5 --file lattedockrc --group UniversalSettings --key currentLayout JonTheBurger
unsudo kwriteconfig5 --file lattedockrc --group UniversalSettings --key lastNonAssignedLayout JonTheBurger

# Remove default panel
cat <<EOF > ${home}/.config/plasma-org.kde.plasma.desktop-appletsrc
[ActionPlugins][0]
MidButton;NoModifier=org.kde.paste
RightButton;NoModifier=org.kde.contextmenu
wheel:Vertical;NoModifier=org.kde.switchdesktop

[ActionPlugins][1]
RightButton;NoModifier=org.kde.contextmenu

[Containments][2]
activityId=$(qdbus org.kde.ActivityManager /ActivityManager/Activities ListActivities | head -n 1)
formfactor=0
immutability=1
lastScreen=0
location=0
plugin=org.kde.plasma.folder
wallpaperplugin=org.kde.image

[Containments][2][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/Next/contents/images/1920x1080.jpg

[ScreenMapping]
itemsOnDisabledScreens=
screenMapping=
EOF
chown $SUDO_USER:$SUDO_USER ${home}/.config/plasma-org.kde.plasma.desktop-appletsrc

# Konsole
unsudo kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile JonTheBurger.profile

# Dolphin
unsudo kwriteconfig5 --file dolphinrc --group VersionControl --key enabledPlugins Git

# GTK
cat <<EOF > ${home}/.gtkrc-2.0
gtk-theme-name="Breeze-Dark"

gtk-enable-animations=1

gtk-primary-button-warps-slider=0

gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ

gtk-menu-images=1

gtk-button-images=1

gtk-cursor-theme-name="breeze_cursors"

gtk-icon-theme-name="Papirus-Dark"

gtk-font-name="Noto Sans,  10"

gtk-modules=appmenu-gtk-module
EOF
chown $SUDO_USER:$SUDO_USER ${home}/.gtkrc-2.0

# Desktop Wallpaper
WALLPAPER_NAME=NATURE.jpg
unsudo qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops(); print(allDesktops); for (i=0;i<allDesktops.length;i++) { d = allDesktops[i]; d.wallpaperPlugin = 'org.kde.image'; d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General'); d.writeConfig('Image', 'file://${home}/.local/share/wallpapers/${WALLPAPER_NAME}'); }"

echo "REBOOT NOW!"
