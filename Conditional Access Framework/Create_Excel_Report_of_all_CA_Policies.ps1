# Check PowerShell Version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Throw "This script requires PowerShell 7 or a newer version."
}

# Try Disconnect Microsoft Graph API
Write-Host "Disconnecting from existing Microsoft Graph API sessions"
try {
    Disconnect-MgGraph -ErrorAction SilentlyContinue
}
catch {}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..."
Connect-MgGraph -Scopes 'User.Read.All', 'Group.Read.All', 'Organization.Read.All', 'Policy.Read.All' -ErrorAction Stop

# Get the built-in onmicrosoft.com domain name of the tenant
Write-Host "Getting the built-in onmicrosoft.com domain name of the tenant..."
$tenantName = (Get-MgOrganization).VerifiedDomains | Where-Object { $_.IsInitial -eq $true } | Select-Object -ExpandProperty Name
$CurrentUser = (Get-MgContext | Select-Object -ExpandProperty Account)
Write-Warning "Tenant: $tenantName"
Write-Warning "User: $CurrentUser"
Write-Host "!!IMPORTANT!! Please check if you are logged in to the correct tenant. Take your time and ensure accuracy." -ForegroundColor 'Red' -BackgroundColor 'Black'
$answer = Read-Host -Prompt "Enter 'y' for yes or 'n' for no"
if ($answer -eq "n") {
    # Stop the script
    Exit
}
elseif ($answer -ne "y") {
    # Handle invalid input
    Write-Host "Invalid input. Exiting script." -ForegroundColor 'Red'
    Exit
}

# Get all Conditional Access policies
Write-Host "Getting all Conditional Access policies..."
$policies = Invoke-MgGraphRequest -Method GET "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" | Select-Object -ExpandProperty Value

# Create an array for the exported policies
$exportedPolicies = @()

# Export all Conditional Access policies to the array
foreach ($policy in $policies) {
    # Get the display names of the excluded groups
    $excludeGroupsNames = @()
    foreach ($groupId in $policy.Conditions.Users.ExcludeGroups) {
        $group = Invoke-MgGraphRequest -Method GET "https://graph.microsoft.com/v1.0/groups/$groupId`?`$select=displayName" | Select-Object -ExpandProperty Value
        $excludeGroupsNames += $group.DisplayName
    }

    # Get the display names of the included groups
    $includeGroupsNames = @()
    foreach ($groupId in $policy.Conditions.Users.IncludeGroups) {
        $group = Invoke-MgGraphRequest -Method GET "https://graph.microsoft.com/v1.0/groups/$groupId`?`$select=displayName" | Select-Object -ExpandProperty Value
        $includeGroupsNames += $group.DisplayName
    }

    # Create the exported policy object with the display names
    $exportedPolicy = [PSCustomObject]@{
        Name = $policy.DisplayName
        Id = $policy.Id
        State = $policy.State
        Conditions = $policy.Conditions
        GrantControls = $policy.GrantControls
        ExcludeGroupsNames = $excludeGroupsNames -join ", "
        IncludeGroupsNames = $includeGroupsNames -join ", "
    }
    $exportedPolicies += $exportedPolicy
}

Write-Host "Export to csv complete."
