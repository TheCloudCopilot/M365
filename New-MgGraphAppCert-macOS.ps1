<#
.SYNOPSIS
This script creates a self-signed certificate for Microsoft Graph App-Only authentication on macOS.

.DESCRIPTION
This PowerShell 7 script generates an RSA key pair and a self-signed X.509 certificate that can be used 
for Microsoft Graph App-Only authentication. The certificate is generated using OpenSSL, with the private key 
being AES-256 encrypted and the public certificate being saved in PEM format. It also creates a combined 
PKCS#12 (.pfx) certificate file, which is automatically imported into the macOS Keychain (login.keychain-db), 
making it available for the current user session.

All actions, paths, and status messages are logged with timestamps into a log file. 
Sensitive variables, such as the plaintext password, are securely removed from memory at the end of execution
using [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR().

.OUTPUTS
The script creates the following files in the current working directory:
- `<currentUser>_<Tenant>_Private.key` – RSA private key (AES-256 encrypted, PEM format)
- `<currentUser>_<Tenant>_Public.pem` – self-signed X.509 certificate (PEM format)
- `<currentUser>_<Tenant>_Cert.pfx` – PKCS#12 archive (includes key and certificate, password protected)
- `<currentUser>_<Tenant>_Cert.log` – log file including paths, timestamps, and status messages

.PARAMETER tenantName
The Microsoft Entra default tenant name (e.g., yourcompany.onmicrosoft.com) used in certificate subject and filenames.

.PARAMETER certPassword
Password that encrypts the private key and PFX. Input is hidden and securely removed from memory using ZeroFreeBSTR().

.NOTES
File Name      : New-MgGraphAppCert-macOS.ps1
Author         : Philipp Kohn
Contact        : https://github.com/philippkohn
Prerequisite   : PowerShell Core 7.0 and above, OpenSSL installed, Keychain access permissions
Copyright      : © 2025 cloudcopilot.de
License        : MIT License (https://opensource.org/licenses/MIT)

DISCLAIMER
----------
This script is provided "as-is" without warranty of any kind.
Use it at your own risk. The author disclaims all liability.

Change Log
----------
Date       Version   Author          Description
--------   -------   ------          --------------------------------------------
14/08/23   1.0       Philipp Kohn    Initial creation with assistance from OpenAI's ChatGPT.
14/08/23   1.1       Philipp Kohn    Changed the common Name to the Tenant Name.
26/03/25   1.2       Philipp Kohn    Updated script for macOS compatibility, replaced Windows certificate commands with OpenSSL.
26/03/25   1.3       Philipp Kohn    Added password prompt for private key.
27/03/25   1.4       Philipp Kohn    Added automatic Keychain import and logging functionality.
27/03/25   1.5       Philipp Kohn    Enhanced memory security handling (ZeroFreeBSTR), added parameter documentation, 
                                     introduced region-based code structure for improved readability.
28/03/25   1.6       Philipp Kohn    Name change and clean-up                                     
#>

#region Initialization
# Get current macOS user and sanitize for filenames
$currentUser = (whoami) -replace '\.', '_'

# Prompt for Microsoft Entra Default Tenant Name
$tenantName = Read-Host "Your Microsoft Entra Default Tenant Name (Example: yourcompany.onmicrosoft.com)"

# Strip domain suffix if user enters full tenant domain
$tenantName = $tenantName -replace '.onmicrosoft.com', ''

# Prompt for a secure password for the private key
$certPassword = Read-Host "Enter a password for the private key (input is hidden)" -AsSecureString

# Convert SecureString to plain text password and securely free the unmanaged memory
# BSTR = Binary String, a COM-compatible string format used for interop with unmanaged memory
# SecureStringToBSTR allocates memory outside of .NET to hold the password temporarily in plain text
# PtrToStringAuto reads it into a .NET-managed string
# ZeroFreeBSTR securely erases the original memory region before releasing it
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($certPassword)
$certPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

# Define file names (with user prefix)
$certBaseName = "${currentUser}_$tenantName"
$privateKeyPath = "./${certBaseName}_Private.key"
$certPath = "./${certBaseName}_Public.pem"
$pfxPath = "./${certBaseName}_Cert.pfx"
$logPath = "./${certBaseName}_Cert.log"
$certValidityDays = 90
$dnsName = "$currentUser - $tenantName"
#endregion

#region Logging start
# Start logging
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting certificate generation."
#endregion

#region Generate RSA Private Key
# Generate a new private key with password protection and 4096-bit length
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Generating 4096-bit private key..."
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -aes256 -pass pass:$certPasswordPlain -out $privateKeyPath
if ($LASTEXITCODE -ne 0) {
    $msg = "ERROR: Failed to generate private key (Exit Code $LASTEXITCODE)"
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Write-Host $msg -ForegroundColor Red
    exit $LASTEXITCODE
} else {
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Private key generated successfully."
}
#endregion

#region Generate Self-Signed Certificate
# Create a self-signed certificate with SHA-256 signature
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Creating self-signed certificate with SHA-256..."
openssl req -new -x509 -sha256 -key $privateKeyPath -out $certPath -days $certValidityDays -subj "/CN=$dnsName" -passin pass:$certPasswordPlain
if ($LASTEXITCODE -ne 0) {
    $msg = "ERROR: Failed to create self-signed certificate (Exit Code $LASTEXITCODE)"
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Write-Host $msg -ForegroundColor Red
    exit $LASTEXITCODE
} else {
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Certificate created successfully."
}
#endregion

#region Export to PFX
# Convert to PFX for Graph authentication
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Converting certificate to PFX format..."
openssl pkcs12 -export -out $pfxPath -inkey $privateKeyPath -in $certPath -password pass:$certPasswordPlain -passin pass:$certPasswordPlain
if ($LASTEXITCODE -ne 0) {
    $msg = "ERROR: Failed to create PFX file (Exit Code $LASTEXITCODE)"
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Write-Host $msg -ForegroundColor Red
    exit $LASTEXITCODE
} else {
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] PFX file created successfully."
}
#endregion

#region Import to macOS Keychain
# Import certificate into macOS Keychain
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Importing certificate into macOS Keychain..."
security import "$pfxPath" -k ~/Library/Keychains/login.keychain-db -P "$certPasswordPlain" -T /usr/bin/security
if ($LASTEXITCODE -ne 0) {
    $msg = "ERROR: Failed to import certificate into Keychain (Exit Code $LASTEXITCODE)"
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Write-Host $msg -ForegroundColor Red
    exit $LASTEXITCODE
} else {
    Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Certificate successfully imported into macOS Keychain."
}
#endregion

#region Cleanup
# Clear password variable for security
$certPassword = $null
$certPasswordPlain = $null

# Final log entry
Add-Content -Path $logPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Certificate generation completed."

Write-Host "`nCertificate and key files generated successfully:" -ForegroundColor Green
Write-Host "PEM Certificate: $certPath" -ForegroundColor Cyan
Write-Host "Private Key: $privateKeyPath" -ForegroundColor Cyan
Write-Host "PFX File (for Graph Authentication): $pfxPath" -ForegroundColor Cyan
Write-Host "Log File: $logPath" -ForegroundColor DarkGray
#endregion
