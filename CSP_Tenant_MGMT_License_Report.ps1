#Variables
$ExportObject = @()
$ExportPath = "C:\temp\"

#Connect To CSP
Connect-MsolService

#Select Tenant
$TenantID = (Get-MsolPartnerContract -All | Select-Object Name, DefaultDomainName, TenantID | Out-GridView -OutputMode Single).TenantID

#Get Users
$Users = Get-MsolUser -TenantId $TenantID -All:$true

#Create License Export Object
Foreach ($user in $Users) {
    
    $Licenses = @()
    Foreach ($license in $user.Licenses.ServiceStatus) {
    
        $Licenses += New-Object -TypeName psobject -Property @{
            ServicePlan = $license.ServicePlan.Servicename
            ProvisioningStatus = $license.ProvisioningStatus
        }
    }
    
    $ExportObject += New-Object -TypeName psobject -Property @{
        UserPrincipalName = $user.UserPrincipalName
        Licenses = $Licenses
    }
    
}
#Export Data
$ExportObject | Export-Clixml -Path "$($ExportPath)TenantID_$($TenantID)_ReportDate_$(get-date -Format dd-MM-yyyy).xml"