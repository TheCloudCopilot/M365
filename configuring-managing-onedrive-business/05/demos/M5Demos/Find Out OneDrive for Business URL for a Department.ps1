#$cred = get-Credential
#Connect-AzureAD -Credential $cred
#Connect-PnPOnline -Url https://globomanticsorg-admin.sharepoint.com

$Users = Get-AzureADUser | Where {$_.UserType -eq 'Member' -and $_.AssignedLicenses -ne $null -and $_.Department -eq "Research"}

$ONeDriveSites = @()

foreach ($user in $Users) 
{
    $SPProfile  = Get-PnPUserProfileProperty -Account $user.UserPrincipalName -ErrorAction SilentlyContinue
        if ($SPProfile -ne $null)
        {
          $ONeDriveSites += Get-PnPUserProfileProperty -Account $user.UserPrincipalName | select PersonalUrl
        }
}

$ONeDriveSites