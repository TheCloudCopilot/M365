# Reference: https://docs.microsoft.com/en-us/sharepoint/change-site-address
$GroupName = "Foo"
$NewName = "Foo Bar"
$NewAlias = "foo.bar"
$NewSMTP = $NewAlias + "@teams.contoso.com"
$NewTeamDescription = "Greetings Stranger"
## Rename the TeamName
Connect-MicrosoftTeams
$TargetTeam = (Get-Team -Displayname $GroupName).GroupId
Set-Team -GroupId $TargetTeam -DisplayName $NewName -Description $NewTeamDescription
## Rename the underlying Group
Connect-ExchangeOnline -UserPrincipalName Admin.Voss@sva.de
## Check current Situation
Get-UnifiedGroup -Identity $GroupName | select DisplayName,PrimarySmtpAddress,EmailAddresses | fl
## Set New Alias and Address
Set-UnifiedGroup -Identity $GroupName -Alias $NewAlias -PrimarySmtpAddress $NewSMTP
## Change Sharepoint Site
Connect-SPOService -Url https://365sva-admin.sharepoint.com
# Validate first
Start-SPOSiteRename -Identity "https://365sva.sharepoint.com/sites/CCMicrosoft-Cockpit2" -NewSiteUrl "https://365sva.sharepoint.com/sites/TeamMicrosoftCockpit" -ValidationOnly
# Execute
Start-SPOSiteRename -Identity "https://365sva.sharepoint.com/sites/CCMicrosoft-Cockpit2" -NewSiteUrl "https://365sva.sharepoint.com/sites/TeamMicrosoftCockpit"