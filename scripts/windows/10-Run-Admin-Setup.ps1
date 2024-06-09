<#
.SYNOPSIS
    Provides convenience functions for setting up a Windows machine with opinionated
    defaults suitable for programming and/or leisure.
.DESCRIPTION
    This script will prompt you at each step before making any changes, asking
    for permission before proceeding.
.PARAMETER Force
    Force all parameters to $false, ignoring any specified values.
.PARAMETER DoRemoveBloat
    Removes default installed applications often considered "bloatware" by power
    users.
.PARAMETER OptDir
    Root directory where portable software will be installed to. By default,
    this is set to "C:\opt".
.EXAMPLE
    C:\PS> .\10-Run-Admin-Setup -Force
    Runs all tasks without prompting
.LINK
    https://github.com/JonTheBurger/.dotfiles
.NOTES
#>
[CmdletBinding()]
param
(
    [switch] $Help,
    [switch] $Force,
    [nullable[bool]] $DoRemoveBloat,
    [string] $OptDir = "C:\opt",
    [string] $GodotVersion = "4.2.2",
    [string] $GodotUrl = "https://github.com/godotengine/godot/releases/download/${GodotVersion}-stable/Godot_v${GodotVersion}-stable_mono_win64.zip"
)

$ProgressPreference = "SilentlyContinue"
$Force = $Force.IsPresent
if ($Help.IsPresent) {
    Get-Help ".\10-Run-Admin-Setup.ps1"
    return
}

function Set-Registry {
    param (
        [string]$Key,
        [object]$Value,
        [string]$Type = "DWord" # or maybe ExpandString
    )
    $Path = Split-Path -Path $Key -Parent
    $Name = Split-Path -Path $Key -Leaf

    # Check if the registry key exists, and create it if it doesn't
    if (-not (Test-Path $Path)) {
        New-Item -Path "$Path" -Force | Out-Null
    }

    Set-ItemProperty -Path "$Path" -Name "$Name" -Value $Value -Type $Type -Force
}

function Remove-Bloatware {
    $applications = @(
        "*ACGMediaPlayer*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Amazon.com.Amazon*"
        "*Asphalt8Airborne*" 
        "*AutodeskSketchBook*"
        "*COOKINGFEVER*"
        "*CaesarsSlotsFreeCasino*"
        "*Clipchamp.Clipchamp*"
        "*CyberLinkMediaSuiteEssentials*"
        "*DisneyMagicKingdoms*"
        "*DrawboardPDF*"
        "*Duolingo-LearnLanguagesforFree*"
        "*EclipseManager*"
        "*Facebook*"
        "*FarmVille2CountryEscape*"
        "*Flipboard*"
        "*HULULLC.HULUPLUS*"
        "*HiddenCity*"
        "*LinkedInforWindows*"
        "*MarchofEmpires*"
        "*Microsoft.3DBuilder*"
        "*Microsoft.549981C3F5F10*"   #Cortana app
        "*Microsoft.Asphalt8Airborne*"
        "*Microsoft.BingFinance*"
        "*Microsoft.BingFoodAndDrink*"
        "*Microsoft.BingHealthAndFitness*"
        "*Microsoft.BingNews*"
        "*Microsoft.BingSports*"
        "*Microsoft.BingTranslator*"
        "*Microsoft.BingTravel* "
        "*Microsoft.BingWeather*"
        "*Microsoft.GetHelp*"
        "*Microsoft.MSPaint*"   # Paint 3D
        "*Microsoft.Messaging*"
        "*Microsoft.Microsoft3DViewer*"
        "*Microsoft.MicrosoftOfficeHub*"
        "*Microsoft.MicrosoftSolitaireCollection*"
        "*Microsoft.MixedReality.Portal*"
        "*Microsoft.NetworkSpeedTest*"
        "*Microsoft.News*"
        "*Microsoft.Office.OneNote*"
        "*Microsoft.Office.Sway*"
        "*Microsoft.OneConnect*"
        "*Microsoft.Print3D*"
        "*Microsoft.RemoteDesktop*"
        "*Microsoft.SkypeApp*"
        "*Microsoft.Todos*"
        "*Microsoft.WindowsAlarms*"
        "*Microsoft.WindowsFeedbackHub*"
        "*Microsoft.WindowsMaps*"
        "*Microsoft.WindowsSoundRecorder*"
        "*Microsoft.ZuneMusic*"
        "*Microsoft.ZuneVideo*"
        "*NYTCrossword*"
        "*Netflix*"
        "*OneCalendar*"
        "*PandoraMediaInc*"
        "*PhototasticCollage*"
        "*PicsArt-PhotoStudio*"
        "*Plex*"
        "*PolarrPhotoEditorAcademicEdition*"
        "*Royal Revolt*"
        "*Shazam*"
        "*Sidia.LiveWallpaper*"
        "*SlingTV*"
        "*Speed Test*"
        "*TikTok*"
        "*TuneInRadio*"
        "*Twitter*"
        "*Viber*"
        "*WinZipUniversal*"
        "*Wunderlist*"
        "*XING*"
        "*Zune*"
        "*fitbit*"
        "*iHeartRadio*"
        "*king.com.BubbleWitch3Saga*"
        "*king.com.CandyCrushSaga*"
        "*king.com.CandyCrushSodaSaga*"
    )

    # Query Parameters
    if ($Force) {
        $DoRemoveBloat = $true
    }
    elseif ($null -eq $DoRemoveBloat) {
        $appStr = $applications -join "`n"
        $message = "Shall I Remove Windows Bloatware?"
        $choices = @(
            [System.Management.Automation.Host.ChoiceDescription]::new("&Yes", "Remove the following:`n$appStr")
            [System.Management.Automation.Host.ChoiceDescription]::new("&No", "Do not remove any of the aforementioned applications")
        )
        $DoRemoveBloat = $Host.UI.PromptForChoice($null, $message, $choices, 1) -eq 0
    }

    if ($DoRemoveBloat -eq $true) {
        foreach ($app in $applications) {
            Write-Host "Removing $app"
            Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $app } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -AllUsers -PackageName $_.PackageName }
        }
    }
}

function Install-WinGet {
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
}

function Disable-Telemetry {
    # Disable Telemetry
    Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\AllowTelemetry" 1
    Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection\MaxTelemetryAllowed" 1
    # Disable Cortana
    Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search\AllowCortana" 0
    # Disable Suggested Applications
    Set-Registry "HKLM:\Software\Policies\Microsoft\Windows\CloudContent\DisableWindowsConsumerFeatures" 1
    Set-Registry "HKLM:\Software\Policies\Microsoft\Windows\CloudContent\DisableCloudOptimizedContent" 1
    Set-Registry "HKLM:\Software\Policies\Microsoft\Windows\CloudContent\DisableConsumerAccountStateContent" 1
    # Disable WiFi Hotspot Sharing
    #Set-Registry "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"  1
    # Disable Pre-Lock Screen that drops the first character
    Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization\NoLockScreen" 1
    # Disable Telemetry (requires a reboot to take effect)
    Set-Registry "HKLM:\Software\Policies\Microsoft\Windows\DataCollection\AllowTelemetry" 0
    Get-Service DiagTrack, Dmwappushservice | Stop-Service | Set-Service -StartupType Disabled
    # Disable P2P Update downloads outside of local network
    Set-Registry "HKLM:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config\DODownloadMode" 1
}

function Enable-Wsl {
    winget install -e --id dorssel.usbipd-win
    Enable-WindowsOptionalFeature -Online -All -FeatureName "Microsoft-Windows-Subsystem-Linux" -NoRestart -WarningAction SilentlyContinue | Out-Null
}

function Install-DevApps {
    winget install -e --id AutoHotkey.AutoHotkey
    winget install -e --id Google.Chrome
    winget install -e --id JFrog.Conan
    winget install -e --id JetBrains.Toolbox
    winget install -e --id Kitware.CMake
    winget install -e --id MSYS2.MSYS2
    winget install -e --id Microsoft.PowerToys
    winget install -e --id Microsoft.VisualStudioCode
    winget install -e --id Microsoft.WindowsTerminal
    winget install -e --id Ninja-build.Ninja
    winget install -e --id OpenJS.NodeJS.LTS
    winget install -e --id Python.Python.3.12
    # TODO: qt
    winget install -e --id Rustlang.Rustup
}

function Install-CliApps {
    # Enable Developer Mode
    Set-Registry "HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock\AllowDevelopmentWithoutDevLicense" 1
    winget install -e --id Neovim.Neovim
    winget install -e --id 7zip.7zip
    winget install -e --id Git.Git --override "/VerySilent /NoRestart /o:PathOption=CmdTools /Components=""icons,assoc,assoc_sh,gitlfs"""
    winget install -e --id Starship.Starship # Invoke-Expression (&starship init powershell)
    winget install -e --id BurntSushi.ripgrep.MSVC
    winget install -e --id junegunn.fzf
    winget install -e --id ajeetdsouza.zoxide # Invoke-Expression (& { (zoxide init powershell | Out-String) })
    winget install -e --id sharkdp.fd
    winget install -e --id JesseDuffield.lazygit

    if (-not (Test-Path "${OptDir}\Everything")) {
        $EverythingCliUrl = "https://www.voidtools.com/ES-1.1.0.27.x64.zip"
        New-Item -ItemType Directory -Path "${OptDir}\Everything"
        Invoke-WebRequest "${EverythingCliUrl}" -OutFile ${env:Temp}\EverythingCli.zip
        Expand-Archive -Path "${env:Temp}\EverythingCli.zip" -DestinationPath "${OptDir}\Everything"
        $MachinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
        if (-not (($MachinePath -split ';') -contains "${OptDir}\Everything")) {
            [Environment]::SetEnvironmentVariable("Path", $MachinePath + ";${OptDir}\Everything", [EnvironmentVariableTarget]::Machine)
        }
    }

    if (-not (Test-Path "${OptDir}\FiraCode")) {
        $FiraCodeUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip"
        New-Item -ItemType Directory -Path "${OptDir}\FiraCode"
        Invoke-WebRequest "${FiraCodeUrl}" -OutFile ${env:Temp}\FiraCode.zip
        Expand-Archive -Path "${env:Temp}\FiraCode.zip" -DestinationPath "${OptDir}\FiraCode"

        $Fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
        Get-ChildItem "${OptDir}\FiraCode" -Filter '*.ttf' | ForEach-Object {
            $FontName = $_.Name
            Write-Host "Installing Font: ${FontName}..."
            if (-not(Test-Path -Path "C:\Windows\fonts\${FontName}" )) {
                Get-ChildItem $_ | ForEach-Object { $Fonts.CopyHere($_.FullName) }
                Copy-Item $_ C:\Windows\Fonts
            }
        }
    }
}

function Install-MgmtApps {
    winget install -e --id SomePythonThings.WingetUIStore
    winget install -e --id voidtools.Everything
    winget install -s msstore 9P7KNL5RWT25  # SysInternals
    winget install -s msstore 9pfxcd722m2c  # KDE Filelight
}

function Install-FunApps {
    winget install -e --id Bitwarden.Bitwarden
    winget install -e --id Discord.Discord
    winget install -e --id EpicGames.EpicGamesLauncher
    winget install -e --id GOG.Galaxy
    winget install -e --id Google.Drive
    winget install -e --id Libretro.RetroArch
    winget install -e --id Logitech.GHUB
    winget install -e --id Malwarebytes.Malwarebytes
    winget install -e --id Mojang.MinecraftLauncher
    winget install -e --id Mozilla.Thunderbird
    winget install -e --id RiotGames.LeagueOfLegends.NA
    winget install -e --id Spotify.Spotify
    winget install -e --id Valve.Steam
    winget install -e --id VideoLAN.VLC
    winget install -e --id flux.flux
    # TODO: battlenet
    # TODO: u.gg
}

function Install-CreativeApps {
    # Aseprite is cool too! (but must be built from source)
    winget install -e --id BlenderFoundation.Blender
    winget install -e --id KDE.Kdenlive
    winget install -e --id LMMS.LMMS
    winget install -e --id NickeManarin.ScreenToGif
    winget install -e --id OBSProject.OBSStudio
    winget install -e --id Tiled.Tiled
    winget install -e --id dotPDNLLC.paintdotnet
    # TODO: VS Community

    # Godot: "C:\opt\godot\latest\Godot_stable_mono_win64.exe"
    if (-not (Test-Path "${OptDir}\godot\*${GodotVersion}*")) {
        # Get Godot
        New-Item -ItemType Directory -Path "${OptDir}\godot"
        Invoke-WebRequest "${GodotUrl}" -OutFile ${env:Temp}\godot.zip
        Expand-Archive -Path "${env:Temp}\godot.zip" -DestinationPath "${OptDir}\godot"
        $VersionedDir = (Resolve-Path "${OptDir}\godot\*${GodotVersion}*" | Select-Object -First 1)

        # Softlink Latest
        New-Item -ItemType SymbolicLink -Path "${OptDir}\godot\latest" -Value "${VersionedDir}" -Force
        Get-ChildItem "${OptDir}\godot\latest" -Filter "*v${GodotVersion}-*" | ForEach-Object { 
            $UnVersioned = $_.FullName.Replace("v${GodotVersion}-", "")
            New-Item -ItemType SymbolicLink -Path "${UnVersioned}" -Value $_ -Force
        }

        # ALTERNATIVELY: Strip-Components 1; (Test-Path "${OptDir}\godot")
        #Get-ChildItem $VersionedDir | ForEach-Object {
        #    Move-Item $_ -Destination "$(Split-Path $_)\.."
        #}
        #$VersionedDir | Remove-Item

        # Add to Path
        $MachinePath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
        if (-not (($MachinePath -split ';') -contains "${OptDir}\godot\latest")) {
            [Environment]::SetEnvironmentVariable("Path", $MachinePath + ";${OptDir}\godot\latest", [EnvironmentVariableTarget]::Machine)
        }

        # Cleanup
        Remove-Item "${env:Temp}\godot.zip"
    }

    # TODO: opentabletdriver (https://opentabletdriver.net/Framework)
    # TODO: tenacity
    # TODO: #Require...s -RunAsAdministrator
}