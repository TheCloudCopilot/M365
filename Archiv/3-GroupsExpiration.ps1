#---------------------------------------------------------------------------------------
# 3-GroupsExpiration.ps1 - list and modify the groups expiration date
# Microsoft Teams and Microsoft 365 Groups PowerShell Masterclass by @atwork
#---------------------------------------------------------------------------------------

# Get the current setting
Get-AzureADMSGroupLifecyclePolicy | Format-List

# ---------------------------------------------
# Remove and add
# ---------------------------------------------
# Removes current policy
$LifetimeID = "<lifetimeid>"
Remove-AzureADMSGroupLifecyclePolicy -Id $LifetimeID

# Setup of new Groups Lifecycle policy (None, All, Selected)
New-AzureADMSGroupLifecyclePolicy -GroupLifetimeInDays 60 `
    -ManagedGroupTypes "All" `
    -AlternateNotificationEmails admin@M365x251516.onmicrosoft.com

# ---------------------------------------------
# Modify
# ---------------------------------------------
# Get the current setting
Get-AzureADMSGroupLifecyclePolicy | Format-List

# Update of a policy
Set-AzureADMSGroupLifecyclePolicy -Id $LifetimeID `
    -GroupLifetimeInDays 40 `
    -ManagedGroupTypes 'All' `
    -AlternateNotificationEmails admin@M365x251516.onmicrosoft.com

# Retrieves Lifecyclepolicy of a selected group
Get-UnifiedGroup | Select id, displayname

$group = "<groupid>"
Get-AzureADMSLifecyclePolicyGroup  -Id $group

# Renews a group by updating the RenewedDateTime property on a group to the current DateTime.
Reset-AzureADMSLifeCycleGroup -GroupId $group 

# Adds a group to a lifecycle policy - only if ManagedGroupTypes is 'Selected'.
Add-AzureADMSLifecyclePolicyGroup -Id $LifetimeID -GroupId $group