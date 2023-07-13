Get-UnifiedGroup -Identity 'Discovery' | Select-Object DisplayName,PrimarySmtpAddress,WhenCreated,AutoSubscribeNewMembers,AlwaysSubscribeMembersToCalendarEvents
Get-UnifiedGroup -Identity 'Discovery' -LinkType 'Subscriber'
Set-UnifiedGroup -Identity 'Discovery' -AutoSubscribeNewMembers -AlwaysSubscribeMembersToCalendarEvents
Remove-UnifiedGroupLinks -Identity 'Discovery' -LinkType Subscribers -Links DebraB@M365x629543.OnMicrosoft.com

Get-UnifiedGroup -Identity 'CompetenceTeamMicrosoft@teams.sva.de' | Select-Object
Set-UnifiedGroup -Identity 'CompetenceTeamMicrosoft@teams.sva.de' -AutoSubscribeNewMembers:$false -AlwaysSubscribeMembersToCalendarEvents:$false -HiddenFromExchangeClientsEnabled:$true -HiddenFromAddressListsEnabled:$true
Set-UnifiedGroup -Identity 'Discovery' -AutoSubscribeNewMembers:$false -AlwaysSubscribeMembersToCalendarEvents:$false -HiddenFromExchangeClientsEnabled:$true -HiddenFromAddressListsEnabled:$true

