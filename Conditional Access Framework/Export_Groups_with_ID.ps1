# Check PowerShell Version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Throw "This script requires PowerShell 7 or a newer version."
}

# Try Discconnect Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions"
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..."
Connect-MgGraph -Scopes 'Group.Read.All'

Get-MgGroup -Filter "startswith(displayName,'CA-')" | Select-Object DisplayName, Id | Export-Csv -Path .\Conditional_Access_Framework_Groups_w_ID_Target.csv