Set-SPOTenant -OneDriveStorageQuota 1048576


Get-SPOSite `
    -IncludePersonalSite $true `
    -Limit all `
    -Filter "Url -like '-my.sharepoint.com/personal/'"	| 
    Select Url, StorageUsageCurrent | 
    Sort-Object StorageUsageCurrent -Descending
