<# 
Manage Microsoft 365 tenants with Windows PowerShell for Delegated Access Permissions (DAP) partners
https://docs.microsoft.com/en-us/microsoft-365/enterprise/manage-microsoft-365-tenants-with-windows-powershell-for-delegated-access-permissio?view=o365-worldwide

#>
#$Tenants = Get-MsolPartnerContract -All; $Tenants | foreach {$Domains = $_.TenantId; Get-MsolDomain -TenantId $Domains | fl @{Label="TenantId";Expression={$Domains}},name}
#Get-MsolPartnerContract -DomainName daresystem.onmicrosoft.com | select-object *
#$Tenants = Get-MsolPartnerContract -All; $Tenants | foreach {$Domains = $_.TenantId; Get-MsolDomain -TenantId $Domains | fl @{Label="TenantId";Expression={$Domains}},name}

#$DareSystemUsers = Get-MsolUser -TenantId b04f7950-5095-4873-a445-4aed49d0a707 | Where-Object {$_.isLicensed -eq "True"}
#$DareSystemUsers.UserPrincipalName

Connect-MsolService
Get-MsolPartnerContract -All | select-object Name, DefaultDomainName, TenantId | Out-GridView  

$TenantId = "38501973-69d4-475b-8054-41c6f192e101"
$CSPUser = Get-MsolUser -TenantId $TenantId | Where-Object {$_.isLicensed -eq "True"}
Get-MsolUser -TenantId $TenantId


$CSPUser.UserPrincipalName
(Get-MsolUser -TenantId $TenantId -UserPrincipalName $Users.UserPrincipalName).Licenses.ServiceStatus