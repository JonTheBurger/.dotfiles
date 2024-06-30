<#
.SYNOPSIS
    Provides convenience functions for setting up a Windows machine with opinionated
    defaults suitable for programming and/or leisure.
.DESCRIPTION
    This script will prompt you at each step before making any changes, asking
    for permission before proceeding.
.PARAMETER Force
    Force all parameters to $false, ignoring any specified values.
.PARAMETER DoConfigExplorer
    Simplify explorer.exe settings.
.PARAMETER DoConfigPrivacy
    Lock down user privacy settings.
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
    [nullable[bool]] $DoConfigExplorer,
    [nullable[bool]] $DoConfigPrivacy
)

$ProgressPreference = "SilentlyContinue"
$Force = $Force.IsPresent
if ($Help.IsPresent) {
    Get-Help ".\20-Run-User-Setup.ps1"
    return
}
Import-Module $PSScriptRoot\Util\Dotfile-Functions.ps1

function Set-UserExplorer {
    # Query Parameters
    if ($Force) {
        $DoConfigExplorer = $true
    }
    elseif ($null -eq $DoConfigExplorer) {
        $message = "Shall I Tweak Explorer.exe & the Task Bar?"
        $choices = @(
            [System.Management.Automation.Host.ChoiceDescription]::new("&Yes", "Show Hidden Files, Disable Bing Search, etc.")
            [System.Management.Automation.Host.ChoiceDescription]::new("&No", "Keep settings as-is")
        )
        $DoConfigExplorer = $Host.UI.PromptForChoice($null, $message, $choices, 1) -eq 0
    }

    # Dark Mode
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\AppsUseLightTheme" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize\AppsUseLightTheme" 0
    # Disable Bing Search
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\BingSearchEnabled" 0
    Set-Registry "HKCU:\Software\Policies\Microsoft\Windows\Explorer\DisableSearchBoxSuggestions" 1
    # Show File Extensions
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\HideFileExt" 0
    # Show Hidden Files
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden" 1
    # Show path in title bar
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState\FullPath" 1
    # Default Explorer Window is now "This PC"
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\LaunchTo" 1
    # Disable Quick Access: Recent Files
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ShowRecent" 0
    # Disable Quick Access: Frequent Folders
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ShowFrequent" 0
    # Show items like Recycle Bin in Explorer side bar
    #Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPaneShowAllFolders" 1
    # Expands File Tree to Current Path in Explorer
    #Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\NavPaneExpandToCurrentFolder" 1
    # Task Bar shows app icon only on the monitor where it is active
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\MMTaskbarMode" 2
    # Disable Xbox Gamebar
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR\AppCaptureEnabled" 0
    Set-Registry "HKCU:\System\GameConfigStore\GameDVR_Enabled" 0
    # Taskbar: Hide Taskbar Junk
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0  # Search
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0 # Task
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" 0 # Widgets
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0 # Chat
    Set-Registry "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot\TurnOffWindowsCopilot" 1 # Copilot
}

function Set-UserPrivacy {
    # Query Parameters
    if ($Force) {
        $DoConfigPrivacy = $true
    }
    elseif ($null -eq $DoConfigPrivacy) {
        $message = "Shall I Disable User-Specific Trackers?"
        $choices = @(
            [System.Management.Automation.Host.ChoiceDescription]::new("&Yes", "Lock down my data")
            [System.Management.Automation.Host.ChoiceDescription]::new("&No", "Microsoft can have a little bit of my data as a treat")
        )
        $DoConfigPrivacy = $Host.UI.PromptForChoice($null, $message, $choices, 1) -eq 0
    }

    # https://gist.github.com/NickCraver/7ebf9efbfd0c3eab72e9
    # Disallow Advertising ID
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo\Enabled" 0
    # Privacy Settings
    Set-Registry "HKCU:\Software\Microsoft\InputPersonalization\RestrictImplicitInkCollection" 1
    Set-Registry "HKCU:\Software\Microsoft\InputPersonalization\RestrictImplicitTextCollection" 1
    Set-Registry "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore\HarvestContacts" 0
    Set-Registry "HKCU:\Software\Microsoft\Input\TIPC\Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Personalization\Settings\AcceptedPrivacyPolicy" 0
    Set-Registry "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy\HasAccepted" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\ShowedToastAtLevel" 1
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy\TailoredExperiencesWithDiagnosticDataEnabled" 0
    # Disable P2P Update downloads outside of local network
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\SystemSettingsDownloadMode" 3
    # Disable App Suggestions, What's New, Tips & Suggestions, Suggested Content
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-310093Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338388Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338389Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338393Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338394Enabled" 0
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SubscribedContent-338396Enabled" 0
    # Disallow apps from accessing personal data
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks\Value" "Deny" -Type String
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary\Value" "Deny" -Type String
    # Disable notifications
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSyncProviderNotifications" 0 # Learn More
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement\ScoobeSystemSettingEnabled" 0 # Finish Setting up my Device
}

function Set-UserShell {
    # Disable Win+F so we can reuse it:
    Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\DisabledHotkeys" "F" -Type String
}

Set-UserExplorer
Set-UserPrivacy

# TODO: PATH

# TODO: Softlinks
# TODO: Windows Terminal Config
# TODO: powershell $profile symlink?

# TODO: ASCII escape codes

#TODO: Custom Shell Entries
# Computer\HKEY_CLASSES_ROOT\*\shell\Open with nvim\command
# C:\Users\JonPo\Documents\.local\opt\nvim-win64\Neovim\bin\nvim.exe "%1"
# REG_SZ