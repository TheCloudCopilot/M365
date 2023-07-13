<#
.SYNOPSIS
Exports all Conditional Access policies to separate XML files with their actual name.

.DESCRIPTION
This script exports all Conditional Access policies to separate XML files with their actual name and displays a summary of the exported policies in the shell.

.OUTPUTS
A summary of the exported policies in the shell.
#>

# Import needed Modules
Import-Module -Name Microsoft.Graph.Authentication
Import-Module -Name Microsoft.Graph.Groups
Import-Module -Name Microsoft.Graph.Identity.SignIns

# Try Discconnect Microsoft Graph API
Write-Host "Disconnect from existing Microsoft Graph API Sessions"
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}

# Connect to Microsoft Graph API
Write-Host "Connecting to Microsoft Graph API..."
Connect-MgGraph -Scopes 'Policy.Read.All'

# Get all Conditional Access policies
Write-Host "Getting all Conditional Access policies..."
$policies = Get-MgIdentityConditionalAccessPolicy

# Create an Excel file named after the built-in onmicrosoft.com domain name of the tenant and the date of the export
Write-Host "Creating an Excel file named after the built-in onmicrosoft.com domain name of the tenant and the date of the export..."
$file = "$tenantName-$date.xlsx"
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# Export all Conditional Access policies to separate worksheets with their actual name and display a summary of the exported policies in the shell
Write-Host "Exporting all Conditional Access policies to separate worksheets with their actual name and displaying a summary of the exported policies in the shell..."
$summary = @()
$row = 1
foreach ($policy in $policies) {
    $name = $policy.DisplayName.Replace('/', '_')
    # Truncate the name to 5 characters
    $name = $name.Substring(0, 5)
    $worksheet.Name = $name
    $json = $policy | ConvertTo-Json -Depth 10
    $worksheet.Cells.Item($row, 1) = $json
    $summary += [PSCustomObject]@{
        Name = $policy.DisplayName
        Id = $policy.Id
        Worksheet = $name
    }
    $worksheet = $workbook.Worksheets.Add()
}
$workbook.SaveAs($file)
$excel.Quit()
$summary | Format-Table -AutoSize

Write-Host ""
Write-Host "Exported all Conditional Access policies for $($tenantName) to $($path)"
Write-Host ""
Write-Host "Done."
try{Disconnect-MgGraph -ErrorAction SilentlyContinue}catch{}