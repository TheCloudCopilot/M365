#---------------------------------------------------------------------------------------
# 8-SendAs.ps1 - allow a user to sendas group
# Microsoft Teams and Microsoft 365 Groups PowerShell Masterclass by @atwork
# https://docs.microsoft.com/en-us/office365/enterprise/powershell/manage-office-365-groups-with-powershell
#---------------------------------------------------------------------------------------

$groupname = "My new Today team"
$userAlias = "Nestor Wilke"

$groupsRecipientDetails = Get-Recipient -RecipientTypeDetails groupmailbox -Identity $groupname
$groupsRecipientDetails

Add-RecipientPermission -Identity $groupsRecipientDetails.Name `
    -Trustee $userAlias `
    -AccessRights SendAs `
    -Confirm:$false

# https://docs.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps
# Once the cmdlet is executed, users can go to Outlook or Outlook on the web to send as the group, 
# by adding the group email address to the From field.