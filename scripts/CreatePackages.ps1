# Move to the project root folder (parent from current script folder)

$rootFolder = (Get-Item (Get-ScriptDirectory)).Parent.FullName
Set-Location $rootFolder

# Create the artifacts directory if it doesn't exist

New-Item .\artifacts -type directory -Force

# Perform builds

&"C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" ".\src\Okra.Data\Okra.Data.csproj" "/verbosity:minimal" "/property:Configuration=Release;VisualStudioVersion=12.0"

# Check NuGet is installed and updated

If (!(Test-Path .\.nuget\nuget.exe))
{
    New-Item .\.nuget -type directory -Force
    Invoke-WebRequest 'https://www.nuget.org/nuget.exe' -OutFile '.\.nuget\nuget.exe'
}

.\.nuget\NuGet.exe update -self

# Create packages

.\.nuget\NuGet.exe pack .\src\Okra.Data\Okra.Data.csproj -Prop Configuration=Release -Output .\artifacts -Symbols

# Functions

function Get-ScriptDirectory 
{ 
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value 
    Split-Path $Invocation.MyCommand.Path 
} 
