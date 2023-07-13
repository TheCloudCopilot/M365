<#
.SYNOPSIS
This script updates the extension attributes for all devices with displayName matching a filter.

.DESCRIPTION
This script connects to the Microsoft Graph API with the Directory.ReadWrite.All and Device.ReadWrite.All permissions and updates the extension attributes for all devices with displayName matching a filter. It sets the extensionAttribute1, extensionAttribute2 and extensionAttribute3 to the specified values. It requires PowerShell 7 or a newer version.

.OUTPUTS
The script writes messages to the console indicating the progress and status of the operation. It does not return any objects.

.NOTES
Author        Philipp Kohn
Change Log    V1.00, 22-Jul-2023 - Initial version
#>

# Define variables for the displayName filter and the extension attributes
$displayNameFilter = 'DESK*' # Change this to match your desired filter - Displayname of Computerobjects in Microsoft EntraID (AzureAD)
$extensionAttribute1 = 'LAB1' # Change this to your desired value - In this example the Company Name
$extensionAttribute2 = 'Notebook' # Change this to your desired value - In this example the device type, Could be Citrix Server
$extensionAttribute3 = 'Berlin' # Change this to your desired value - In this example the Location

# Check PowerShell Version
if ($PSVersionTable.PSVersion.Major -lt 7) {
  Throw "This script requires PowerShell 7 or a newer version." # If the PowerShell version is lower than 7, stop the script and show an error message
}

# Try Disconnect Microsoft Graph API
Write-Host "Disconnecting from existing Microsoft Graph API sessions" # Write a message to the console
try {
    Disconnect-MgGraph -ErrorAction SilentlyContinue # Try to disconnect from any existing Microsoft Graph API sessions and ignore any errors
}
catch {}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..." # Write a message to the console
Connect-MgGraph -Scopes 'Directory.ReadWrite.All', 'Device.ReadWrite.All' -ErrorAction Stop # Connect to the Microsoft Graph API with the specified permissions and stop the script if there is an error

Import-Module Microsoft.Graph.Identity.DirectoryManagement # Import the module that contains the cmdlets for managing devices and users
$params = @{ # Define a hashtable variable that contains the extension attributes and their values using the variables defined earlier
  extensionAttributes = @{
    extensionAttribute1 = $extensionAttribute1 
    extensionAttribute2 = $extensionAttribute2 
    extensionAttribute3 = $extensionAttribute3 
  }
}

# Get all devices with displayName matching the filter
[array]$Devices = Get-MgDevice -All | Where-Object {$_.displayName -like $displayNameFilter} # Get all devices from the Microsoft Graph API and filter them by their displayName using the variable defined earlier

# Update the extension attributes for each device
ForEach ($Device in $Devices) { # Loop through each device in the array
  Write-Host ("Updating device {0}" -f $Device.displayName) # Write a message to the console with the device name
  Update-MgDevice -DeviceId $Device.id -BodyParameter $params # Update the device with the specified id and pass the extension attributes as a body parameter
}