#Login with Global Administrator Account
Connect-AzureAD
#Query Setting and getting the ID
Get-AzureADDirectorySettingTemplate



#Choose which template to be edited
$Template = Get-AzureADDirectorySettingTemplate -Id 62375ab9-6b52-47ed-826b-58e47e0e304b

#Create new template
$Setting = $template.CreateDirectorySetting()

#Define the Classificatin List
$setting['ClassificationList'] = 'Confidential,Restricted,Internal Use,Public'

#Define the descriptions for the Classifications
$setting['ClassificationDescriptions'] = 'Confidential:secret information with high business impact. Do not even tell her.,Restricted:access only for limited fritzees,Internal Use:access for all fritzees,Public:Open for Guest and external Partners'

#Choose Default classification label
$setting['DefaultClassification'] = 'Internal Use'


Set-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id -DirectorySetting $Setting