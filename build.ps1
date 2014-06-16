[CmdletBinding()]
Param([Parameter(Mandatory=$False)][Version]$VersionNumber)

# Move to the project root folder (current script folder)

function Get-ScriptDirectory
{ 
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value 
    Split-Path $Invocation.MyCommand.Path 
}

$rootFolder = (Get-Item (Get-ScriptDirectory)).FullName
Set-Location $rootFolder

# Run build steps

write-host "--- Cleaning solution ---"
.\scripts\Clean.ps1

If ($VersionNumber -ne $null)
{
    write-host "--- Patching version numbers ---"
    .\scripts\PatchVersion.ps1 $VersionNumber
}

write-host "--- Building release binaries ---"
.\scripts\BuildRelease.ps1

write-host "--- Creating NuGet packages ---"
.\scripts\CreatePackages.ps1