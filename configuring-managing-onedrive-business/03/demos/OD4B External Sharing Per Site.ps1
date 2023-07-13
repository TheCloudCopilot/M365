Get-SPOSite  `
    -IncludePersonalSite $true  `
    -Limit all  `
    -Filter "Url -like '-my.sharepoint.com/personal/'" | 
    Select Url 

Set-SPOSite `
     -Identity https://globomanticsorg-my.sharepoint.com/personal/vlad_globomantics_org `
     -SharingCapability Disabled

Set-SPOSite `
     -Identity https://globomanticsorg-my.sharepoint.com/personal/vlad_globomantics_org `
     -SharingCapability ExternalUserAndGuestSharing

#To See All Options > https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-sposite?view=sharepoint-ps