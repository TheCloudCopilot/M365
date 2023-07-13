Get-SPOSite `
    -IncludePersonalSite $true `
    -Limit all `
    -Filter "Url -like '-my.sharepoint.com/personal/'" | 
    Select Url, StorageUsageCurrent, StorageQuota  | 
    Sort-Object StorageUsageCurrent -Descending | 
    Format-Table -Wrap -AutoSize

Set-SPOSite `
    -Identity https://globomanticsorg-my.sharepoint.com/personal/drew_globomantics_org `
     -StorageQuota 1024

Set-SPOSite -Identity https://globomanticsorg-my.sharepoint.com/personal/drew_globomantics_org -StorageQuotaReset