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

```powershell
Install-Script -Name TCC-New-MgGraphAppCert-macOS
```

Or clone/download directly from GitHub:
```bash
git clone https://github.com/TheCloudCopilot/M365
```

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
