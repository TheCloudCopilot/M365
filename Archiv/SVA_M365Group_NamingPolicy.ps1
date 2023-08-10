<#
    .SYNOPSIS
    SVA_O365Group_NamingPolicy.ps1 - PowerShell Script to Query O365 Group Naming Policy
 
    .DESCRIPTION
    The Script queries the AzureAD Expiration Policy

    .NOTES
    Author        Philipp Kohn, philipp.kohn@sva.de
    
    Change Log    V1.00, 05/11/2019 - Initial version

    .LINK
    https://docs.microsoft.com/en-us/azure/active-directory/users-groups-roles/groups-naming-policy
        
#>
Import-Module -Name AzureADPreview
Connect-AzureAD
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value 'Group.Unified' -EQ).id
$Setting.Values | Format-List
Get-AzureADMSGroupLifecyclePolicy