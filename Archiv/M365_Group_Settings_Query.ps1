Import-Module -Name AzureADPreview
Connect-AzureAD
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value 'Group.Unified' -EQ).id
$Setting.Values