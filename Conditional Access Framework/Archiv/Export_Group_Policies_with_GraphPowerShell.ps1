<#
.SYNOPSIS
Exports all Conditional Access policies to separate XML files with their actual name.

.DESCRIPTION
This script exports all Conditional Access policies to separate XML files with their actual name and displays a summary of the exported policies in the shell.

.OUTPUTS
A summary of the exported policies in the shell.
#>

# Try Discconnect Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions"
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..."
Connect-MgGraph -Scopes 'Policy.Read.All'

# Get all Conditional Access policies
Write-Host "Getting all Conditional Access policies..."
$policies = Get-MgIdentityConditionalAccessPolicy

# Get the built-in onmicrosoft.com domain name of the tenant
Write-Host "Getting the built-in onmicrosoft.com domain name of the tenant..."
$tenantName = (Get-MgOrganization).VerifiedDomains | Where-Object {$_.IsInitial -eq $true} | Select-Object -ExpandProperty Name

# Get the current date in MM-dd-yyyy format
Write-Host "Getting the current date in MM-dd-yyyy format..."
$date = Get-Date -Format "MM-dd-yyyy"

# Create a folder named after the built-in onmicrosoft.com domain name of the tenant and the date of the export
Write-Host "Creating a folder named after the built-in onmicrosoft.com domain name of the tenant and the date of the export..."
$path = "$tenantName-$date"
New-Item -ItemType Directory -Path $path | Out-Null

# Export all Conditional Access policies to separate JSON files with their actual name and display a summary of the exported policies in the shell
Write-Host "Exporting all Conditional Access policies to separate JSON files with their actual name and displaying a summary of the exported policies in the shell..."
$summary = @()
foreach ($policy in $policies) {
    $name = $policy.DisplayName.Replace('/', '_')
    $file = "$path\$name.json"
    $policy | ConvertTo-Json -Depth 10 | Out-File -FilePath $file
    $summary += [PSCustomObject]@{
        Name = $policy.DisplayName
        Id = $policy.Id
        File = $file
    }
}
$summary | Format-Table -AutoSize

Write-Host ""
Write-Host "Exported all Conditional Access policies for $($tenantName) to $($path)"
Write-Host ""
Write-Host "Done."