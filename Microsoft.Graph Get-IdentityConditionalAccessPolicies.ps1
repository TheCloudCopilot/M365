# https://www.iam-specialist.com

#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; ModuleVersion="1.21.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Identity.SignIns"; ModuleVersion="1.21.0" }

#$ErrorActionPreference = 'stop'

#Select-MgProfile 'beta'

Connect-MgGraph -Scopes @('Policy.Read.All')
#Connect-MgGraph -AccessToken 'ey...'

$SAVE_POLICIES_AS_JSON_FILES = $true

$allConditionalAccessPolicies = Get-MgIdentityConditionalAccessPolicy -All

if ($SAVE_POLICIES_AS_JSON_FILES) {
    $allConditionalAccessPolicies | ForEach-Object {
        $PSItem | ConvertTo-Json -Depth 4 | Out-File ".\$($PSItem.DisplayName).json"
    }
}