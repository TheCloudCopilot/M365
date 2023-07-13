#---------------------------------------------------------------------------------------
# 7-AuditGroups.ps1 - show groups and their access type
# Microsoft Teams and Microsoft 365 Groups PowerShell Masterclass by @atwork
#---------------------------------------------------------------------------------------

Get-UnifiedGroup | select DisplayName, AccessType

# Identify which groups have a mismatch of properties
$PublicGroups = Get-UnifiedGroup `
    | Where-Object {$_.AccessType -eq "Public"} `
    | Select DisplayName, AccessType, ExternalDirectoryObjectId
Write-Warning "Public Groups:"
$PublicGroups

# Set the Access Type to Private for all "Public" groups
Write-Warning "Settings Groups to private..."
ForEach ($g in $PublicGroups) {
    Write-Host "Set to Private: $($g.DisplayName)"
    Set-UnifiedGroup -Identity $g.DisplayName -AccessType "Private"
}
