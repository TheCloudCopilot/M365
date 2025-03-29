# TCC-New-MgGraphAppCert-macOS.ps1

This PowerShell script creates a self-signed certificate for **Microsoft Graph App-Only authentication on macOS systems**.

## ✨ Features

- Generates a **4096-bit RSA key pair**
- Creates a **self-signed X.509 certificate** with SHA-256 signature
- Outputs a **password-protected private key**, public certificate, and combined PFX file
- Automatically imports the certificate into the **macOS Keychain (login.keychain-db)**
- Logs all operations to a `.log` file including timestamps
- Clears sensitive variables like the plain text password from memory (BSTR memory scrubbing)

## ✅ Prerequisites

- **macOS**
- **PowerShell Core 7.0+**
- **OpenSSL** (install via Homebrew: `brew install openssl`)
- Permissions to access and modify the macOS Keychain

## 💻 Installation

You can either clone the repository or download the script directly from GitHub:

### 🔁 Clone with Git:

```bash
git clone https://github.com/TheCloudCopilot/M365.git
cd M365
```

### ⬇️ Or download the script manually:

- Open: [TCC-New-MgGraphAppCert-macOS.ps1](https://github.com/TheCloudCopilot/M365/blob/main/TCC-New-MgGraphAppCert-macOS.ps1)
- Click **"Raw"** → Right-click → **"Save As..."** to download it to your local system

### ✅ Make it executable (if needed):

```bash
chmod +x ./TCC-New-MgGraphAppCert-macOS.ps1
```

### ▶️ Run the script with PowerShell 7:

```powershell
./TCC-New-MgGraphAppCert-macOS.ps1
```

Make sure you're using **PowerShell Core (7.0+)**.  
You can check with:

```powershell
$PSVersionTable.PSEdition
```

It should return: `Core`

> 💡 Tip: You can place the script in a directory listed in your `$env:PATH` or create a PowerShell alias for quick reuse.

## 🚀 Usage

```powershell
./TCC-New-MgGraphAppCert-macOS.ps1
```

The script will:

1. Prompt you for your Microsoft Entra tenant name  
   (e.g., `yourcompany` or `yourcompany.onmicrosoft.com`)
2. Ask for a password to encrypt the private key

### Output files (in the current directory)

- `<user>_<tenant>_Private.key` – encrypted RSA private key (PEM)
- `<user>_<tenant>_Public.pem` – self-signed certificate (PEM)
- `<user>_<tenant>_Cert.pfx` – PKCS#12 archive (key + cert, password-protected)
- `<user>_<tenant>_Cert.log` – log file with all timestamps and messages

## 🔐 Security Considerations

- Self-signed certificates are safe for this use case (Graph App-Only Auth) when the private key is encrypted and stored securely
- The private key is password protected and never left in memory unencrypted
- All sensitive input is removed from memory after use
- Certificate validity is limited to **90 days** by default – plan renewal accordingly

## 📄 License

MIT License  
© 2025 [Philipp Kohn](https://thecloudcopilot.com)

## 🙋 Author

**Philipp Kohn**  
GitHub: [@TheCloudCopilot](https://github.com/TheCloudCopilot)  
Website: [thecloudcopilot.com](https://thecloudcopilot.com)

## 🔗 Related

- [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/overview)
- [PowerShell Gallery - Script](https://www.powershellgallery.com/packages/TCC-New-MgGraphAppCert-macOS)
- [GitHub Project Repository](https://github.com/TheCloudCopilot/M365)
