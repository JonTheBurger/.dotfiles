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
    apt-get install -y \
      papirus-icon-theme \
      xdotool
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
kwriteconfig5 --file kwinrc --group Plugins --key minimizeallEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key resizeEnabled --type bool true
kwriteconfig5 --file kwinrc --group Plugins --key screenedgeEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key slidingpopupsEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key synchronizeskipswitcherEnabled --type bool false
kwriteconfig5 --file kwinrc --group Plugins --key videowallEnabled --type bool false

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

# Shortcuts - Switch Virtual Desktop (Meta+Ctrl+Shift+H/J/K/L || Meta+Ctrl+Arrows)
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Down" $'Meta+Ctrl+Down\tMeta+Ctrl+Shift+J,Meta+Ctrl+Down,Switch One Desktop Down'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop Up" $'Meta+Ctrl+Up\tMeta+Ctrl+Shift+K,Meta+Ctrl+Up,Switch One Desktop Up'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Left" $'Meta+Ctrl+Left\tMeta+Ctrl+Shift+H,Meta+Ctrl+Left,Switch One Desktop to the Left'
kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch One Desktop to the Right" $'Meta+Ctrl+Right\tMeta+Ctrl+Shift+L,Meta+Ctrl+Right,Switch One Desktop to the Right'
# Shortcuts - Switch to Window (Meta+Alt+H/J/K/L)
Switch Window Down=Meta+Alt+Down\tMeta+Alt+J,Meta+Alt+Down,Switch to Window Below
Switch Window Left=Meta+Alt+Left\tMeta+Alt+H,Meta+Alt+Left,Switch to Window to the Left
Switch Window Right=Meta+Alt+Right\tMeta+Alt+L,Meta+Alt+Right,Switch to Window to the Right
Switch Window Up=Meta+Alt+Up\tMeta+Alt+K,Meta+Alt+Up,Switch to Window Above
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
[ActionPlugins][1]
RightButton;NoModifier=org.kde.latte.contextmenu

[Containments][1]
activityId=
byPassWM=false
dockWindowBehavior=true
enableKWinEdges=true
formfactor=2
immutability=1
isPreferredForShortcuts=false
lastScreen=-1
location=4
onPrimary=true
plugin=org.kde.latte.containment
raiseOnActivityChange=false
raiseOnDesktopChange=false
settingsComplexity=4
timerHide=100
timerShow=100
viewType=0
visibility=2
wallpaperplugin=org.kde.image

[Containments][1][Applets][57]
immutability=1
plugin=org.kde.latte.plasmoid

[Containments][1][Applets][57][Configuration]
PreloadWeight=42

[Containments][1][Applets][57][Configuration][General]
isInLatteDock=true
launchers59=applications:org.kde.konsole.desktop,applications:org.kde.dolphin.desktop,applications:firefox.desktop

[Containments][1][Applets][87]
immutability=1
plugin=org.kde.plasma.simplemenu

[Containments][1][Applets][87][Configuration]
PreloadWeight=92

[Containments][1][Applets][87][Configuration][ConfigDialog]
DialogHeight=540
DialogWidth=720

[Containments][1][Applets][87][Configuration][General]
customButtonImage=application-vnd.iccprofile
favoritesPortedToKAstats=true
useCustomButtonImage=true

[Containments][1][ConfigDialog]
DialogHeight=921
DialogWidth=539

[Containments][1][Configuration]
PreloadWeight=42

[Containments][1][General]
advanced=false
appletOrder=87;57
autoDecreaseIconSize=false
blurEnabled=false
hoverAction=PreviewAndHighlightWindows
iconMargin=0
iconSize=48
inConfigureAppletsMode=true
maxLength=90
panelShadows=false
panelSize=14
panelTransparency=70
shadowOpacity=35
shadowSize=45
showGlow=false
showOnlyCurrentDesktop=true
shrinkThickMargins=true
splitterPosition=2
splitterPosition2=3

[Containments][1][Indicator]
customType=
enabled=true
enabledForApplets=true
padding=0.03999999910593033
type=org.kde.latte.default

[Containments][1][Indicator][org.kde.latte.default][General]
activeStyle=Dot
extraDotOnActive=true
glowEnabled=true
glowOpacity=1

[Containments][61]
activityId=
byPassWM=false
enableKWinEdges=true
formfactor=2
immutability=1
isPreferredForShortcuts=false
lastScreen=-1
location=3
onPrimary=true
plugin=org.kde.latte.containment
raiseOnActivityChange=false
raiseOnDesktopChange=false
settingsComplexity=4
timerHide=700
timerShow=0
viewType=1
visibility=0
wallpaperplugin=org.kde.image

[Containments][61][Applets][64]
immutability=1
plugin=org.kde.plasma.appmenu

[Containments][61][Applets][64][Configuration]
PreloadWeight=42

[Containments][61][Applets][67]
immutability=1
plugin=org.kde.plasma.eventcalendar

[Containments][61][Applets][67][Configuration]
PreloadWeight=67

[Containments][61][Applets][67][Configuration][ConfigDialog]
DialogHeight=540
DialogWidth=720

[Containments][61][Applets][67][Configuration][General]
v71Migration=true
v72Migration=true

[Containments][61][Applets][67][Configuration][Google Calendar]
calendarList=W10=
tasklistList=W10=

[Containments][61][Applets][68]
immutability=1
plugin=org.kde.plasma.pager

[Containments][61][Applets][68][Configuration]
PreloadWeight=42

[Containments][61][Applets][69]
immutability=1
plugin=org.kde.plasma.systemloadviewer

[Containments][61][Applets][69][Configuration]
PreloadWeight=42

[Containments][61][Applets][70]
immutability=1
plugin=org.kde.plasma.systemtray

[Containments][61][Applets][70][Configuration]
PreloadWeight=52
SystrayContainmentId=71

[Containments][61][Applets][88]
immutability=1
plugin=org.kde.windowtitle

[Containments][61][Applets][88][Configuration]
PreloadWeight=42

[Containments][61][Applets][88][Configuration][ConfigDialog]
DialogHeight=540
DialogWidth=720

[Containments][61][Applets][88][Configuration][General]
containmentType=Latte
filterActivityInfo=false

[Containments][61][ConfigDialog]
DialogHeight=923
DialogWidth=539

[Containments][61][Configuration]
PreloadWeight=42

[Containments][61][General]
addLaunchersInTaskManager=false
animationLauncherBouncing=false
animationWindowAddedInGroup=false
animationWindowInAttention=false
appletOrder=88;64;67;70;69;68
dragActiveWindowEnabled=true
groupTasksByDefault=false
iconSize=16
panelPosition=10
panelSize=100
panelTransparency=35
plasmaBackgroundForPopups=true
proportionIconSize=2
shadows=None
showAudioBadge=false
showInfoBadge=false
showOnlyCurrentActivity=false
showProgressBadge=false
splitterPosition=2
splitterPosition2=4
titleTooltips=false
zoomLevel=0

[Containments][61][Indicator]
customType=
enabled=true
enabledForApplets=true
padding=0.07999999821186066
type=org.kde.latte.default

[Containments][71]
PreloadWeight=42
activityId=
formfactor=2
immutability=1
lastScreen=-1
location=3
plugin=org.kde.plasma.private.systemtray
wallpaperplugin=org.kde.image

[Containments][71][Applets][72]
immutability=1
plugin=org.kde.plasma.volume

[Containments][71][Applets][72][Configuration]
PreloadWeight=42

[Containments][71][Applets][73]
immutability=1
plugin=org.kde.plasma.clipboard

[Containments][71][Applets][73][Configuration]
PreloadWeight=42

[Containments][71][Applets][74]
immutability=1
plugin=org.kde.plasma.devicenotifier

[Containments][71][Applets][74][Configuration]
PreloadWeight=42

[Containments][71][Applets][75]
immutability=1
plugin=org.kde.kdeconnect

[Containments][71][Applets][75][Configuration]
PreloadWeight=42

[Containments][71][Applets][76]
immutability=1
plugin=org.kde.plasma.keyboardindicator

[Containments][71][Applets][76][Configuration]
PreloadWeight=42

[Containments][71][Applets][77]
immutability=1
plugin=org.kde.plasma.nightcolorcontrol

[Containments][71][Applets][77][Configuration]
PreloadWeight=42

[Containments][71][Applets][78]
immutability=1
plugin=org.kde.plasma.notifications

[Containments][71][Applets][78][Configuration]
PreloadWeight=42

[Containments][71][Applets][79]
immutability=1
plugin=org.kde.plasma.printmanager

[Containments][71][Applets][79][Configuration]
PreloadWeight=42

[Containments][71][Applets][80]
immutability=1
plugin=org.kde.plasma.vault

[Containments][71][Applets][80][Configuration]
PreloadWeight=42

[Containments][71][Applets][82]
immutability=1
plugin=org.kde.plasma.networkmanagement

[Containments][71][Applets][82][Configuration]
PreloadWeight=42

[Containments][71][Applets][83]
immutability=1
plugin=org.kde.plasma.bluetooth

[Containments][71][Applets][83][Configuration]
PreloadWeight=42

[Containments][71][Applets][89]
immutability=1
plugin=org.kde.plasma.battery

[Containments][71][General]
extraItems=org.kde.plasma.volume,org.kde.plasma.clipboard,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.plasma.nightcolorcontrol,org.kde.kdeconnect,org.kde.plasma.battery,org.kde.plasma.vault,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier
knownItems=org.kde.plasma.volume,org.kde.plasma.clipboard,org.kde.plasma.keyboardindicator,org.kde.plasma.printmanager,org.kde.plasma.nightcolorcontrol,org.kde.kdeconnect,org.kde.plasma.battery,org.kde.plasma.vault,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier

[LayoutSettings]
activities=
background=
color=lightskyblue
globalLaunchers=
lastUsedActivity=$(qdbus org.kde.ActivityManager /ActivityManager/Activities ListActivities | head -n 1)
launchers=
preferredForShortcutsTouched=false
showInMenu=true
textColor=fcfcfc
version=2
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
cat <<EOF > ~/.local/share/konsole/JonTheBurger.profile
[Appearance]
ColorScheme=Linux

[General]
Command=/usr/bin/tmux
Name=JonTheBurger
Parent=FALLBACK/

[Interaction Options]
CopyTextAsHTML=false

[Scrolling]
HistoryMode=2
EOF
kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile JonTheBurger.profile

# GTK
cat <<EOF > ~/.gtkrc-2.0
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

# Desktop Wallpaper
mkdir -p ~/.local/share/wallpapers
WALLPAPER_NAME=wallpaper.png
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {
        d = allDesktops[i];
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = Array('Wallpaper',
                                    'org.kde.image',
                                    'General');
        d.writeConfig('Image', 'file://${HOME}/.local/share/wallpapers/${WALLPAPER_NAME}')
    }"

# Reconfigure KWin to Apply Changes
qdbus org.kde.kwin /KWin reconfigure
