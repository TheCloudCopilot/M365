# This script requires PowerShell 7 or a newer version
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Throw "This script requires PowerShell 7 or a newer version."
}

# Add a reference to System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Define the required scopes for Microsoft Graph API
$RequiredScopes = @('User.Read.All', 'Organization.Read.All', 'Policy.Read.All')

# Define a function to connect to Microsoft Graph API
function Connect-Graph {
    Write-Host "Connecting to Microsoft Graph API..."
    Connect-MgGraph -Scopes $RequiredScopes -ErrorAction Stop -ForceRefresh
}

# Define a function to disconnect from Microsoft Graph API
function Disconnect-Graph {
    Write-Host "Disconnecting from Microsoft Graph API..."
    Disconnect-MgGraph -force -ErrorAction SilentlyContinue
}

# Define a function to get the built-in onmicrosoft.com domain name of the tenant
function Get-TenantName {
    Write-Host "Getting the built-in onmicrosoft.com domain name of the tenant..."
    $tenantName = (Get-MgOrganization).VerifiedDomains | Where-Object {$_.IsInitial -eq $true} | Select-Object -ExpandProperty Name
    Write-Warning "Tenant: $tenantName"
    return $tenantName
}

# Define a function to get the current user account
function Get-CurrentUser {
    $CurrentUser = (Get-MgContext | Select-Object -ExpandProperty Account)
    Write-Warning "User: $CurrentUser"
    return $CurrentUser
}

# Define a function to confirm if the user is logged in to the correct tenant
function Confirm-Tenant {
    Write-Host "!!IMPORTANT!! Please Check if you are logged in to the correct tenant - Take your time - Don't shoot yourself in the foot" -ForegroundColor 'Red' -BackgroundColor 'Black'
    $answer = Read-Host -Prompt "Enter y for yes or n for no"
    if ($answer -eq "y") {
        return $true
    } elseif ($answer -eq "n") {
        return $false
    } else {
        Write-Error "Invalid input"
        exit
    }
}

# Define a function to get all Conditional Access policies
function Get-Policies {
    Write-Host "Getting all Conditional Access policies..."
    $policies = Invoke-MgGraphRequest -Method GET https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies | Select-Object -ExpandProperty Value
    return $policies
}

# Define a function to get the current date in MM-dd-yyyy format
function Get-DateFormatted {
    Write-Host "Getting the current date in MM-dd-yyyy format..."
    $date = Get-Date -Format "MM-dd-yyyy"
    return $date
}

# Define a function to show a GUI dialog to select where to save the report
function Show-SaveDialog {
    # Create a SaveFileDialog object
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog

    # Set some properties
    $saveFileDialog.InitialDirectory = $env:USERPROFILE
    $saveFileDialog.FileName = "$tenantName-$date.zip"
    $saveFileDialog.Filter = "Zip files (*.zip)|*.zip|All files (*.*)|*.*"

    # Show the dialog and get the user's input
    if ($saveFileDialog.ShowDialog() -eq "OK") {
        # Get the selected file path
        $path = $saveFileDialog.FileName
        return $path
    } else {
        Write-Error "User cancelled the dialog"
        exit
    }
}

# Define a function to export all Conditional Access policies to separate JSON files and display a summary of the exported policies in the shell
function Export-Policies {
    param($policies, $path)
    
    # Create a folder named after the selected file path without extension
    Write-Host "Creating a folder named after the selected file path without extension..."
    $folder = [System.IO.Path]::ChangeExtension($path, "")
    New-Item -ItemType Directory -Path $folder | Out-Null

    # Export all Conditional Access policies to separate JSON files with their actual name and display a summary of the exported policies in the shell
    Write-Host "Exporting all Conditional Access policies to separate JSON files with their actual name and displaying a summary of the exported policies in the shell..."
    $summary = @()
    foreach ($policy in $policies) {
        # Remove id, createdDateTime and modifiedDateTime from policy object
        $policy = $policy | Select-Object -Property * -ExcludeProperty id, createdDateTime, modifiedDateTime
        $name = $policy.DisplayName.Replace('/', '_')
        $file = "$folder\$name.json"
        $policy | ConvertTo-Json -Depth 10 | Out-File -FilePath $file
        $summary += [PSCustomObject]@{
            Name = $policy.DisplayName
            Id = $policy.Id
            File = $file
        }
    }
    $summary | Format-Table -AutoSize
}

# Define a function to zip the folder containing the exported policies
function Zip-Folder {
    param($folder, $path)
    
    # Zip the folder containing the exported policies
    Write-Host "Zipping the folder containing the exported policies..."
    Compress-Archive -Path "$folder\*" -DestinationPath $path -Force
}

# Define a function to display the final message
function Show-Message {
    param($tenantName, $path)
    
    Write-Host ""
    Write-Host "Exported all Conditional Access policies for $($tenantName) to $($path)"
    Write-Host ""
    Write-Host "Done."
}

# Main script

# Try to disconnect from existing Microsoft Graph API sessions
Disconnect-Graph

# Connect to Microsoft Graph API
Connect-Graph

# Get the tenant name and the current user account
$tenantName = Get-TenantName
$CurrentUser = Get-CurrentUser

# Confirm if the user is logged in to the correct tenant
if (Confirm-Tenant) {
    # Get all Conditional Access policies
    $policies = Get-Policies

    # Get the current date in MM-dd-yyyy format
    $date = Get-DateFormatted

    # Show a GUI dialog to select where to save the report
    $path = Show-SaveDialog

    # Export all Conditional Access policies to separate JSON files and display a summary of the exported policies in the shell
    Export-Policies -policies $policies -path $path

    # Zip the folder containing the exported policies
    Zip-Folder -folder [System.IO.Path]::ChangeExtension($path, "") -path $path

    # Display the final message
    Show-Message -tenantName $tenantName -path $path

} else {
    # Stop the script
}

# Disconnect from Microsoft Graph API
Disconnect-Graph
