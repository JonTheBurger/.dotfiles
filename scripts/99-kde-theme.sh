#!/usr/bin/env bash
# ======================================================================================
## @file 99-kde-theme.sh
## Customizes KDE Desktop.
# UN-COMMENT FOR LSP SUPPORT
#. "detail/util.sh"
# ======================================================================================
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "${SCRIPT_DIR}/detail/util.sh"

main() {
  util::setup

  util::notice "Welcome!"
  util::info "
This script customizes the ${CYAN}KDE Desktop${NOFMT}. This one is all or nothing,
so consider reading the script before executing.
"

  if util::prompt "Should I continue"; then
    util::println
    util::notice "Ok, setting up now"
    util::println
  else
    util::notice "-- Au revoir! --"
    exit ${UTIL_SUCCESS}
  fi

  if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y \
      dolphin-plugins \
      papirus-icon-theme \
      xdotool
    # Layan-GTK
    sudo snap install layan-themes
    # Apply to all other snap applications
    sudo bash -c 'for i in $(snap connections | grep gtk-common-themes:gtk-3-themes | awk "{print \$2}"); do snap connect $i layan-themes:gtk-3-themes; done'
  fi

  # Layan Global Theme https://store.kde.org/p/1325243/
  /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://lookandfeel.knsrc/api.kde-look.org/1325243
  # Layan Plasma Theme https://store.kde.org/p/1325241/
  /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://lookandfeel.knsrc/api.kde-look.org/1325241
  # Look & Feel
  lookandfeeltool --apply com.github.vinceliuice.Layan

  # Splash Screen
  /usr/lib/x86_64-linux-gnu/libexec/kf5/kpackagehandlers/knshandler kns://lookandfeel.knsrc/api.kde-look.org/1304256
  # https://store.kde.org/p/1304256
  # https://store.kde.org/p/1426182
  # https://store.kde.org/p/1424150
  # https://store.kde.org/p/1505562
  # https://store.kde.org/p/1447068
  # https://store.kde.org/p/1453401
  # https://store.kde.org/p/1460249
  kwriteconfig5 --file ksplashrc --group KSplash --key Theme QuarksSplashDark

  # SDDM Theme
  if [ ! -d "/usr/share/sddm/themes/sddm-sugar-candy-master" ]; then
    sudo wget https://framagit.org/MarianArlt/sddm-sugar-candy/-/archive/master/sddm-sugar-candy-master.tar.gz -O /tmp/sddm-sugar-candy-master.tar.gz
    sudo tar -xf /tmp/sddm-sugar-candy-master.tar.gz -C /usr/share/sddm/themes
    sudo kwriteconfig5 --file /etc/sddm.conf --group Theme --key Current sddm-sugar-candy-master
    echo 'ForceHideCompletePassword="true"' | sudo tee -a /usr/share/sddm/themes/sddm-sugar-candy-master/theme.conf.user
  fi

  # Download Layan KDE
  if [ ! -d ~/.local/src/Layan ]; then
    mkdir -p ~/.local/src
    git clone --depth 1 https://github.com/vinceliuice/Layan-kde.git ~/.local/src/Layan
  fi

  # Kvantum Theme
  if [ ! -d "~/.config/Kvantum/Layan" ]; then
    mkdir -p ~/.config/Kvantum/Layan
    ln -s ~/.local/src/Layan/Kvantum/Layan/Layan.kvconfig ~/.config/Kvantum/Layan
    ln -s ~/.local/src/Layan/Kvantum/Layan/Layan.svg ~/.config/Kvantum/Layan
  fi
  kwriteconfig5 --file ~/.config/Kvantum/kvantum.kvconfig --group General --key theme Layan
  kwriteconfig5 --file ~/.config/Kvantum/Layan/Layan.kvconfig --group Hacks --key transparent_dolphin_view --type bool true

  # Widget Style
  kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle 'kvantum-dark'

  # Color Scheme
  if [ ! -d "~/.local/share/color-schemes/Layan.colors" ]; then
    mkdir -p ~/.local/share/color-schemes
    ln -s ~/.local/src/Layan/color-schemes/Layan.colors ~/.local/share/color-schemes/Layan.colors
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

  # Reload changes
  qdbus org.kde.KWin /KWin reconfigure

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
  kwriteconfig5 --file kglobalshortcutsrc --group plasmashell --key "next activity" ",none,Walk through activities"
  kwriteconfig5 --file kglobalshortcutsrc --group kwin --key ShowDesktopGrid "Meta+Tab,Ctrl+F8,Show Desktop Grid"
  # Shortcuts - Present All Windows (Meta+Space)
  kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "ExposeAll" $'Meta+Space\tLaunch (C),Ctrl+F10\tLaunch (C),Toggle Present Windows (All desktops)'
  # Reload Keyboard Shortcuts https://www.reddit.com/r/kde/comments/6u0wo7/configuring_kde_by_editing_the_config_files/dlqzeop
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &
  qdbus org.kde.KWin /KWin reconfigure

  # Reload Keyboard Shortcuts https://www.reddit.com/r/kde/comments/6u0wo7/configuring_kde_by_editing_the_config_files/dlqzeop
  kquitapp5 kglobalaccel && sleep 2s && kglobalaccel5 &

  # Force NumLock On
  kwriteconfig5 --file kcminputrc --group Keyboard --key "NumLock" 0

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
  sed -ie 's/y = screen.height - height - offset - panelSvg.margins.top;/y = screen.y + screen.height - height - appletTopLeft.y - offset;/g' ~/.local/share/plasma/plasmoids/org.kde.plasma.simplemenu/contents/ui/MenuRepresentation.qml

  # Setup latte-dock
  kwriteconfig5 --file lattedockrc --group UniversalSettings --key currentLayout JonTheBurger
  kwriteconfig5 --file lattedockrc --group UniversalSettings --key lastNonAssignedLayout JonTheBurger
  if [ -f ~/.config/latte/Default.layout.latte ]; then
    mv ~/.config/latte/Default.layout.latte ~/.config/latte/Default.layout.latte.bkp
  fi
  ln -s ~/.config/latte/JonTheBurger.layout.latte ~/.config/latte/Default.layout.latte
  latte-dock --layout JonTheBurger &

  # Desktop Wallpaper
  WALLPAPER_NAME=NATURE.jpg
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops(); print(allDesktops); for (i=0;i<allDesktops.length;i++) { d = allDesktops[i]; d.wallpaperPlugin = 'org.kde.image'; d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General'); d.writeConfig('Image', 'file://${HOME}/.local/share/wallpapers/${WALLPAPER_NAME}'); }"

  # Remove default panel
  cat <<EOF >~/.config/plasma-org.kde.plasma.desktop-appletsrc
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
Image=file://${HOME}/.local/share/wallpapers/${WALLPAPER_NAME}

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

  # Reload changes
  qdbus org.kde.KWin /KWin reconfigure

  util::notice "Reboot Now!"
}

main "$@"
