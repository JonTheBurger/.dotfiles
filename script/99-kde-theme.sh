#!/bin/bash
if [[ $EUID -eq 0 ]]; then
    echo "This script must be run as a non-root user"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y \
      dolphin-plugins \
      papirus-icon-theme \
      xdotool
    # Layan-GTK
    sudo snap install layan-themes
    # Apply to all other snap applications
    # FIXME: which one of these bad boys gets sudo
    #for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk '{print $2}'); do snap connect $i layan-themes:gtk-3-themes; done
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

# Download Layan KDE
if [ ! -d /tmp/Layan ]; then
    mkdir -p ~/.local/src
    git clone --depth 1 https://github.com/vinceliuice/Layan-kde.git ~/.local/src/Layan
fi

# Look & Feel
/usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://lookandfeel.knsrc/api.kde-look.org/1325241
lookandfeeltool --apply Layan

# SDDM Theme
if [ ! -d "/usr/share/sddm/themes/sddm-sugar-candy-master" ]; then
    sudo wget https://framagit.org/MarianArlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz -O /tmp/sddm-sugar-candy-master.tar.gz
    sudo tar -xf /tmp/sddm-sugar-candy-master.tar.gz -C /usr/share/sddm/themes
    sudo kwriteconfig5 --file /etc/sddm.conf --group Theme --key Current sddm-sugar-candy-master
    echo 'ForceHideCompletePassword="true"' | sudo tee -a /usr/share/sddm/themes/sddm-sugar-candy-master/theme.conf.user
fi

# Kvantum Theme
if [ ! -d "~/.config/Kvantum/Layan" ]; then
    mkdir -p ~/.config/Kvantum/Layan
    cp /tmp/Layan/Kvantum/Layan/Layan.kvconfig ~/.config/Kvantum/Layan
    cp /tmp/Layan/Kvantum/Layan/Layan.svg ~/.config/Kvantum/Layan
fi
kwriteconfig5 --file ~/.config/Kvantum/kvantum.kvconfig --group General --key theme Layan
kwriteconfig5 --file ~/.config/Kvantum/Layan/Layan.kvconfig --group Hacks --key transparent_dolphin_view --type bool true

# Widget Style
kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle 'kvantum-dark'

# Color Scheme
if [ ! -d "~/.local/share/color-schemes/Layan.colors" ]; then
    mkdir -p ~/.local/share/color-schemes
    cp /tmp/Layan/color-schemes/Layan.colors ~/.local/share/color-schemes
fi
kwriteconfig5 --file kdeglobals --group General --key ColorScheme Layan

# Window Decorations
if [ ! -d "~/.local/share/aurorae/themes/Sweet" ]; then
    git clone --depth 1 --branch nova https://github.com/EliverLara/Sweet.git /tmp/Sweet
    mkdir -p ~/.local/share/aurorae/themes
    cp -r /tmp/Sweet/kde/aurorae/Sweet-Dark-transparent ~/.local/share/aurorae/themes/Sweet-Dark-transparent
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
kwriteconfig5 --file kwinrc --group Compositing --key AnimationSpeed 3
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
kwriteconfig5 --file kwinrc --group Plugins --key minimizeallEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key resizeEnabled --type bool true
kwriteconfig5 --file kwinrc --group Plugins --key screenedgeEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key slidingpopupsEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key synchronizeskipswitcherEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key videowallEnabled --type bool false

# Disable autolocking the screen after T minutes
kwriteconfig5 --file kscreenlockerrc --group Daemon --key Autolock --type bool false

# 4 virtual desktops
kwriteconfig5 --file kwinrc --group Desktops --key Id_2 $(uuidgen)
kwriteconfig5 --file kwinrc --group Desktops --key Id_3 $(uuidgen)
kwriteconfig5 --file kwinrc --group Desktops --key Id_4 $(uuidgen)
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

# Shortcuts - Switch Virtual Desktop (Meta+Ctrl+Shift+H/J/K/L || Meta+Ctrl+Arrows)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" $'Meta+Ctrl+Down\tMeta+Ctrl+Shift+J,Meta+Ctrl+Down,Switch One Desktop Down'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" $'Meta+Ctrl+Up\tMeta+Ctrl+Shift+K,Meta+Ctrl+Up,Switch One Desktop Up'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" $'Meta+Ctrl+Left\tMeta+Ctrl+Shift+H,Meta+Ctrl+Left,Switch One Desktop to the Left'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" $'Meta+Ctrl+Right\tMeta+Ctrl+Shift+L,Meta+Ctrl+Right,Switch One Desktop to the Right'
# Shortcuts - Switch to Window (Meta+Alt+H/J/K/L)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Down" $'Meta+Alt+Down\tMeta+Alt+J,Meta+Alt+Down,Switch to Window Below'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Left" $'Meta+Alt+Left\tMeta+Alt+H,Meta+Alt+Left,Switch to Window to the Left'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Right" $'Meta+Alt+Right\tMeta+Alt+L,Meta+Alt+Right,Switch to Window to the Right'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch Window Up" $'Meta+Alt+Up\tMeta+Alt+K,Meta+Alt+Up,Switch to Window Above'
# Shortcuts - Show Desktop Grid (Meta+Tab)
kwriteconfig5 --file kglobalshortcutsrc --group plasmashell --key "next activity" ",Meta+Tab,Walk through activities"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key ShowDesktopGrid "Meta+Tab,Ctrl+F8,Show Desktop Grid"
# Shortcuts - Present All Windows (Meta+Space)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "ExposeAll" $'Meta+Space\tLaunch (C),Ctrl+F10\tLaunch (C),Toggle Present Windows (All desktops)'

# Install KWin Script Krohnkite Tiling
if [ ! -d ~/.local/share/kwin/scripts/krohnkite ]; then
    wget -P /tmp https://github.com/esjeon/krohnkite/releases/download/v0.7/krohnkite-0.7.kwinscript
    plasmapkg2 -t kwinscript -i /tmp/krohnkite-0.7.kwinscript
    mkdir -p ~/.local/share/kservices5/
    ln -sf ~/.local/share/kwin/scripts/krohnkite/metadata.desktop ~/.local/share/kservices5/krohnkite.desktop
fi
# Enable Krohnkite Plugin
kwriteconfig5 --file kwinrc --group Plugins --key "krohnkiteEnabled" --type bool true
# Configure Krohnkite
kwriteconfig5 --file kwinrc --group Script-krohnkite --key enableFloatingLayout --type bool true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key enableQuarterLayout --type bool true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key layoutPerDesktop --type bool true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key maximizeSoleTile --type bool true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key noTileBorder --type bool true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key pollMouseXdotool --type bool true
# Set Global Shortcuts
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Cycle Layout" "Meta+/,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Decrease" "Meta+Shift+O,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Down/Next" "Meta+J,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Float" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Float All" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Floating Layout" "Meta+Shift+F,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Grow Height" "Meta+Ctrl+J,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Grow Width" "Meta+Ctrl+L,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Increase" "Meta+Shift+I,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Left" "Meta+H,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Monocle Layout" ",none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Down/Next" "Meta+Shift+J,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Left" "Meta+Shift+H,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Right" "Meta+Shift+L,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Move Up/Prev" "Meta+Shift+K,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Next Layout" "Meta+\\,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Previous Layout" "Meta+|,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Quarter Layout" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Right" "Meta+G,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Set master" "Meta+Return,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Shrink Height" "Meta+Ctrl+K,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Shrink Width" "Meta+Ctrl+H,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Spread Layout" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Stair Layout" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Three Column Layout" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Tile Layout" "none,none,"
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Krohnkite: Up/Prev" "Meta+K,none,"

# Install plasmoids
# System Load Viewer - https://store.kde.org/s/KDE%20Store/p/1474921
if [ ! -d ~/.local/share/plasma/plasmoids/org.kde.plasma.systemloadviewer ]; then
    /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1474921
fi
# Event Calendar - https://store.kde.org/s/KDE%20Store/p/998901
if [ ! -d ~/.local/share/plasma/plasmoids/org.kde.plasma.eventcalendar ]; then
    /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/998901
fi
# Window Title Applet - https://store.kde.org/s/KDE%20Store/p/1274218
if [ ! -d ~/.local/share/plasma/plasmoids/org.kde.windowtitle ]; then
    /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1274218
fi
# Simple Menu - https://store.kde.org/s/KDE%20Store/p/1169537
if [ ! -d ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu ]; then
    /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://plasmoids.knsrc/api.kde-look.org/1169537
fi
# Center SimpleMenu Above Dock
sed -ie 's/x = (appletTopLeft.x < horizMidPoint) ? screen.x + offset : (screen.x + screen.width) - width - offset;/x = screen.x + (screen.width \/ 2) - (width \/ 2);/g' ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu/contents/ui/MenuRepresentation.qml
sed -ie 's/y = screen.height - height - offset - panelSvg.margins.top;/y = screen.y + screen.height - height - appletTopLeft.y - offset;' ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu/contents/ui/MenuRepresentation.qml

# Setup latte-dock
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

# Konsole
kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile JonTheBurger.profile

# Kate
kwriteconfig5 --file katerc --group General --key "Startup Session" last
kwriteconfig5 --file katerc --group "KTextEditor Renderer" --key Schema "Breeze Dark"
kwriteconfig5 --file katerc --group UiSettings --key ColorScheme Layan
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key externaltoolsplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katebacktracebrowserplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katebuildplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katecloseexceptplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katectagsplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katefilebrowserplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katefiletreeplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key kategdbplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katekonsoleplugin --type bool true
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key kateopenheaderplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key kateprojectplugin --type bool true
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katereplicodeplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katesearchplugin --type bool true
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katesnippetsplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katesqlplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katesymbolviewerplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katexmlcheckplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key katexmltoolsplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key ktexteditorpreviewplugin --type bool true
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key lspclientplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key tabswitcherplugin --type bool false
kwriteconfig5 --file ~/.local/share/kate/anonymous.katesession --group "Kate Plugins" --key textfilterplugin --type bool true

# Dolphin
kwriteconfig5 --file dolphinrc --group VersionControl --key enabledPlugins Git

# GTK
mkdir -p ~/.themes/Layan-dark
ln -sf /snap/layan-themes/current/share/gtk2/Layan-dark/gtk-2.0 ~/.themes/Layan-dark/gtk-2.0
ln -sf /snap/layan-themes/current/share/themes/Layan-dark/gtk-3.0/ ~/.themes/Layan-dark/gtk-3.0

# Desktop Wallpaper
WALLPAPER_NAME=NATURE.jpg
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops(); print(allDesktops); for (i=0;i<allDesktops.length;i++) { d = allDesktops[i]; d.wallpaperPlugin = 'org.kde.image'; d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General'); d.writeConfig('Image', 'file://${HOME}/.local/share/wallpapers/${WALLPAPER_NAME}'); }"

echo "REBOOT NOW!"
