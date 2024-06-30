<#
.SYNOPSIS
    Provides convenience functions for a Windows machine.
.DESCRIPTION
    This script will prompt you at each step before making any changes, asking
    for permission before proceeding.
.EXAMPLE
    Import-Module $PSScriptRoot\Util\Dotfile-Functions.ps1
    Remove-Module Dotfile-Functions
.LINK
    https://github.com/JonTheBurger/.dotfiles
    https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_methods
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
#>

<#
.SYNOPSIS
    Convenience function for creating or overwriting an environment variable.
.PARAMETER Key
    Path of the registry key to set. The last path entry is interpreted as the
    key name, and preceding path entries are interpreted as the path.
.PARAMETER Value
    Value to assign to the given registry key.
.PARAMETER Type
    Sets the type of the registry value. One of the following (DWord by default):
    String: Specifies a null-terminated string. Used for REG_SZ values.
    ExpandString: Specifies a null-terminated string that contains unexpanded references to environment variables that are expanded when the value is retrieved. Used for REG_EXPAND_SZ values.
    Binary: Specifies binary data in any form. Used for REG_BINARY values.
    DWord: Specifies a 32-bit binary number. Used for REG_DWORD values.
    MultiString: Specifies an array of null-terminated strings terminated by two null characters. Used for REG_MULTI_SZ values.
    Qword: Specifies a 64-bit binary number. Used for REG_QWORD values.
    Unknown: Indicates an unsupported registry data type, such as REG_RESOURCE_LIST values.
.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-itemproperty
#>
function Set-Registry {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Key,

        [Parameter(Mandatory=$true)]
        [object]$Value,

        [Parameter()]
        [ValidateSet("String", "ExpandString", "Binary", "DWord", "MultiString", "Qword", "Unknown")]
        [string]$Type = "DWord"
    )
    $Path = Split-Path -Path "$Key" -Parent
    $Name = Split-Path -Path "$Key" -Leaf

    # Check if the registry key exists, and create it if it doesn't
    if (-not (Test-Path $Path)) {
        New-Item -Path "$Path" -Force | Out-Null
    }

    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -Force
}

<#
.SYNOPSIS
    Creates or overwrites an environment variable.
.PARAMETER Key
    Name of the environment variable to set.
.PARAMETER Value
    Value of the environment variable.
.PARAMETER Scope
    Scope to apply environment variable, one of "Process" (default), "User", or
    "Machine".
.PARAMETER Expand
    When used with -Scope "Machine" or "User", the environment variable's type
    is set to REG_EXPAND_SZ, which will evaluate environment variables within
    % delimiters, such as %UserProfile%.
#>
function Set-EnvVar {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Key,

        [Parameter(Mandatory=$true)]
        [string]
        $Value,

        [Parameter()]
        [ValidateSet("Machine", "User", "Process")]
        [string]
        $Scope = "Process",

        [Parameter()]
        [switch]
        $Expand
    )
    process {
        [Environment]::SetEnvironmentVariable("$Key", "$Value", $Scope)
        if ($Expand) {
            if ($Scope -eq "User") {
                $reg = "HKEY_CURRENT_USER\Environment"
                [Microsoft.Win32.Registry]::SetValue("$reg", "$Key", "$Value", [Microsoft.Win32.RegistryValueKind]::ExpandString)
            }
            elseif ($Scope -eq "Machine") {
                $reg = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
                [Microsoft.Win32.Registry]::SetValue("$reg", "$Key", "$Value", [Microsoft.Win32.RegistryValueKind]::ExpandString)
            }
        }
    }
}

<#
.SYNOPSIS
    Reloads Machine and User path into the current $env:Path.
#>
function Update-Path {
    process {
        $env:Path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ';' + [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
    }
}

<#
.SYNOPSIS
    Removes one or more directories to %PATH%. Empty entries are always removed.
.INPUTS
    System.String[]
    Directories to remove from the %PATH%.
.PARAMETER Directory
    Directory to remove from the %PATH%.  This module does not resolve or
    normalize paths, so two paths that only differ by the presence / absence of
    a trailing backslash are considered different path entries.
.PARAMETER Scope
    Selects which %PATH% environment variable to write to, either "Machine"
    (default) or "User". "Machine" requires running as an administrator.
.PARAMETER Matching
    When enabled, -Directory will instead be interpreted as a regular
    expression.
.PARAMETER Lazy
    By default, the %PATH% variable is refreshed at the end of this function.
    Setting the -Lazy flag will disable this behavior.
#>
function Remove-Path {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string[]]
        $Directory,

        [Parameter()]
        [ValidateSet("Machine", "User")]
        [string]
        $Scope = "Machine",

        [Parameter()]
        [switch]
        $Matching,

        [Parameter()]
        [switch]
        $Lazy
    )
    process {
        $path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::$Scope)
        if ($Matching) {
            $path = ($path -split ';' | Where-Object { (-not $_ -Match $Directory) -and ($_ -ne '') }) -join ';'
        }
        else {
            $path = ($path -split ';' | Where-Object { ($_ -ne $Directory) -and ($_ -ne '') }) -join ';'
        }
        Set-EnvVar -Key "Path" -Value "$path" -Scope "$Scope" -Expand
    }
    end {
        if ((-not $Lazy) -and ($modified)) { Update-Path }
    }
}

<#
.SYNOPSIS
    Adds one or more directories to %PATH%.
.DESCRIPTION
    This function allows users to explicitly move entries to the front or back
    of path, as well as manage Machine and User paths. Empty path entries are
    always filtered out.
.INPUTS
    System.String[]
    Directories to add to the %PATH%.
.OUTPUTS
    System.Boolean
    Returns $true if %PATH% was changed. If -Force is specified, this will
    always return $true, even if (for example) an existing directory at the end
    of %PATH% was "appended" to the same spot at the end.
.PARAMETER Directory
    Directory to add to the %PATH%. Directories are added in order, meaning the
    first Directory specified in the list is the highest precedence.
.PARAMETER Scope
    Selects which %PATH% environment variable to write to, either "Machine"
    (default) or "User". "Machine" requires running as an administrator.
.PARAMETER Insert
    By default, new %PATH% entries are appended. Setting this flag will instead
    place the new path entry first. Directories are added in the order provided,
    meaning the last -Directory list entry will be first when -Insert is
    specified.
.PARAMETER Lazy
    By default, the %PATH% variable is refreshed at the end of this function.
    Setting the -Lazy flag will disable this behavior.
.PARAMETER Force
    By default, this function checks if %PATH% already contains the specified
    -Directory, and does not mutate %PATH% if its already present. -Force overrides
    this behavior, instead removing the -Directory from %PATH% if it exists and
    appending it to the end of %PATH% (or inserting to the front, if -Insert is
    set).
.NOTES
    On Windows, the global, admin-controlled "Machine" path takes higher
    precedence than the "User" path. This is the opposite of Linux's behavior.
    This module does not resolve or normalize paths, so two paths that only
    differ by the presence / absence of a trailing backslash are considered
    different path entries.
#>
function Add-Path {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string[]]
        $Directory,

        [Parameter()]
        [ValidateSet("Machine", "User")]
        [string]
        $Scope = "Machine",

        [Parameter()]
        [switch]
        $Insert,

        [Parameter()]
        [switch]
        $Lazy,

        [Parameter()]
        [switch]
        $Force
    )
    begin { $modified = $false }
    process {
        $path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::$Scope)
        if ($Force) {
            $path = ($path -split ';' | Where-Object { $_ -ne "$Directory" -and $_ -ne '' }) -join ';'
        }
        if (-not (($path -split ';') -contains "$Directory")) {
            $modified = $true
            if ($Insert) {
                $path = "$Directory" + ';' + "$path"
            }
            else {
                $path = "$path" + ';' + "$Directory"
            }
            Set-EnvVar -Key "Path" -Value "$path" -Scope "$Scope" -Expand
        }
    }
    end {
        if ((-not $Lazy) -and ($modified)) { Update-Path }
        $modified
    }
}

<#
.SYNOPSIS
    Returns the current %PATH% as an array of strings.
.PARAMETER Scope
    Set to "User" or "Machine" to filter down to only those components of the
    %PATH%.
.OUTPUTS
    System.String[]
    List of path entries.
#>
function Get-Path {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Scope = ""
    )
    end {
        if ($Scope -ne '') {
            $path = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::$Scope) -split ';'
        }
        else {
            $path = "$env:path" -split ';'
        }
        $path
    }
}