# Import the JSON files from the folder
$files = Get-ChildItem -Path "C:\Scripts\M365\M365x77476191.onmicrosoft.com-07-14-2023" -Filter "*.json"

# Create an empty array to store the data
$data = @()

# Loop through each file and extract the relevant values
foreach ($file in $files) {
  # Convert the JSON content to a PowerShell object
  $content = Get-Content -Path $file.FullName | ConvertFrom-Json

  # Create a custom object with the desired properties
  $object = [PSCustomObject]@{
    "DisplayName" = $content.displayName
    "State" = $content.state
    "ClientAppTypes" = $content.conditions.clientAppTypes -join ", "
    "IncludeGroups" = $content.conditions.users.includeGroups -join ", "
    "ExcludeGroups" = $content.conditions.users.excludeGroups -join ", "
    "UserRiskLevels" = $content.conditions.userRiskLevels -join ", "
    "IncludeApplications" = $content.conditions.applications.includeApplications -join ", "
    "GrantControls" = $content.grantControls.builtInControls -join ", "
  }

  # Add the object to the data array
  $data += $object
}

# Export the data array to an Excel file
$data | Export-Excel -Path "C:\Scripts\M365\ConditionalAccessPolicies.xlsx" -AutoSize