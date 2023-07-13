<#
.SYNOPSIS
Imports all Conditional Access policies from separate XML files with their actual name.

.DESCRIPTION
This script imports all Conditional Access policies from separate XML files with their actual name and creates them as read-only policies in Azure AD. It also creates the following security groups:
- CA-BreakGlassAccounts
- CA-Persona-Admins
- CA-Persona-Admins-AppProtection-Exclusions
- CA-Persona-Admins-AttackSurfaceReduction-Exclusions
- CA-Persona-Admins-BaseProtection-Exclusions
- CA-Persona-Admins-Comliance-Exclusions

.PARAMETER Path
The path to the folder containing the XML files.

.OUTPUTS
None.
#>

Add-Type -AssemblyName System.Windows.Forms

# Check if the newest version of the Microsoft Graph PowerShell module is installed and install it if it is not
#$requiredVersion = "1.9.0"
#$installedVersion = (Get-Module -Name Microsoft.Graph.Identity.SignIns -ListAvailable).Version.ToString()
#if ($installedVersion -lt $requiredVersion) {
#    Write-Host "The newest version of the Microsoft Graph PowerShell module is required. Installing it now..."
#    Install-Module -Name Microsoft.Graph.Identity.SignIns -RequiredVersion $requiredVersion -Force
#}

# Disconnect from Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions"
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..."
Connect-MgGraph -Scopes 'User.Read.All', 'Organization.Read.All', 'Policy.ReadWrite.ConditionalAccess', 'Group.ReadWrite.All' -ErrorAction Stop

# Get the built-in onmicrosoft.com domain name of the tenant
Write-Host "Getting the built-in onmicrosoft.com domain name of the tenant..."
$tenantName = (Get-MgOrganization).VerifiedDomains | Where-Object {$_.IsInitial -eq $true} | Select-Object -ExpandProperty Name
$CurrentUser = (Get-MgContext | Select-Object -ExpandProperty Account)
#Write-Host "Tenant: $tenantName" -ForegroundColor 'Red' -BackgroundColor 'DarkGray'
#Write-Host "User: $CurrentUser" -ForegroundColor 'Green' -BackgroundColor 'DarkGray'
Write-Warning "Tenant: $tenantName"
Write-Warning "User: $CurrentUser"
Write-Host "!!IMPORTANT!! Please Check if you are logged in to the correct tenant - Take your time - Don't shoot yourself in the foot" -ForegroundColor 'Red' -BackgroundColor 'Black'
$answer = Read-Host -Prompt "Enter y for yes or n for no"
if ($answer -eq "y") {
    # continue the script
} elseif ($answer -eq "n") {
    # stop the script
} else {
    # handle invalid input
}

# Create security groups
Write-Host "Creating security groups..."
New-MgGroup -DisplayName 'CA-BreakGlassAccounts' -MailEnabled:$false -MailNickname 'CA-BreakGlassAccounts' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins' -MailEnabled:$false -MailNickname 'CA-Persona-Admins' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-AppProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-AppProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-Comliance-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-Comliance-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-DataProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-DataProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Admins-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Admins-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-AzureServiceAccounts' -MailEnabled:$false -MailNickname 'CA-Persona-AzureServiceAccounts' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-AzureServiceAccounts-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-AzureServiceAccounts-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-CorpServiceAccounts' -MailEnabled:$false -MailNickname 'CA-Persona-CorpServiceAccounts' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-CorpServiceAccounts-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-CorpServiceAccounts-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Developers' -MailEnabled:$false -MailNickname 'CA-Persona-Developers' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Developers-AppProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Developers-AppProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Developers-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Developers-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Developers-DataProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Developers-DataProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Developers-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Developers-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals' -MailEnabled:$false -MailNickname 'CA-Persona-Externals' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals-AppProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Externals-AppProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Externals-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Externals-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals-DataProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Externals-DataProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Externals-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Externals-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Global' -MailEnabled:$false -MailNickname 'CA-Persona-Global' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Global-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Global-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Global-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Global-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-Compliance-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-Compliance-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests' -MailEnabled:$false -MailNickname 'CA-Persona-Guests' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Global-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Global-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Global-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Global-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-Compliance-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-Compliance-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-GuestAdmins-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-GuestAdmins-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests' -MailEnabled:$false -MailNickname 'CA-Persona-Guests' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-Compliance-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-Compliance-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-DataProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-DataProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Guests-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Guests-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals' -MailEnabled:$false -MailNickname 'CA-Persona-Internals' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals-AppProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Internals-AppProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals-AttackSurfaceReduction-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Internals-AttackSurfaceReduction-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals-BaseProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Internals-BaseProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals-DataProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Internals-DataProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Internals-IdentityProtection-Exclusions' -MailEnabled:$false -MailNickname 'CA-Persona-Internals-IdentityProtection-Exclusions' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-Microsoft365ServiceAccounts' -MailEnabled:$false -MailNickname 'CA-Persona-Microsoft365ServiceAccounts' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-OnPremisesServiceAccounts' -MailEnabled:$false -MailNickname 'CA-Persona-OnPremisesServiceAccounts' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-WorkloadIdentities' -MailEnabled:$false -MailNickname 'CA-Persona-WorkloadIdentities' -SecurityEnabled:$true
New-MgGroup -DisplayName 'CA-Persona-WorkloadIdentities-Exclusion' -MailEnabled:$false -MailNickname 'CA-Persona-WorkloadIdentities-Exclusion' -SecurityEnabled:$true

<# Loop not working instead creating groups manually 
$url = "https://gist.githubusercontent.com/philippkohn/f7cc450f64798e089914dd765275a3ba/raw/b5f5da7c948a6a4b7afdcdfc796b4a8499788417/Microsoft%2520Conditional%2520Access%2520Framework%2520Groups.txt"
$groups = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content
foreach ($group in $groups) {
    New-MgGroup -DisplayName $group -MailEnabled:$false -MailNickname $group -SecurityEnabled:$true
}#>

# Show a folder selection dialog box to select the folder containing the XML files
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = "Select the folder containing the XML files."
$dialog.ShowNewFolderButton = $false
$result = $dialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $path = $dialog.SelectedPath

    # Get all XML files in the specified folder
    Write-Host "Getting all XML files in the specified folder..."
    $files = Get-ChildItem -Path $path -Filter *.xml

    # Import all Conditional Access policies from the XML files and create them as read-only policies in Azure AD
    Write-Host "Importing all Conditional Access policies from the XML files and creating them as read-only policies in Azure AD..."
    foreach ($file in $files) {
        $policy = Import-Clixml -Path $file.FullName
        New-MgIdentityConditionalAccessPolicy -InputObject $policy -ReadOnly:$true
    }

    Write-Host ""
    Write-Host "Imported all Conditional Access policies from $($files.Count) XML files in $($path)"

    Write-Host ""
    Write-Host "Done."
}