#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
home="/home/$SUDO_USER"
alias unsudo="sudo -Hu $SUDO_USER"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y papirus-icon-theme extra-cmake-modules
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

if [ ! -d /tmp/Layan ]; then
    sudo -Hu $SUDO_USER git clone --depth 1 https://github.com/vinceliuice/Layan-kde.git /tmp/Layan
fi

# Look & Feel
#sudo -Hu $SUDO_USER lookandfeeltool --apply org.kde.breezedark.desktop

# SDDM Theme
if [ ! -d "/usr/share/sddm/themes/sddm-sugar-candy-master" ]
    wget https://framagit.org/MarianArlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz -O /tmp/sddm-sugar-candy-master.tar.gz
    tar -xf /tmp/sddm-sugar-candy-master.tar.gz -C /usr/share/sddm/themes
    kwriteconfig5 --file /etc/sddm.conf --group Theme --key Current sddm-sugar-candy-master
fi

# Kvantum Theme
if [ ! -d "${home}/.config/Kvantum/Layan" ]; then
    sudo -Hu $SUDO_USER mkdir -P ${home}/.config/Kvantum/Layan
    sudo -Hu $SUDO_USER cp /tmp/Layan/Kvantum/Layan/Layan.kvconfig ${home}/.config/Kvantum/Layan
    sudo -Hu $SUDO_USER cp /tmp/Layan/Kvantum/Layan/Layan.svg ${home}/.config/Kvantum/Layan
    #sudo -Hu $SUDO_USER wget -P ${home}/.config/Kvantum/Layan https://raw.githubusercontent.com/vinceliuice/Layan-kde/master/Kvantum/Layan/Layan.kvconfig
    #sudo -Hu $SUDO_USER wget -P ${home}/.config/Kvantum/Layan https://raw.githubusercontent.com/vinceliuice/Layan-kde/master/Kvantum/Layan/Layan.svg
fi
sudo -Hu $SUDO_USER kwriteconfig5 --file ${home}/.config/Kvantum/kvantum.kvconfig --group General --key theme Layan
sudo -Hu $SUDO_USER kwriteconfig5 --file ~/.config/Kvantum/Layan/Layan.kvconfig --group Hacks --key transparent_dolphin_view --type bool true

# Widget Style
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle 'kvantum-dark'

# Color Scheme
if [ ! -d "${home}/.local/share/color-schemes/Layan.colors" ]; then
    mkdir -p ${home}/.local/share/color-schemes
    cp /tmp/Layan/color-schemes/Layan.colors ${home}/.local/share/color-schemes
    #sudo -Hu $SUDO_USER wget -P ${home}/.local/share/color-schemes https://raw.githubusercontent.com/vinceliuice/Layan-kde/master/color-schemes/Layan.colors
fi
kwriteconfig5 --file kdeglobals --group General --key ColorScheme Layan

# Window Decorations
if [ ! -d "${home}/.local/share/aurorae/themes/Sweet" ]
    git clone --depth 1 --branch nova https://github.com/EliverLara/Sweet.git /tmp/Sweet
    cp -r /tmp/Sweet/kde/aurorae/Sweet-Dark-transparent ${home}/.local/share/aurorae/themes/Sweet-Dark-transparent
    kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key theme '__aurorae__svg__Sweet-Dark-transparent'
fi
# Add "Keep Above" button on left side of window decoration
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft 'MF'
# Slightly larger buttons
kwriteconfig5 --file auroraerc --group Sweet-Dark-transparent --key ButtonSize 2

# Icons
kwriteconfig5 --file kdeglobals --group Icons --key Theme 'Papirus-Dark'
kwriteconfig5 --file kdeglobals --group Emoticons --key emoticonsTheme 'EmojiOne'

# Faster animations
kwriteconfig5 --file kwinrc --group Compositing --key AnimationSpeed 2
kwriteconfig5 --file kwinrc --group Compositing --key Backend OpenGL
kwriteconfig5 --file kwinrc --group Compositing --key GLCore --type bool true
# Vsync only when cheap
kwriteconfig5 --file kwinrc --group Compositing --key GLPreferBufferSwap e
# "Crisp" scale method
kwriteconfig5 --file kwinrc --group Compositing --key GLTextureFilter 0

# Reduce noise for "Blur" desktop effect
kwriteconfig5 --file kwinrc --group Effect-Blur --key NoiseStrength 2
# Make "Present Windows" effect faster
kwriteconfig5 --file kwinrc --group Effect-PresentWindows --key Accuracy 6
# Make "Present Windows" middle click -> close window
kwriteconfig5 --file kwinrc --group MiddleButtonWindow --key Accuracy 6
# Disable several desktop effects
kwriteconfig5 --file kwinrc --group Plugins --key contrastEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadeEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_fadingpopupsEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_loginEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_logoutEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_maximizeEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_morphingpopupsEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_squashEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key kwin4_effect_windowapertureEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key resizeEnabled --type bool true
kwriteconfig5 --file kwinrc --group Plugins --key screenedgeEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key slidingpopupsEnabled --type bool false

# Disable autolocking the screen after T minutes
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock --type bool false

# 4 virtual desktops
kwriteconfig5 --file kwinrc --group Desktops --key Id_1 9669fb89-af20-426b-bfcd-78dd8b544746
kwriteconfig5 --file kwinrc --group Desktops --key Id_2 f03616dd-9e8f-4d8f-9538-478abe63d511
kwriteconfig5 --file kwinrc --group Desktops --key Id_3 30639d5d-f891-4113-a5c8-5f5bb84c3281
kwriteconfig5 --file kwinrc --group Desktops --key Id_4 8147bdd1-9220-45ad-8c0f-c71786252d18
kwriteconfig5 --file kwinrc --group Desktops --key Name_1 NW
kwriteconfig5 --file kwinrc --group Desktops --key Name_2 NE
kwriteconfig5 --file kwinrc --group Desktops --key Name_3 SW
kwriteconfig5 --file kwinrc --group Desktops --key Name_4 SE
kwriteconfig5 --file kwinrc --group Desktops --key Number 4
kwriteconfig5 --file kwinrc --group Desktops --key Rows 2

# Disable screen edge actions
kwriteconfig5 --file kwinrc --group ElectricBorders --key Bottom None
kwriteconfig5 --file kwinrc --group ElectricBorders --key BottomLeft None
kwriteconfig5 --file kwinrc --group ElectricBorders --key BottomRight None
kwriteconfig5 --file kwinrc --group ElectricBorders --key Left None
kwriteconfig5 --file kwinrc --group ElectricBorders --key Right None
kwriteconfig5 --file kwinrc --group ElectricBorders --key Top None
kwriteconfig5 --file kwinrc --group ElectricBorders --key TopLeft None
kwriteconfig5 --file kwinrc --group ElectricBorders --key TopRight None

# Mousewheel on window decoration changes opacity
kwriteconfig5 --file kwinrc --group MouseBindings --key CommandTitlebarWheel "Change Opacity"

# Use thumbnail Alt+Tab switcher
kwriteconfig5 --file kwinrc --group TabBox --key LayoutName thumbnails

# Disable baloo file indexing
kwriteconfig5 --file baloofilerc --group "Basic Settings" --key Indexing-Enabled --type bool false

# Disable most krunner search locations
kwriteconfig5 --file krunnerrc --group Plugins --key "CharacterRunnerEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "DictionaryEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "Kill RunnerEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "PowerDevilEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "Spell CheckerEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "baloosearchEnabled" --type bool true
kwriteconfig5 --file krunnerrc --group Plugins --key "bookmarksEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "browsertabsEnabled" --type bool true
kwriteconfig5 --file krunnerrc --group Plugins --key "calculatorEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "desktopsessionsEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "katesessionsEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "konsoleprofilesEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "krunner_appstreamEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "kwinEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "locationsEnabled" --type bool true
kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.activitiesEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.datetimeEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "org.kde.windowedwidgetsEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "placesEnabled" --type bool true
kwriteconfig5 --file krunnerrc --group Plugins --key "plasma-desktopEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "recentdocumentsEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "servicesEnabled" --type bool true
kwriteconfig5 --file krunnerrc --group Plugins --key "shellEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "unitconverterEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "webshortcutsEnabled" --type bool false
kwriteconfig5 --file krunnerrc --group Plugins --key "windowsEnabled" --type bool false

# Shortcuts - Switch Virtual Desktop (Meta+Ctrl+Up/Down/Left/Right)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" "Meta+Ctrl+Down,Meta+Ctrl+Down,Switch One Desktop Down"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" "Meta+Ctrl+Up,Meta+Ctrl+Up,Switch One Desktop Up"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" "Meta+Ctrl+Left,Meta+Ctrl+Left,Switch One Desktop to the Left"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" "Meta+Ctrl+Right,Meta+Ctrl+Right,Switch One Desktop to the Right"
# Shortcuts - Show Desktop Grid (Meta+Tab)
kwriteconfig5 --file kglobalshortcutsrc --group plasmashell --key "next activity" ",Meta+Tab,Walk through activities"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key ShowDesktopGrid "Meta+Tab,Ctrl+F8,Show Desktop Grid"
# Shortcuts - Present All Windows (Meta+Space)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "ExposeAll" $'Meta+Space\tLaunch (C),Ctrl+F10\tLaunch (C),Toggle Present Windows (All desktops)'

# Install KWin Script Krohnkite Tiling
wget -P /tmp https://github.com/esjeon/krohnkite/releases/download/v0.7/krohnkite-0.7.kwinscript
kpackagetool5 -t kwinscript -i /tmp/krohnkite-0.7.kwinscript
mkdir -p ~/.local/share/kservices5/
ln -s ~/.local/share/kwin/scripts/krohnkite/metadata.desktop ~/.local/share/kservices5/krohnkite.desktop

# Install plasmoids
# System Load Viewer - https://store.kde.org/s/KDE%20Store/p/1474921
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1474921
# Event Calendar - https://store.kde.org/s/KDE%20Store/p/998901
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/998901
# Window Title Applet - https://store.kde.org/s/KDE%20Store/p/1274218
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1274218
# Window Buttons Applet - https://store.kde.org/s/KDE%20Store/p/1272871
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1272871
# Simple Menu - https://store.kde.org/s/KDE%20Store/p/1169537
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1169537
# TODO: Edit ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu/contents/ui/MenuRepresentation.qml

# Setup latte-dock
mkdir -p ~/.config/latte
cat <<EOF > ~/.config/latte/JonTheBurger.layout.latte
EOF
kwriteconfig5 --file lattedockrc --group UniversalSettings --key currentLayout JonTheBurger
kwriteconfig5 --file lattedockrc --group UniversalSettings --key lastNonAssignedLayout JonTheBurger

# Remove default panel
cat <<EOF > ~/.config/plasma-org.kde.plasma.desktop-appletsrc
[ActionPlugins][0]
MidButton;NoModifier=org.kde.paste
RightButton;NoModifier=org.kde.contextmenu
wheel:Vertical;NoModifier=org.kde.switchdesktop

[ActionPlugins][1]
RightButton;NoModifier=org.kde.contextmenu

[Containments][2]
activityId=$(qdbus org.kde.ActivityManager /ActivityManager/Activities ListActivities)
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

qdbus org.kde.kwin /KWin reconfigure
# TODO: ~/.gtkrc-2.0
