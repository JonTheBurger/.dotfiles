New-ModuleManifest -Path "$PSScriptRoot\Dotfile-Functions.psd1" `
    -RootModule "Dotfile-Functions.psm1" `
    -Author "Jon Povirk" `
    -Description "Functions for dotfile management" `
    -FunctionsToExport @("Set-Registry", "Set-EnvVar", "Update-Path", "Remove-Path", "Add-Path", "Get-Path", "Add-ShellContextMenu", "Remove-Bloatware") `
    -VariablesToExport @("BloatApplications")