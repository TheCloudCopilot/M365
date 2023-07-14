#---------------------------------------------------------------------------------------
# 0-Connect.ps1 - connect to Microsoft 365
# Microsoft Teams and Microsoft 365 Groups PowerShell Masterclass by @atwork
#---------------------------------------------------------------------------------------

#------------------------------------------
# First install the modules...
# Install-Module -Name MicrosoftTeams -Force -AllowClobber -scope CurrentUser
# Install-Module -Name AzureADPreview -Force -AllowClobber -scope CurrentUser
# Update-Module -Name AzureADPreview -Force
# Uninstall-Module -Name AzureADPreview -Force
# Get a list of modules on the computer that were installed by PowerShellGet.
# Get-InstalledModule
#------------------------------------------
Import-Module MicrosoftTeams
Import-Module AzureADPreview

# Then, connect...
$cred = Get-Credential
# If you want to re-use the password after the connect-azuread call you should make it read-only before the cmdlet call:
$cred.password.MakeReadOnly()

# Connect to the Teams module
Connect-MicrosoftTeams -Credential $cred

# If required, connect to the AAD module
# $cred should still have a password
Connect-AzureAD -Credential $cred

$session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://ps.outlook.com/PowerShell-LiveID `
    -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -AllowClobber
Write-Output "ready for Exchange Online!"

# Remove-PSSession $Session 

# Install-Module -Name ExchangeOnlineManagement
# https://aka.ms/exops-docs
# The Exchange Online PowerShell V2 module is currently in Preview.
# Get-Help Connect-ExchangeOnline -examples
# Connect-ExchangeOnline  -Credential $UserCredential -EnableErrorReporting -LogDirectoryPath .\exov2.log -LogLevel All