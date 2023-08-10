<# By Andrew Piskai
   anpiskai@microsoft.com
   original v1: 8/28/2016
   revised  v2: 4/24/2018
   revised  v3: 1/28/2020

   This script is intended to be used as is to pull tenant settings from an Office 365 tenant. Any modifications or changes to the script are undertaken at the risk of the person running it. 

   PREREQUISITES:
   • PowerShell Execution Policy
       • Execution Policy must be set to unrestricted. You can run Set-ExecutionPolicy Unrestricted from an elevated PowerShell window to set.
   • Account Permissions
       • Office 365 Global Admin account with at least read permissions to all of the subservices of the Office 365 Suite including Exchange Online, SharePoint Online, Skype for Business Online, Security and Compliance Center, and Teams
   • PowerShell Modules to be installed on your machine (and instructions to download them)
       • MSOnline/Windows Azure AD Powershell Module - https://msdn.microsoft.com/en-us/library/azure/jj151815(v=azure.98).aspx#bkmk_installmodule 
       • Exchange- https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps
       • SPO- http://go.microsoft.com/fwlink/p/?LinkId=255251
       • Skype- https://www.microsoft.com/en-us/download/details.aspx?id=39366
       • Security and Compliance Center - https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/mfa-connect-to-scc-powershell?view=exchange-ps
       • Teams- https://www.microsoft.com/en-us/download/details.aspx?id=39366 and https://www.powershellgallery.com/packages/MicrosoftTeams/1.0.3
   • Other Notes:
       • Make sure to get the modern version of the Exchange Online module (the one that supports MFA).
       • Make sure to get the modern version of the Security and Compliance center module (the one that supports MFA).
       • Make sure you don't have conditional access policies that will block the "Other Clients" authentication for the account used to run the script for SharePoint Online. This will interfere with the SharePoint section authentication.

   FEATURES INTENTIONALLY NOT INCLUDED:
   •	MSOL cmdlets not included
        o	Get-MSOLContact
        o	Get-MSOLDevice
        o   Get-MSOLDirSyncProvisioningError
        o   Get-MSOLDomainVerificationDns
        o   Get-MSOLFederationProperty
        o   Get-MSOLGroup
        o   Get-MSOLGroupMember
        o   Get-MSOLHasObjectsWithDirSyncProvisioningErrors
        o   Get-MSOLServicePrincipalCredential      
        o   Get-MSOLUser
        o   Get-MSOLUserByStrongAuthentication
        o   Get-MSOLUserRole
   •	EXO cmdlets not included
        o   https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/connect-to-exchange-online-powershell?view=exchange-ps under Reference section
        o	Active Directory cmdlets
            •	All cmdlets except Get-OrganizationalUnit
        o	Advanced Threat Protection cmdlets
            •   Get-AdvancedThreatProtectionDocumentDetail
            •   Get-AdvancedThreatProtectionDocumentReport
            •	Get-AdvancedThreatProtectionTrafficReport
            •	Get-SpoofMailReport
            •	Get-URLTrace
        o	Anti-spam and anti-malware cmdlets in Exchange Online   
            •	Get-QuarantineMessage
            •	Get-QuarantineMessageHeader
            •	Get-MailboxJunkEmailConfiguration        
        o	Client Access cmdlets
            •	CASMailbox cmdlets
            •	OWA cmdlets with Get-Mailbox<word>Configuration format 
            •	Get-TextMessagingAccount
        o   Client Access Server cmdlets
            •   All cmdlets
        o	Connected Accounts cmdlets
            •	All cmdlets
        o	Database Availability Groups cmdlets
            •	All cmdlets
        o	Device cmdlets
            •   Get-MobileDevice
            •	Get-MobileDeviceStatistics
            •	Get-ActiveSyncDevice
            •	Get-ActiveSyncMailboxPolicy (deprecated)
        o	Email Addresses and Address Book cmdlets
            •	Get-AddressBookPolicy
            •   Get-AddressList
            •   Get-DetailsTemplate
            •	Get-OabVirtualDirectory
            •	Get-OfflineAddressBook
            •   Get-GlobalAddressList
        o	Encryption and Certificates cmdlets
            •	Get-ExchangeCertificate
            •   Get-OMEMessageStatus
        o	Federation and Hybrid cmdlets
            •	Get-FederatedDomainProof
            •   Get-HybridConfiguration
            •   Get-PendingFederatedDomain
            •   Get-RemoteMailbox
        o	Mailbox Database and Servers Cmdlets
            •	All cmdlets except Get-SearchDocumentFormat
        o	Mailbox Cmdlets
            •	Mailbox cmdlets
            •	Mailbox configuration cmdlets
            •	Mailbox permission cmdlets
            •	Mailbox Folder Statistics cmdlets
            •	Calendar cmdlets
            •	Clutter cmdlets
            •	Focused Inbox cmdlets
            •	Inbox Rule cmdlets
            •	Sweep Rule cmdlets
            •	User Photo cmdlets
            •	Get-MessageCategory
            •   Get-Place
            •   Get-ResourceConfig
        o	Mail Flow cmdlets
            •	Get-AddressRewriteEntry
            •   Get-DeliveryAgentConnector
            •   Get-EdgeSubscription
            •   Get-EdgeSyncServiceConfig
            •   Get-ForeignConnector
            •   Get-FrontEndTransportService  
            •   Get-MailboxTransportService
            •   Get-Message
            •   Get-MessageTrace
            •   Get-MessageTraceDetail
            •   Get-MessageTrackingLog
            •   Get-MessageTrackingReport
            •   Get-NetworkConnectionInfo  
            •   Get-Queue
            •   Get-QueueDigest
            •   Get-ReceiveConnector
            •   Get-ResubmitRequest
            •   Get-RoutingGroupConnector
            •   Get-SendConnector
            •   Get-SystemMessage
            •   Get-TransportAgent
            •   Get-TransportPipeline
            •   Get-TransportServer
            •   Get-TransportService
            •   Get-X400AuthoritativeDomain
        o	Move and Migration Cmdlets
            •	Mailbox Move Request cmdlets
            •	Get-MigrationBatch
            •	Get-MigrationStatistics
            •	Get-MigrationUser
            •	Get-MigrationUserStatistics
            •	Public folder migration cmdlets
        o	Organization Cmdlets
            •	Get-AccessTocustomerDataRequest
            •   Get-AuthConfig
            •   Get-CmdletExtensionAgent
            •   Get-ExchangeAssistanceConfig
            •   Get-ExchangeDiagnosticInfo
            •   Exchange Server cmdlets
            •   Get-ExchangeSettings
            •   Get-Notification
            •   Get-SettingOverride
        o	Policy and Compliance Cmdlets
            •   Get-AdministrativeUnit (included in MSOL section)
            •	Get-AuditLogSearch
            •   Get-ComplianceSearch
            •   Get-ComplainceSearchAction
            •   Get-DataRetentionReport
            •   Get-DlpDetailReport
            •   Get-DlpDetectionsReport
            •   Get-DlpSiDetectionsReport
            •	Get-MailboxSearch
            •   Get-ManagedContentSettings
            •   Get-ManagedFolder
            •   Get-ManagedFolderMailboxPolicy
            •   Get-RetentionEvent 
        o	Reporting Cmdlets
            •	All cmdlets
        o	Server Health and Performance Cmdlets
            •   All cmdlets
        o	Sharing and Collaboration Cmdlets
            •	Public Folder cmdlets
            •	Get-SiteMailbox
            •	Get-SiteMailboxDiagnostics
        o	Unified Messaging
            •   Get-OnlineMeetingConfiguration	
            •   Get-UMActiveCalls
            •   Get-UMCallAnsweringRule
            •   Get-UMCallDataRecord
            •   Get-UMCallRouterSettings
            •   Get-UMCallSummaryReport	
            •	Get-UMMailbox
            •	Get-UMMailboxPIN
            •   Get-UMServer
            •   Get-UMService
        o	Users and Groups cmdlets
            •	All cmdlets
   •	SPO Cmdlets Not included
        o	https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/?view=sharepoint-ps
        o	Get-SPOAppErrors
        o	Get-SPOAppInfo
        o   Get-SPOCrossGeoMovedUsers
        o   Get-SPOCrossGeoMoveReport
        o   Get-SPOCrossGeoUsers
        o	Get-SPODeletedSite
        o   Get-SPOExternalUser
        o   Get-SPOMigrationJobProgress
        o   Get-SPOMigrationJobStatus
        o   Get-SPOSiteContentMoveState
        o   Get-SPOSiteDesignRunStatus
        o   Get-SPOSiteDesignTask
        o   Get-SPOSiteRenameState
        o   Get-SPOSiteScript
        o   Get-SPOSiteScriptFromList
        o   Get-SPOSiteScriptFromWeb
        o   Get-SPOSiteUserInvitations
        o   Get-SPOStorageEntity
        o   Get-SPOTenantContentTypeReplicationParameters
        o   Get-SPOTenantTaxonomyReplicationParameters
        o	Get-SPOTenantLogEntry
        o	Get-SPOTenantLogLastAvailableTimeInUTC
        o   Get-SPOTenantServicePrincipalPermissionRequests
        o   Get-SPOUnifiedGroup
        o   Get-SPOUnifiedGroupMoveState
        o   Get-SPOUserAndContentMoveState
        o   Get-SPOUserOneDriveLocation   
   •	Skype Cmdlets not included
        o	https://docs.microsoft.com/en-us/powershell/module/skype/?view=skype-ps (only cmdlets scoped for Skype Online)
        o   Group Search Cmdlets
        o   ONLINE AUDIO FILE Cmdlets
        o   ONLINE CARRIER PORTABILITY IN Cmdlets
        o   Get-CsOnlineDirectoryUser
        o   ONLINE SCHEDULE Cmdlets
        o   ONLINE TIME RANGE Cmdlets
        o   ONLINE USER Cmdlets
        o   ONLINE VOICE USER Cmdlets
        o   USER Cmdlets
        o   Get-CsEffectiveTenantDialPlan
        o   Get-CsHybridMediationServer
        o   Get-CsMeetingMigrationStatus
        o   Get-CsOnlineApplicationEndpoint (due to requirement to specify URI)
        o   Get-CsOnlineApplicationInstanceAssociationStatus
        o   Get-CsOnlineDialInConferencingUser
        o   Get-CsOnlineDialInConferencingUserInfo
        o   Get-CsOnlineDialInConferencingUserState
        o   Get-CsOnlineEnhancedEmergencyServiceDisclaimer
        o   Get-CsOnlineNumberPortInOrder
        o   Get-CSOnlineNumberPortOutOrderPin
        o   Get-CsOnlinePSTNUsage
        o   Get-CsOnlineTelephoneNumber
        o   Get-CsOnlineTelephoneNumberAvailableCount
        o   Get-CsOnlineTelphoneNumberInventoryAreas
        o   Get-CsOnlineTelphoneNumberInventoryCities
        o   Get-CsOnlineTelphoneNumberInventoryCountries
        o   Get-CsOnlineTelphoneNumberInventoryRegions
        o   Get-CsOnlineTelphoneNumberInventoryTypes
        o   Get-CsOnlineTelphoneNumberReservationInformation
        o   Get-CsOnlineUser
        o   Get-CsOnlineVoicemailUserSettings
        o   Get-CsOnlineVoiceUser
        o   Get-CsOnlineUMMailbox
        o   Get-CsOnlineUMMailboxPolicy
        o    Get-CsOrganizationalAutoAttendantHolidays (due to requirement to specify URI)
        o   Teams cmdlets (covered in Teams section)
   •	Security and Compliance Center cmdlets not included
        o	https://technet.microsoft.com/en-us/library/mt587093(v=exchg.160).aspx
        o   Get-ActivityAlert
        o   Get-AuditConfig (omitted to improve script stability)
        o   Get-AuditConfigurationPolicy (omitted to improve script stability)
        o   Get-AuditConfigurationRule (omitted to improve script stability)
        o   Get-InformationBarrierPoliciesApplicationStatus
        o   Get-InformationBarrierRecipientStatus
        o	Get-ComplianceSearch
        o	Get-ComplianceSearchAction
        o	Get-CaseHoldPolicy
        o	Get-compliancecase
        o	Get-ComplianceCaseMember
        o   Get-ComplianceRetentionEvent
        o   Get-DataRetentionReport
        o   Get-DlpDetectionsReport
        o   Get-DlpSiDetectionsReport
        o	User and Group cmdlets
        o	Get-SupervisoryReviewReport
        o   Get-SupervisoryReviewPolicyReport
   •	Teams cmdlets not included
        o   https://docs.microsoft.com/en-us/powershell/module/teams/?view=teams-ps
        o   https://docs.microsoft.com/en-us/powershell/module/skype/?view=skype-ps
        o   Get-CsBatchPolicyAssignmentOperation
        o   Get-CsUserPolicyAssignment
        o   Get-UserPolicyPackage
        o   Get-UserPolicyPackageRecommendation
        o   Get-Team
        o   Get-TeamChannel
        o   Get-TeamChannelUser
        o   Get-TeamFunSettings
        o   Get-TeamGuestSettings
        o   Get-TeamHelp
        o   Get-TeamMemberSettings
        o   Get-TeamMessagingSettings
        o   Get-TeamUser
#>
$originalPath=(Get-Location).Path

Import-Module MSOnline
$msoCred = Get-Credential -Message "Please provide Global Administrator credentials for your tenant."
connect-msolservice –credential $msocred
start-transcript -path ".\tenantSettingsTranscript.txt" -append
(get-date).ToString()
$FormatEnumerationLimit=500

$MFAExchangeModule = (Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter CreateExoPSSession.ps1 -Recurse ).FullName[-1]
. $MFAExchangeModule 

cd $originalPath

$SPOURL=Read-Host -Prompt "Please enter your Sharepoint Admin page URL (typically in the format: https://contoso-admin.sharepoint.com)"

$subfolders=dir
if($subfolders.Name -notcontains "Reports"){
    New-Item -Path .\Reports -ItemType Directory
}


#----------------------------------------------------------
#MSOLSettings
#----------------------------------------------------------
#region
#AccountSkus
Write-Host "Pulling information about Account SKUs..." -ForegroundColor Magenta
$skus=(Get-MsolAccountSku|select accountskuid,activeunits,consumedunits,suspendedUnits,skupartnumber)
$skus|Export-Csv .\Reports\O365AccountSkus.csv -NoTypeInformation

#AdministrativeUnits
Write-Host "Pulling information about Administrative Units..." -ForegroundColor Magenta
$aus=Get-MsolAdministrativeUnit
$aus|Export-Csv .\Reports\O365AdministrativeUnits.csv -NoTypeInformation

#AdministrativeUnitMembers
Write-Host "Pulling information about Administrative Unit Members..." -ForegroundColor Magenta
$aums=@()
foreach($au in $aus){
    $auID=$au.ObjectID
    $auName=$au.DisplayName
    foreach($aumember in (Get-MsolAdministrativeUnitMember -AdministrativeUnitObjectId $auID)){
        $aumembershipObject=[pscustomobject]@{AdministrativeUnitDisplayName="$auName";AdministrativeUnitObjectID="$auID";MemberDisplayName="$($aumember.DisplayName)";MemberEmailAddress="$($aumember.EmailAddress)";MemberObjectID="$($aumember.ObjectID)"}
        $aums+=$aumembershipObject
    }
}
$aums|Export-Csv .\Reports\O365AdministrativeUnitMemberships.csv -NoTypeInformation

#Directory Setting Templates
#DEPRECATED Get-MsolAllSettingTemplate

#Directory Settting Objects
#DEPRECATED Get-MsolAllSettings

#Company Allowed Data Location
Write-Host "Pulling information about Company Allowed Data Locations..." -ForegroundColor Magenta
$companyalloweddatalocation=Get-MsolCompanyAllowedDataLocation
$companyalloweddatalocation|Export-Csv .\Reports\O365CompanyAllowedDataLocations.csv -NoTypeInformation

#CompanyInformation
Write-Host "Pulling information about Company Information..." -ForegroundColor Magenta
$companyinfo=Get-MsolCompanyInformation
$companyinfo|Export-Csv .\Reports\O365CompanyInformation.csv -NoTypeInformation

#Device Registration Service Policy
Write-Host "Pulling information about Device Registration Service Policy..." -ForegroundColor Magenta
$deviceRegistrationServicePolicy=Get-MsolDeviceRegistrationServicePolicy
$deviceRegistrationServicePolicy|Export-Csv .\Reports\O365DeviceRegistrationServicePolicy.csv -NoTypeInformation

#DirSync Enablement
Write-Host "Pulling information about DirSyncEnablement..." -ForegroundColor Magenta
$DSConfig=Get-MsolDirSyncConfiguration
$DSConfig|Export-Csv .\Reports\O365DirSyncEnablement.csv -NoTypeInformation

#DirSync Features
Write-Host "Pulling information about DirSync Features..." -ForegroundColor Magenta
$DSFeatures=Get-MsolDirSyncFeatures
$DSFeatures|Export-Csv .\Reports\O365DirSyncFeatures.csv -NoTypeInformation

#Domains
Write-Host "Pulling information about Domains..." -ForegroundColor Magenta
$domains=Get-MsolDomain
($domains|select name,rootdomain,status,verificationmethod,capabilities,Authentication)|Export-Csv .\Reports\O365Domains.csv -NoTypeInformation

#DomainFederationSettings
Write-Host "Pulling information about Domain Federation Settings..." -ForegroundColor Magenta
$output=foreach($domain in $domains){if ($domain.Authentication -eq "Federated") {Get-MsolDomainFederationSettings -DomainName $domain.name}} 
$output|export-csv .\Reports\O365DomainFederationSettings.csv -NoTypeInformation

#Partner Contracts
Write-Host "Pulling information about Partner Contracts..." -ForegroundColor Magenta
$partnercontracts=Get-MsolPartnerContract
if($partnercontracts){$partnercontracts|export-csv .\Reports\O365PartnerContracts.csv -NoTypeInformation}

#Partner Information
Write-Host "Pulling information about Partner Information..." -ForegroundColor Magenta
$partnerinfo=Get-MsolPartnerInformation
if($partnerinfo){$partnerinfo|export-csv .\Reports\O365PartnerInformation.csv -NoTypeInformation}

#Password Policy
Write-Host "Pulling information about Password Policies..." -ForegroundColor Magenta
$passPolRaw=foreach($domain in $domains){Get-MsolPasswordPolicy -DomainName $domain.name}
$passpolOut=@()
$passpolCount=0
while($passpolCount -lt $domains.count){
    $passpolOut+=[pscustomobject]@{DomainName="$($domains[$passpolCount].Name)";NotificationDays="$($passPolRaw[$passpolCount].NotificationDays)";ValidityPeriod="$($passPolRaw[$passpolCount].ValidityPeriod)"}
    $passpolCount++
}
$passpolOut|export-csv .\Reports\O365PasswordPoliciesByDomain.csv -NoTypeInformation

#Roles
Write-Host "Pulling information about O365 Roles..." -ForegroundColor Magenta
$o365roles=Get-MsolRole
$o365roles|export-csv .\Reports\O365Roles.csv -NoTypeInformation

#Role Membership
Write-Host "Pulling information about O365 Role Memberships..." -ForegroundColor Magenta
$roleMemberships=@()
foreach($role in $o365roles){
    $roleID=$role.objectID
    $roleName=$role.Name
    foreach($member in (get-msolrolemember -RoleObjectId $roleID)){
        $membershipObject=[pscustomobject]@{RoleName='';ServicePrincipalType='';EmailAddress='';DisplayName='';IsLicensed=''}
        $membershipObject.RoleName = $roleName
        $membershipObject.ServicePrincipalType=$member.ServicePrincipalType
        $membershipObject.EmailAddress = $member.EmailAddress
        $membershipObject.DisplayName = $member.DisplayName
        $membershipObject.IsLicensed = $member.IsLicensed
        $roleMemberships+=$membershipObject
    }
}
$roleMemberships|Export-Csv .\Reports\O365RoleMemberships.csv -NoTypeInformation

#ScopedRoleMember
Write-Host "Pulling information about Scoped O365 Role Memberships..." -ForegroundColor Magenta
$scopedroleMemberships=@()
foreach($role in $o365roles){
    $scopedroleID=$role.objectID
    $scopedroleName=$role.Name
    foreach($au in $aus){
        $scopedauID=$au.ObjectID
        $scopedauName=$au.DisplayName
        foreach($scopedmember in (Get-MsolScopedRoleMember -RoleObjectId $scopedroleID -AdministrativeUnitObjectId $scopedauID)){
            $scopedmembershipObject=[pscustomobject]@{ScopedAdministrativeUnitID='';ScopedAdministrativeUnitDisplayName='';ScopedRoleName='';ServicePrincipalType='';EmailAddress='';DisplayName='';IsLicensed=''}
            $scopedmembershipObject.ScopedAdministrativeUnitID = $scopedauID
            $scopedmembershipObject.ScopedAdministrativeUnitDisplayName = $scopedauName
            $scopedmembershipObject.ScopedRoleName = $scopedroleName
            $scopedmembershipObject.ServicePrincipalType=$scopedmember.ServicePrincipalType
            $scopedmembershipObject.EmailAddress = $scopedmember.EmailAddress
            $scopedmembershipObject.DisplayName = $scopedmember.DisplayName
            $scopedmembershipObject.IsLicensed = $scopedmember.IsLicensed           
            $scopedroleMemberships+=$scopedmembershipObject
        }
    }
}
$scopedroleMemberships|Export-Csv .\Reports\O365ScopedRoleMemberships.csv -NoTypeInformation

#Service Principal
Write-Host "Pulling information about Service Principals..." -ForegroundColor Magenta
$ServicePrincipalArray = @()
$serviceprincipals=Get-MsolServicePrincipal
foreach($serviceprincipal in $serviceprincipals){
    $tempServicePrincipal = [pscustomobject]@{DisplayName = "$($serviceprincipal.DisplayName)";ObjectID = "$($serviceprincipal.ObjectID)";AppPrincipalID = "$($serviceprincipal.AppPrincipalID)";AccountEnabled = "$($serviceprincipal.AccountEnabled)";TrustedForDelegation = "$($serviceprincipal.TrustedForDelegation)";Addresses = "$($serviceprincipal.Addresses.Address)";ServicePrincipalNames="$($serviceprincipal.ServicePrincipalNames)"}
    $ServicePrincipalArray+=$tempServicePrincipal
}
$ServicePrincipalArray|Export-Csv .\Reports\O365ServicePrincipals.csv -NoTypeInformation

#Setting Templates
#DEPRECATED Get-MsolSettingsTemplate

#Settings
#DEPRECATED Get-MsolSettings

#Subscription
Write-Host "Pulling information about O365 Subscriptions..." -ForegroundColor Magenta
$o365subs=Get-MsolSubscription
$o365subs|export-csv .\Reports\O365Subscriptions.csv -NoTypeInformation
#endregion

#----------------------------------------------------------
#Exchange Online Settings
#----------------------------------------------------------
#region
Connect-ExoPSSession -credential $msoCred
#DEPRECATED $EXOSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $msoCred -Authentication Basic -AllowRedirection 
#DEPRECATED Import-PSSession $EXOSession

#### ACTIVE DIRECTORY
#region
#Organizational Units
Write-Host "Pulling information about Organizational Units..." -ForegroundColor Magenta
$ou=Get-OrganizationalUnit
$ou|Export-Csv .\Reports\EXOOrganizationalUnits.csv -NoTypeInformation
#endregion

#### ADVANCED THREAT PROTECTION
#region
#Anti-Phish Policy
Write-Host "Pulling information about Anti-Phish Policies..." -ForegroundColor Magenta
$antiphishout=(Get-AntiPhishPolicy|select *)
$antiphishout|Export-Csv .\Reports\EXOAntiPhishPolicies.csv -NoTypeInformation
#Anti-Phish Rules
Write-Host "Pulling information about Anti-Phish Rules..." -ForegroundColor Magenta
$antiphishruleout=(Get-AntiPhishRule|select *)
$antiphishruleout|Export-Csv .\Reports\EXOAntiPhishRules.csv -NoTypeInformation
#ATP Policies
Write-Host "Pulling information about ATP Policies..." -ForegroundColor Magenta
$atpp=(get-ATPPolicyForO365|select *)
$atpp|Export-Csv .\Reports\EXOATPPolicies.csv -NoTypeInformation
#Phish Filter Policies
Write-Host "Pulling information about Phish Filter Policies..." -ForegroundColor Magenta
$phishfilterpolicies=Get-PhishFilterPolicy -Detailed -SpoofAllowBlockList|select *
$phishfilterpolicies|Export-Csv .\Reports\EXOPhishFilterPolicies.csv -NoTypeInformation
#Safe Attachment Policies
Write-Host "Pulling information about Safe Attachment Policies..." -ForegroundColor Magenta
$safeAttachmentPolicies=Get-SafeAttachmentPolicy|select *
$safeAttachmentPolicies|Export-Csv .\Reports\EXOSafeAttachmentPolicies.csv -NoTypeInformation
#Safe Attachment Rules
Write-Host "Pulling information about Safe Attachment Rules..." -ForegroundColor Magenta
$safeAttachmentRule=Get-SafeAttachmentRule|select *
$safeAttachmentRule|export-csv .\Reports\EXOSafeAttachmentRules.csv -NoTypeInformation
#Safe Links Policy
Write-Host "Pulling information about Safe Links Policies..." -ForegroundColor Magenta
$safeLinksPolicies=Get-SafeAttachmentRule|select *
$safeLinksPolicies|export-csv .\Reports\EXOSafeLinksPolicies.csv -NoTypeInformation
#Safe Links Rules
Write-Host "Pulling information about Safe Links Rules..." -ForegroundColor Magenta
$safeLinksRule=Get-SafeLinksRule|select *
$safeLinksRule|export-csv .\Reports\EXOSafeLinksRules.csv -NoTypeInformation
#endregion

#### ANTISPAM/ANTIMALWARE/
#region
#DomainKeys Identified Mail (DKIM)
Write-Host "Pulling information about DomainKeys Identified Mail (DKIM)..." -ForegroundColor Magenta
$dkim=(Get-DkimSigningConfig|select *)
$dkim|Export-Csv .\Reports\EXODKIMSigningConfig.csv -NoTypeInformation
#Hosted Connection Filter Policies
Write-Host "Pulling information about Hosted Connection Filter Policies..." -ForegroundColor Magenta
$hcfp=Get-HostedConnectionFilterPolicy
$hcfp|Export-Csv .\Reports\EXOHostedConnectionFilterPolicies.csv -NoTypeInformation
#Hosted Content Filter Policies
Write-Host "Pulling information about Hosted Content Filter Policies..." -ForegroundColor Magenta
$hcfp2=Get-HostedContentFilterPolicy
$hcfp2|Export-Csv .\Reports\EXOHostedContentFilterPolicies.csv -NoTypeInformation
#HostedContentFilterRule
Write-Host "Pulling information about Hosted Content Filter Rules..." -ForegroundColor Magenta
$hcfRule=Get-HostedContentFilterRule|select *
$hcfRule|export-csv .\Reports\EXOHostedContentFilterRules.csv -NoTypeInformation
#Hosted Outbound Spam Filter Policy
Write-Host "Pulling information about Outbound Spam Filter Policies..." -ForegroundColor Magenta
$hosfp=Get-HostedOutboundSpamFilterPolicy
$hosfp|Export-Csv .\Reports\EXOHostedOutboundSpamFilterPolicies.csv -NoTypeInformation
#Hosted Outbound Spam Filter Policy
Write-Host "Pulling information about Outbound Spam Filter Rules..." -ForegroundColor Magenta
$hosfr=Get-HostedOutboundSpamFilterRule
$hosfr|Export-Csv .\Reports\EXOHostedOutboundSpamFilterRules.csv -NoTypeInformation
#Malware Filter Policies
Write-Host "Pulling information about Malware Filter Policies..." -ForegroundColor Magenta
$mfp=(get-malwarefilterpolicy|select *)
$mfp|Export-Csv .\Reports\EXOMalwareFilterPolicies.csv -NoTypeInformation
#Malware Filter Rules
Write-Host "Pulling information about Malware Filter Rules..." -ForegroundColor Magenta
$mfr=(get-malwarefilterrule|select *)
$mfr|Export-Csv .\Reports\EXOMalwareFilterRules.csv -NoTypeInformation
#endregion

#### CLIENT ACCESS
#region
#CAS Mailbox Plans
Write-Host "Pulling information about CAS Mailbox Plans..." -ForegroundColor Magenta
$casmbxplans=Get-CASMailboxPlan|select *
$casmbxplans|Export-Csv .\Reports\EXOCASMailboxPlans.csv -NoTypeInformation
#Client Access Rules
Write-Host "Pulling information about Client Access Rules..." -ForegroundColor Magenta
$clientaccessrules=Get-ClientAccessRule|select *
$clientaccessrules|Export-Csv .\Reports\EXOClientAccessRules.csv -NoTypeInformation
#Outlook Web App Policies
Write-Host "Pulling information about OWA Policies..." -ForegroundColor Magenta
$owapolicies=get-owaMailboxPolicy
$owapolicies|Export-Csv .\Reports\EXOOWAMailboxPolicies.csv -NoTypeInformation
#endregion

#### DEVICES
#region
#ActiveSync Device Access Rules
Write-Host "Pulling information about ActiveSync Device Access Rules..." -ForegroundColor Magenta
$asdar=(Get-ActiveSyncDeviceAccessRule|select *)
$asdar|Export-Csv .\Reports\EXOActiveSyncDeviceAccessRules.csv -NoTypeInformation
#ActiveSync Device Classes
Write-Host "Pulling information about ActiveSync Device Classes..." -ForegroundColor Magenta
$asdc=(Get-ActiveSyncDeviceClass|select *)
$asdc|Export-Csv .\Reports\EXOActiveSyncDeviceClass.csv -NoTypeInformation
#ActiveSync Mailbox Policies
Write-Host "Pulling information about ActiveSync Mailbox Policies..." -ForegroundColor Magenta
$activesyncmp=(Get-ActiveSyncMailboxPolicy|select *)
$activesyncmp|Export-Csv .\Reports\EXOActiveSyncMailboxPolicies.csv -NoTypeInformation
#ActiveSync Organization Settings
Write-Host "Pulling information about ActiveSync Organization Settings..." -ForegroundColor Magenta
$asos=get-ActiveSyncOrganizationSettings
$asos|Export-Csv .\Reports\EXOActiveSyncOrganizationSettings.csv -NoTypeInformation
#Mobile Device Mailbox Policies
Write-Host "Pulling information about Mobile Device Mailbox Policies..." -ForegroundColor Magenta
$mdmp=(get-MobileDeviceMailboxPolicy|select *)
$mdmp|Export-Csv .\Reports\EXOMobileDeviceMailboxPolicies.csv -NoTypeInformation
#endregion

#### EMAIL ADDRESSES AND ADDRESS BOOKS
#region
#Email address policies
Write-Host "Pulling information about Email Address Policies..." -ForegroundColor Magenta
$EmailAddressPolicy=Get-EmailAddressPolicy|select *
$EmailAddressPolicy|export-csv .\Reports\EXOEmailAddressPolicies.csv -NoTypeInformation
#endregion

#### ENCRYPTION AND CERTIFICATES
#region
#Data Encryption Policy
Write-Host "Pulling information about Data Encryption Policy..." -ForegroundColor Magenta
$dataep=Get-DataEncryptionPolicy|select *
$dataep|Export-Csv .\Reports\EXODataEncryptionPolicy.csv -NoTypeInformation
#IRM Configuration
Write-Host "Pulling information about IRM Configuration..." -ForegroundColor Magenta
$irmc=Get-IRMConfiguration
$irmc|Export-Csv .\Reports\EXOIRMConfiguration.csv -NoTypeInformation
#Office 365 Message Encryption
Write-Host "Pulling information about Office 365 Message Encryption..." -ForegroundColor Magenta
$omec=Get-OMEConfiguration
$omec|Export-Csv .\Reports\EXOOMEConfiguration.csv -NoTypeInformation
#RMS Templates
Write-Host "Pulling information about RMS Templates..." -ForegroundColor Magenta
$rmst=(Get-RMSTemplate|select *)
$rmst|Export-Csv .\Reports\EXORMSTemplates.csv -NoTypeInformation
<#DEPRECATED
#RMS Trusted Publishing Domains
Write-Host "Pulling information about RMS Trusted Publishing Domains..." -ForegroundColor Magenta
$rmstpd=Get-RMSTrustedPublishingDomain
$rmstpd|Export-csv .\Reports\EXORMSTrustedPublishingDomain.csv -NoTypeInformation
#>
#S/MIME config
Write-Host "Pulling information about S/MIME Config..." -ForegroundColor Magenta
$smimeconfig=Get-SmimeConfig
$smimeconfig|Export-Csv .\Reports\EXOSMimeConfig.csv -NoTypeInformation
#endregion

#### FEDERATION AND HYBRID
#region
#Federated Organization Identifiers
Write-Host "Pulling information about Federated Organization Identifiers ..." -ForegroundColor Magenta
$fio=(Get-FederatedOrganizationIdentifier|select *)
$fio|Export-Csv .\Reports\EXOFederatedOrganizationIdentifier.csv -NoTypeInformation
#Federation Information
Write-Host "Pulling information about Federation..." -ForegroundColor Magenta
$fi=@()
$domains=Get-MsolDomain
$dnames = $domains.name
foreach($d in $dnames){
    $fedinfo=Get-FederationInformation -domainName $d -force
    $fedinfoobj=[pscustomobject]@{DomainName='';TargetApplicationURI='';TargetAutodiscoverEpr='';TokenIssuerURIs='';IsValid='';ObjectState=''}
    $fedinfoobj.DomainName = $d
    $fedinfoobj.TargetApplicationURI=$fedinfo.TargetApplicationURI
    $fedinfoobj.TargetAutodiscoverEpr = $fedinfo.TargetAutodiscoverEpr
    $fedinfoobj.TokenIssuerURIs = $fedinfo.TokenIssuerURIs
    $fedinfoobj.Isvalid = $fedinfo.IsValid
    $fedinfoobj.ObjectState = $fedinfo.ObjectState
    $fi+=$fedinfoobj
}
$fi|export-csv .\Reports\EXOFederationInformation.csv -NoTypeInformation
#Federation Trusts
Write-Host "Pulling information about Federation Trusts..." -ForegroundColor Magenta
$ft=(Get-FederationTrust|select *)
$ft|export-csv .\Reports\EXOFederationTrusts.csv -NoTypeInformation
#Hybrid Mail Flow
Write-Host "Pulling information about Hybrid Mail Flow..." -ForegroundColor Magenta
$hmf=Get-HybridMailflow
$hmf|Export-Csv .\Reports\EXOHybridMailFlow.csv -NoTypeInformation
#Hybrid Mail Flow Datacenter IPs
Write-Host "Pulling information about Hybrid Mail Flow Datacenter IPs..." -ForegroundColor Magenta
$hmfdcips=Get-HybridMailflowDatacenterIPs
$hmfdcips|export-csv .\Reports\EXOHybridMailflowDatacenterIPs.csv -NoTypeInformation
#IntraOrganizationConnector
Write-Host "Pulling information about IntraOrganization Connectors..." -ForegroundColor Magenta
$ioc=Get-IntraOrganizationConnector
$ioc|Export-Csv .\Reports\EXOIntraOrganizationConnector.csv -NoTypeInformation
#On-Premises Organization
Write-Host "Pulling information about on-premises organization..." -ForegroundColor Magenta
$opo=Get-OnPremisesOrganization
$opo|Export-Csv .\Reports\EXOOnPremisesOrganization.csv -NoTypeInformation
#endregion

#### MAILBOX DATABASES AND SERVERS
#region
#Search Document Format
Write-Host "Pulling information about Search Document Format..." -ForegroundColor Magenta
$sdf=Get-SearchDocumentFormat
$sdf|Export-Csv .\Reports\EXOSearchDocumentFormat.csv -NoTypeInformation
#endregion

#### MAILBOX
#region
#Apps for Outlook
Write-Host "Pulling information about Apps For Outlook..." -ForegroundColor Magenta
$apps=Get-App
$apps|Export-Csv .\Reports\EXOAppsForOutlook.csv -NoTypeInformation
#Mailbox Plans
Write-Host "Pulling information about Mailbox Plans..." -ForegroundColor Magenta
$mp=(Get-MailboxPlan|select *)
$mp|Export-Csv .\Reports\EXOMailboxPlans.csv -NoTypeInformation
#endregion

#### MAIL FLOW
#region
#Accepted Domains
Write-Host "Pulling information about Accepted Domains..." -ForegroundColor Magenta
$ad=Get-AcceptedDomain|select *
$ad|Export-Csv .\Reports\EXOAcceptedDomains.csv -NoTypeInformation
#Inbound Connectors
Write-Host "Pulling information about Inbound Connectors..." -ForegroundColor Magenta
$ic=Get-InboundConnector|select *
$ic|Export-Csv .\Reports\EXOInboundConnectors.csv -NoTypeInformation
#Outbound Connectors
Write-Host "Pulling information about Outbound Connectors..." -ForegroundColor Magenta
$oc=Get-OutboundConnector|select *
$oc|Export-Csv .\Reports\EXOOutboundConnectors.csv -NoTypeInformation
#Remote Domains
Write-Host "Pulling information about Remote Domains..." -ForegroundColor Magenta
$rd=Get-RemoteDomain|select *
$rd|Export-Csv .\Reports\EXORemoteDomains.csv -NoTypeInformation
#Transport Config
Write-Host "Pulling information about Transport Config..." -ForegroundColor Magenta
$tc=Get-TransportConfig
$tc|Export-Csv .\Reports\EXOTransportConfig.csv -NoTypeInformation
#endregion

#### MOVE AND MIGRATION
#region
#Migration Config
Write-Host "Pulling information about Migration Config..." -ForegroundColor Magenta
$mc=(Get-MigrationConfig|select *)
$mc|Export-Csv .\Reports\EXOMigrationConfig.csv -NoTypeInformation
#Migration Endpoints
Write-Host "Pulling information about Migration Endpoints..." -ForegroundColor Magenta
$me=(Get-MigrationEndpoint|select *)
$me|Export-Csv .\Reports\EXOMigrationEndpoints.csv -NoTypeInformation
#endregion

#### ORGANIZATION
#region
#App Access Policies
Write-Host "Pulling information about Application Access Policies..." -ForegroundColor Magenta
$appAccessPol=Get-ApplicationAccessPolicy
$appAccessPol|Export-Csv .\Reports\EXOApplicationAccessPolicies.csv -NoTypeInformation
#Authentication Policies
Write-Host "Pulling information about Authentication Policies..." -ForegroundColor Magenta
$authPol=Get-AuthenticationPolicy
$authPol|Export-Csv .\Reports\EXOApplicationAccessPolicies.csv -NoTypeInformation
#Auth Servers
Write-Host "Pulling information about Auth Servers..." -ForegroundColor Magenta
$as=Get-AuthServer
$as|Export-Csv .\Reports\EXOAuthServers.csv -NoTypeInformation
#Organization Config
Write-Host "Pulling information about Organization Config..." -ForegroundColor Magenta
$orgConfig=Get-OrganizationConfig
$orgConfig|Export-Csv .\Reports\EXOOrganizationConfig.csv -NoTypeInformation
#Partner Applications
Write-Host "Pulling information about Partner Applications..." -ForegroundColor Magenta
$pa=(Get-PartnerApplication|select *)
$pa|Export-Csv .\Reports\EXOPartnerApplications.csv -NoTypeInformation
#Perimeter Config
Write-Host "Pulling information about Perimeter Config..." -ForegroundColor Magenta
$perimeterConfig=(Get-PerimeterConfig|select *)
$perimeterConfig|Export-Csv .\Reports\EXOPerimeterConfig.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE
#region
#Journal Rules
Write-Host "Pulling information about Journal Rules..." -ForegroundColor Magenta
$jr=(Get-JournalRule|select *)
$jr|Export-Csv .\Reports\EXOJournalRules.csv -NoTypeInformation
#Message Classifications
Write-Host "Pulling information about Message Classifications..." -ForegroundColor Magenta
$mc=(Get-MessageClassification|select *)
$mc|export-csv .\Reports\EXOMessageClassifications.csv -NoTypeInformation
#Outlook Protection Rules
Write-Host "Pulling information about Outlook Protection Rules..." -ForegroundColor Magenta
$opr=(Get-OutlookProtectionRule|select *)
$opr|Export-Csv .\Reports\EXOOutlookProtectionRules.csv -NoTypeInformation
#Transport Rules
Write-Host "Pulling information about Transport Rules..." -ForegroundColor Magenta
$tr=(Get-TransportRule|select *)
$tr|Export-Csv .\Reports\EXOTransportRules.csv -NoTypeInformation
#Transport Rule Actions
Write-Host "Pulling information about Transport Rule Actions..." -ForegroundColor Magenta
$tra=(Get-TransportRuleAction|select *)
$tra|Export-Csv .\Reports\EXOTransportRuleActions.csv -NoTypeInformation
#Transport Rule Predicates
Write-Host "Pulling information about Transport Rule Predicates..." -ForegroundColor Magenta
$trp=(Get-TransportRulePredicate|select *)
$trp|Export-Csv .\Reports\EXOTransportRulePredicates.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - AUDIT
#region
#Admin Audit Log Config
Write-Host "Pulling information about Admin Audit Log Config..." -ForegroundColor Magenta
$aalc=Get-AdminAuditLogConfig
$aalc|Export-Csv .\Reports\EXOAdminAuditLogConfig.csv -NoTypeInformation
#Mailbox Audit Bypass Associations
Write-Host "Pulling information about Mailbox Audit Bypass Associations..." -ForegroundColor Magenta
$aaba=Get-MailboxAuditBypassAssociation
$aaba|Export-Csv .\Reports\EXOMailboxAuditBypassAssociation.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - DLP
#region
#Classification Rule Collections
Write-Host "Pulling information about Classification Rule Collections..." -ForegroundColor Magenta
$crc=Get-ClassificationRuleCollection
$crc|Export-Csv .\Reports\EXOClassificationRuleCollections.csv -NoTypeInformation
#Data Classifications
Write-Host "Pulling information about Data Classifications..." -ForegroundColor Magenta
$dc=Get-DataClassification
$dc|Export-Csv .\Reports\EXODataClassifications.csv -NoTypeInformation
#Data Classification Config
Write-Host "Pulling information about Data Classification Config..." -ForegroundColor Magenta
$dcc=Get-DataClassificationConfig
$dcc|Export-Csv .\Reports\EXODataClassificationConfig.csv -NoTypeInformation
#DLP Policies
Write-Host "Pulling information about DLP Policies ..." -ForegroundColor Magenta
$dlpp=(Get-DLPPolicy|select *)
$dlpp|Export-Csv .\Reports\EXODLPPolicies.csv -NoTypeInformation
#DLP Policy Templates
Write-Host "Pulling information about DLP Policy Templates..." -ForegroundColor Magenta
$dlppt=(Get-DLPPolicyTemplate|select *)
$dlppt|Export-Csv .\Reports\EXODLPPolicyTemplates.csv -NoTypeInformation
#Policy Tip Config
Write-Host "Pulling information about Policy Tip Config..." -ForegroundColor Magenta
$ptc=Get-PolicyTipConfig
$ptc|Export-Csv .\Reports\EXOPolicyTipConfig.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - RETENTION
#region
#Get-ComplianceTag
Write-Host "Pulling information about Compliance Tags..." -ForegroundColor Magenta
$excomptag=Get-ComplianceTag|select *
$excomptag|Export-Csv .\Reports\EXOComplianceTags.csv -NoTypeInformation
#Get-ComplianceTagStorage
Write-Host "Pulling information about Compliance Tag Storage..." -ForegroundColor Magenta
$excomptagstor=Get-ComplianceTagStorage|select *
$excomptagstor|Export-Csv .\Reports\EXOComplianceTagStorage.csv -NoTypeInformation
#Retention Policies
Write-Host "Pulling information about Retention Policies..." -ForegroundColor Magenta
$rp=(Get-RetentionPolicy|select *)
$rp|Export-Csv .\Reports\EXORetentionPolicies.csv -NoTypeInformation
#Retention Policy Tags
Write-Host "Pulling information about Retention Policy Tags..." -ForegroundColor Magenta
$rpt=(Get-RetentionPolicyTag|select *)
$rpt|Export-Csv .\Reports\EXORetentionPolicyTags.csv -NoTypeInformation
#endregion

#### ROLE BASED ACCESS CONTROL
#region
#Management Roles
Write-Host "Pulling information about Management Roles..." -ForegroundColor Magenta
$mr=(Get-ManagementRole|select *)
$mr|export-csv .\Reports\EXOManagementRoles.csv -NoTypeInformation
#Management Role Assignments
Write-Host "Pulling information about Management Role Assignments..." -ForegroundColor Magenta
$mra=Get-ManagementRoleAssignment
$mra|Export-Csv .\Reports\EXOManagementRoleAssignments.csv -NoTypeInformation
#Management Role Entries
Write-Host "Pulling information about Management Role Entries..." -ForegroundColor Magenta
$roleentries=@()
foreach($role in $mr){
    $mre=Get-ManagementRoleEntry -Identity "$($role.name)\*"
    foreach($entry in $mre){
        $customEntry=[pscustomobject]@{Name='';Role=''}
        $customEntry.Name = $entry.name
        $customEntry.Role = $entry.role
        $roleentries+=$customEntry
    }
}
$roleentries|Export-Csv .\Reports\EXOManagementRoleEntries.csv -NoTypeInformation
#Management Scopes
Write-Host "Pulling information about Management Scopes..." -ForegroundColor Magenta
$ms=(Get-ManagementScope|select *)
$ms|Export-Csv .\Reports\EXOManagementScopes.csv -NoTypeInformation
#Role Assignment Policies
Write-Host "Pulling information about Role Assignment Policies..." -ForegroundColor Magenta
$rap=(Get-RoleAssignmentPolicy|select *)
$rap|Export-Csv .\Reports\EXORoleAssignmentPolicies.csv -NoTypeInformation
#Role Groups
Write-Host "Pulling information about Role Groups..." -ForegroundColor Magenta
$rg=Get-RoleGroup
$rg|Export-Csv .\Reports\EXORoleGroups.csv -NoTypeInformation
#Role Group Members
Write-Host "Pulling information about Role Group Members..." -ForegroundColor Magenta
$roleGroupMembers=@()
foreach($roleGroup in $rg){
    $rgm=Get-RoleGroupMember -Identity $roleGroup.name
    foreach($member in $rgm){
        $customMember=[pscustomobject]@{RoleGroup='';Name='';RecipientType='';PrimarySMTPAddress=''}
        $customMember.RoleGroup = $roleGroup.name
        $customMember.Name = $member.Name
        $customMember.RecipientType = $member.RecipientType
        $customMember.PrimarySMTPAddress = $member.PrimarySMTPAddress
        $roleGroupMembers+=$customMember
    }
}
$roleGroupMembers|Export-Csv .\Reports\EXORoleGroupMembers.csv -NoTypeInformation
#endregion

#### SHARING AND COLLABORATION
#region
#Availability Address Spaces
Write-Host "Pulling information about Availability Address Spaces..." -ForegroundColor Magenta
$aas=(Get-AvailabilityAddressSpace|select *)
$aas|Export-Csv .\Reports\EXOAvailabilityAddressSpaces.csv -NoTypeInformation
#Availability Config
Write-Host "Pulling information about Availability Config..." -ForegroundColor Magenta
$ac=(get-AvailabilityConfig|select *)
$ac|Export-Csv .\Reports\EXOAvailabilityConfig.csv -NoTypeInformation
#Organization Relationships
Write-Host "Pulling information about Organization Relationships..." -ForegroundColor Magenta
$orgRel=(Get-OrganizationRelationship|select *)
$orgRel|Export-Csv .\Reports\EXOOrganizationRelationships.csv -NoTypeInformation
#Sharing Policies
Write-Host "Pulling information about Sharing Policies..." -ForegroundColor Magenta
$sp=(Get-SharingPolicy|select *)
$sp|Export-Csv .\Reports\EXOSharingPolicy.csv -NoTypeInformation
#Site Mailbox Provisioning Policies
Write-Host "Pulling information about Site Mailbox Provisioning Policies..." -ForegroundColor Magenta
$smpp=(Get-SiteMailboxProvisioningPolicy|select *)
$smpp|Export-Csv .\Reports\EXOSiteMailboxProvisioningPolicies.csv -NoTypeInformation
#endregion

#### UNIFIED MESSAGING
#region
#UM AutoAttendants
Write-Host "Pulling information about UM AutoAttendants..." -ForegroundColor Magenta
$umaa=(Get-UMAutoAttendant|select *)
$umaa|Export-Csv .\Reports\EXOUMAutoAttendants.csv -NoTypeInformation
#UM Dial Plans
Write-Host "Pulling information about UM Dial Plans..." -ForegroundColor Magenta
$umdp=(Get-UMDialPlan|select *)
$umdp|Export-Csv .\Reports\EXOUMDialPlans.csv -NoTypeInformation
#UM Hunt Groups
Write-Host "Pulling information about UM Hunt Groups..." -ForegroundColor Magenta
$umhg=(Get-UMHuntGroup|select *)
$umhg|Export-Csv .\Reports\EXOUMHuntGroups.csv -NoTypeInformation
#UM IP Gateways
Write-Host "Pulling information about UM IP Gateways..." -ForegroundColor Magenta
$umipg=(Get-UMIPGateway|select *)
$umipg|Export-Csv .\Reports\EXOUMIPGateways.csv -NoTypeInformation
#UM Mailbox Policies
Write-Host "Pulling information about UM Mailbox Policies..." -ForegroundColor Magenta
$ummbxpol=(Get-UMMailboxPolicy|select *)
$ummbxpol|Export-Csv .\Reports\EXOUMMailboxPolicies.csv -NoTypeInformation
#endregion

Get-PSSession|Remove-PSSession 
#endregion

#----------------------------------------------------------
#SharePoint Online
#----------------------------------------------------------
#region
Import-Module Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url $SPOURL -Credential $msoCred

#SPO Browser Idle Signout
Write-Host "Pulling information about SPO Browser Idle Signout..." -ForegroundColor Magenta
$spobiso=Get-SPOBrowserIdleSignOut|select *
$spobiso|Export-Csv .\Reports\SPOBrowserIdleSignout.csv -NoTypeInformation

#SPO Built In Design Package Visibility
Write-Host "Pulling information about SPO Built In Design Package Visibility..." -ForegroundColor Magenta
$spobidpv=Get-SPOBuiltInDesignPackageVisibility|select *
$spobidpv|Export-Csv .\Reports\SPOBuiltInDesignPackageVisibility.csv -NoTypeInformation

#SPO Sites
Write-Host "Pulling information about SPO Sites..." -ForegroundColor Magenta
$spos=Get-SPOSite|select *
$spos|Export-Csv .\Reports\SPOSites.csv -NoTypeInformation

#SPO Site Data Encryption Policy
Write-Host "Pulling information about SPO Site Data Encryption Policies..." -ForegroundColor Magenta
$SPODEParray=@()
foreach($sposite in $spos){
    $tempSpoSiteDEP=Get-SPOSiteDataEncryptionPolicy -Identity $sposite.URL -ErrorAction SilentlyContinue|select *
    if($tempSpoSiteDEP){
        $SPODEParray+=$tempSpoSiteDEP
    }
}
$SPODEParray|export-csv .\Reports\SPOSiteDataEncryptionPolicy.csv -NoTypeInformation

#SPO Geo Administrators
Write-Host "Pulling information about SPO Geo Administrators..." -ForegroundColor Magenta
$spogeoadmin=Get-SPOGeoAdministrator
if($spogeoadmin){
    $spogeoadmin|Export-Csv .\Reports\SPOGeoAdministrators.csv -NoTypeInformation
}
else{
    @()|Export-Csv .\Reports\SPOGeoAdministrators.csv -NoTypeInformation
}

#SPO Geo Move Cross Compatability Status
Write-Host "Pulling information about SPO Geo Move Cross Compatibility Status..." -ForegroundColor Magenta
$spogeomccs=Get-SPOGeoMoveCrossCompatibilityStatus
if($spogeomccs){
    $spogeomccs|Export-Csv .\Reports\SPOGeoMoveCrossCompatibilityStatus.csv -NoTypeInformation
}
else{
    @()|Export-Csv .\Reports\SPOGeoMoveCrossCompatibilityStatus.csv -NoTypeInformation
}

#SPO Geo Storage Quota
Write-Host "Pulling information about SPO Geo Storage Quota..." -ForegroundColor Magenta
$spogeosq=Get-SPOGeoStorageQuota|select *
$spogeosq|Export-Csv .\Reports\SPOGeoStorageQuota.csv -NoTypeInformation

#SPO Hide Default Themes
Write-Host "Pulling information about SPO Hide Default Themes..." -ForegroundColor Magenta
$spohidedefthemes=[pscustomobject]@{HideDefaultThemes="$(Get-SPOHideDefaultThemes)"}
$spohidedefthemes|Export-Csv .\Reports\SPOHideDefaultThemes.csv -NoTypeInformation

#SPO Home Sites
Write-Host "Pulling information about SPO Home Site..." -ForegroundColor Magenta
$spohomesite=Get-SPOHomeSite|select *
$spohomesite|Export-Csv .\Reports\SPOHomeSite.csv -NoTypeInformation

#SPO Hub Sites
Write-Host "Pulling information about SPO Hub Sites..." -ForegroundColor Magenta
$spohubsite=Get-SPOHubSite|select *
$spohubsite|Export-Csv .\Reports\SPOHubSite.csv -NoTypeInformation

#SPO Multi-Geo Company Allowed Data Locations
Write-Host "Pulling information about SPO Multi-Geo Company Allowed Data Locations..." -ForegroundColor Magenta
$spomgcadl=Get-SPOMultiGeoCompanyAllowedDataLocation|select *
$spomgcadl|Export-Csv .\Reports\SPOMultiGeoCompanyAllowedDataLocation.csv -NoTypeInformation

#SPO Multi-Geo Experience
Write-Host "Pulling information about SPO Multi-Geo Experience..." -ForegroundColor Magenta
$spomgex=Get-SPOMultiGeoExperience
$spomgex|Export-Csv .\Reports\SPOMultiGeoExperience.csv -NoTypeInformation

#SPO Organization Assets Libraries
Write-Host "Pulling information about SPO Organization Assets Libraries..." -ForegroundColor Magenta
$spoorgassetlib=Get-SPOOrgAssetsLibrary
if($spoorgassetlib -like "No libraries have been*"){
    $spoorgassetlib=[pscustomobject]@{Status="$spoorgassetlib"}
}
else{
    $spoorgassetlib=Get-SPOOrgAssetsLibrary|select *
}
$spoorgassetlib|Export-Csv .\Reports\SPOOrgAssetLibrary.csv -NoTypeInformation

#SPO Organization News Sites
Write-Host "Pulling information about SPO Organization News Site..." -ForegroundColor Magenta
$spoorgnewssiteobj=Get-SPOOrgNewsSite
$spoorgnewssite=@()
if($spoorgnewssiteobj -like ""){
    $spoorgnewssite=[pscustomobject]@{Site="No Org News Sites"}
}
elseif($spoorgnewssiteobj.count -eq 1){
    $spoorgnewssite=[pscustomobject]@{Site="$(Get-SPOOrgNewsSite)"}
}
else{
    $spoorgnewssiteobj|foreach{
        $spoorgnewssite+=[pscustomobject]@{Site="$_"}
    }
}
$spoorgnewssite|Export-Csv .\Reports\SPOOrgNewsSite.csv -NoTypeInformation

#SPO Site Collection App Catalogs
Write-Host "Pulling information about SPO Site Collection App Catalogs..." -ForegroundColor Magenta
$scAppCatalogs=Get-SPOSiteCollectionAppCatalogs -Site $spos.url[0]
$scAppCatalogs|Export-Csv .\Reports\SPOSiteCollectionAppCatalogs.csv -NoTypeInformation

#SPO Data Encryption Policy
Write-Host "Pulling information about SPO Data Encryption Policy..." -ForegroundColor Magenta
$spodataencpol=Get-SPOSiteDataEncryptionPolicy -Identity $SPOURL
if($spodataencpol){
    $spodataencpol|Export-Csv .\Reports\SPODataEncryptionPolicies.csv -NoTypeInformation
}
else{
    @()|Export-Csv .\Reports\SPODataEncryptionPolicies.csv -NoTypeInformation
}

#SPO Site Designs
Write-Host "Pulling information about SPO Site Designs..." -ForegroundColor Magenta
$spositedesign=Get-SPOSiteDesign
$spositedesign|Export-Csv .\Reports\SPOSiteDesigns.csv -NoTypeInformation

#SPO Site Design Rights
Write-Host "Pulling information about SPO Site Design Rights..." -ForegroundColor Magenta
$spositedesignrightsoutput=@()
if($spositedesign){
    $spositedesign|foreach{
        $spositedesignrightsoutput+=Get-SPOSiteDesignRights -Identity $_
    }
}
$spositedesignrightsoutput|Export-Csv .\Reports\SPOSiteDesignRights.csv -NoTypeInformation

#SPO Site Design Runs
Write-Host "Pulling information about SPO Site Design Runs..." -ForegroundColor Magenta
$spositedesignrunsoutput=@()
foreach($sposite in $spos.URL){
    $sposite
    $spositedesignrunsoutput+=[pscustomobject]@{Site = "$($sposite)";DesignRun = "$(Get-SPOSiteDesignRun -WebUrl $sposite)"}
}
$spositedesignrunsoutput|Export-Csv .\Reports\SPOSiteDesignRuns.csv -NoTypeInformation

#SPO Site Groups
Write-Host "Pulling information about SPO Site Groups..." -ForegroundColor Magenta
$sitesandgroups=@()
foreach($sposite in $spos.URL){
    $sposite
    $spositeg=Get-SPOSiteGroup -Site $sposite
    foreach($g in $spositeg){
        $spositegroup=[pscustomobject]@{URL='';LoginName='';Title='';OwnerLoginName='';OwnerTitle='';Users='';Roles=''}
        $spositegroup.URL = $sposite
        $spositegroup.LoginName=$g.LoginName
        $spositegroup.Title=$g.Title
        $spositegroup.OwnerLoginName=$g.OwnerLoginName
        $userlist = ""        
        foreach($item in $g.Users){
            $userlist+="$item;"
        }
        $spositegroup.Users=$userlist
        $rolelist = ""
        foreach($role in $g.roles){
            $rolelist+="$role;"
        }
        $spositegroup.Roles=$rolelist
        $sitesandgroups+=$spositegroup
    }
} 
$sitesandgroups| Export-Csv .\Reports\SPOSiteUserGroups.csv -NoTypeInformation 

#SPO Tenant Settings
Write-Host "Pulling information about SPO Tenant Settings..." -ForegroundColor Magenta
$spotenant=Get-SPOTenant
$spotenant|Export-Csv .\Reports\SPOTenantSettings.csv -NoTypeInformation 

#Get-SPOTenantCDNEnabled
Write-Host "Pulling information about SPO CDN Enablement" -ForegroundColor Magenta
$spoPublicCDNEnabled=[pscustomobject]@{CdnType='Public';Enabled="$((get-SPOTenantCdnEnabled -CdnType Public).value)"}
$spoPrivateCDNEnabled=[pscustomobject]@{CdnType='Private';Enabled="$((get-SPOTenantCdnEnabled -CdnType Private).value)"}
$spoCDNEnabledAggregate = @()
$spoCDNEnabledAggregate += $spoPublicCDNEnabled
$spoCDNEnabledAggregate += $spoPrivateCDNEnabled
$spoCDNEnabledAggregate|export-csv .\Reports\SPOCDNEnabled.csv -NoTypeInformation

#SPO Tenant Public CDN Origins
Write-Host "Pulling information about SPO Public CDN Origins..." -ForegroundColor Magenta
$spocdnopub=Get-SPOTenantCdnOrigins -CdnType Public
$spocdnopub|Export-Csv .\Reports\SPOTenantCDNOrigins-Public.csv -NoTypeInformation

#SPO Tenant Private CDN Origins
Write-Host "Pulling information about SPO Private CDN Origins..." -ForegroundColor Magenta
$spocdnopriv=Get-SPOTenantCdnOrigins -CdnType Private
$spocdnopriv|Export-Csv .\Reports\SPOTenantCDNOrigins-Private.csv -NoTypeInformation

#SPO Tenant Public CDN Policies
Write-Host "Pulling information about SPO Public CDN Policies..." -ForegroundColor Magenta
$spocdnpolpub=Get-SPOTenantCdnPolicies -CdnType Public
$spocdnpolpub.getenumerator()|Export-Csv .\Reports\SPOTenantCDNPolicies-Public.csv -NoTypeInformation

#SPO Tenant Private CDN Policies
Write-Host "Pulling information about SPO Private CDN Policies..." -ForegroundColor Magenta
$spocdnpolpriv=Get-SPOTenantCdnPolicies -CdnType Private
$spocdnpolpriv.getenumerator()|Export-Csv .\Reports\SPOTenantCDNPolicies-Private.csv -NoTypeInformation

#SPO Tenant Service Principal Permission Grants
Write-Host "Pulling information about SPO Tenant Service Principal Permission Grants..." -ForegroundColor Magenta
$spotsppg=Get-SPOTenantServicePrincipalPermissionGrants
$spotsppg|Export-Csv .\Reports\SPOTenantServicePrincipalPermissionGrants.csv -NoTypeInformation

#SPO Tenant Sync Client Restrictions
Write-Host "Pulling information about SPO Tenant Sync Client Restrictions..." -ForegroundColor Magenta
$spotscrestrictions=Get-SPOTenantSyncClientRestriction
$domainsallowed=""
foreach($dom in $spotscrestrictions.AllowedDomainList){
    $domainsallowed+="$dom "
}
$fileextensions=""
foreach($fileext in $spotscrestrictions.ExcludedFileExtensions){
    $fileextensions+="$fileext "
}
$spotscrrevised=[pscustomobject]@{TenantRestrictionEnabled='';AllowedDomainList='';BlockMacSync='';ExcludedFileExtensions='';OptOutOfGrooveBlock='';OptOutOfGrooveSoftBlock=''}
$spotscrrevised.TenantRestrictionEnabled = $spotscrestrictions.TenantRestrictionEnabled
$spotscrrevised.AllowedDomainList = "$domainsallowed"
$spotscrrevised.BlockMacSync = $spotscrestrictions.BlockMacSync
$spotscrrevised.ExcludedFileExtensions = "$fileextensions"
$spotscrrevised.OptOutOfGrooveBlock = $spotscrestrictions.OptOutOfGrooveBlock
$spotscrrevised.OptOutOfGrooveSoftBlock = $spotscrestrictions.OptOutOfGrooveSoftBlock
$spotscrrevised|Export-Csv .\Reports\SPOTenantSyncClientRestrictions.csv -NoTypeInformation

#SPO Themes
Write-Host "Pulling information about SPO Themes..." -ForegroundColor Magenta
$spothemes=Get-SPOTheme
$spothemes|Export-Csv .\Reports\SPOThemes.csv -NoTypeInformation

#SPO Users 
Write-Host "Pulling information about SPO Users..." -ForegroundColor Magenta
$sitesandusers=@()
foreach($sposite in (Get-SPOSite).URL){
    $spositeu=Get-SPOUser -Site $sposite
    $sposite
    foreach($u in $spositeu){
        $spositeuser=[pscustomobject]@{URL='';DisplayName='';LoginName='';IsSiteAdmin='';IsGroup='';Groups=''}
        $spositeuser.URL = $sposite
        $spositeuser.DisplayName=$u.DisplayName
        $spositeuser.LoginName=$u.LoginName
        $spositeuser.IsSiteAdmin=$u.IsSiteAdmin
        $spositeuser.IsGroup=$u.IsGroup
        $groops=""
        foreach($groop in $u.Groups){
            $groops+="$groop; "
        }
        $spositeuser.Groups=$groops
        $sitesandusers+=$spositeuser
    }
}
$sitesandusers|Export-Csv .\Reports\SPOSiteUsers.csv -NoTypeInformation

#SPO Web Templates
Write-Host "Pulling information about SPO Web Templates..." -ForegroundColor Magenta
$spowt=Get-SPOWebTemplate
$spowt|Export-Csv .\Reports\SPOWebTemplates.csv -NoTypeInformation

Disconnect-SPOService
#endregion

#----------------------------------------------------------
#Security and Compliance Center
#----------------------------------------------------------
#region
Connect-IPPSSession -credential $msoCred
#DEPRECATED $SecurityAndComplianceSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $msocred -Authentication Basic -AllowRedirection
#DEPRECATED Import-PSSession $SecurityAndComplianceSession

#### DEVICES
#region
#Device Conditional Access Policies
Write-Host "Pulling information about Device Conditional Access Policies..." -ForegroundColor Magenta
$devcondaccpol=Get-DeviceConditionalAccessPolicy
$devcondaccpol|export-csv .\Reports\SandCDeviceConditionalAccessPolicies.csv -NoTypeInformation
#Device Conditional Access Rules
Write-Host "Pulling information about Device Conditional Access Rules..." -ForegroundColor Magenta
$devcondaccrules=Get-DeviceConditionalAccessRule
$devcondaccrules|export-csv .\Reports\SandCDeviceConditionalAccessRules.csv -NoTypeInformation
#Device Configuration Policies
Write-Host "Pulling information about Device Configuration Policies..." -ForegroundColor Magenta
$devconfigpol=Get-DeviceConfigurationPolicy
$devconfigpol|export-csv .\Reports\SandC.csvDeviceConfigurationPolicies.csv -NoTypeInformation
#Device Configuration Rules
Write-Host "Pulling information about Device Configuration Rules..." -ForegroundColor Magenta
$devconfigrules=Get-DeviceConfigurationRule
$devconfigrules|export-csv .\Reports\SandCDeviceConfigurationRules.csv -NoTypeInformation
#Device Policies
Write-Host "Pulling information about Device Policies..." -ForegroundColor Magenta
$devpol=Get-DevicePolicy
$devpol|export-csv .\Reports\SandCDevicePolicies.csv -NoTypeInformation
#Device Tenant Policies
Write-Host "Pulling information about Device Tenant Policies..." -ForegroundColor Magenta
$devtenantpol=Get-DeviceTenantPolicy
$devtenantpol|export-csv .\Reports\SandCDeviceTenantPolicies.csv -NoTypeInformation
#Device Tenant Rules
Write-Host "Pulling information about Device Tenant Rules..." -ForegroundColor Magenta
$devtenantrules=Get-DeviceTenantRule
$devtenantrules|export-csv .\Reports\SandCDeviceTenantRules.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - GENERAL
#region
#Information Barrier Policies
Write-Host "Pulling information about Information Barrier Policies..." -ForegroundColor Magenta
$infobarrierpol=Get-InformationBarrierPolicy|select *g
$infobarrierpol|export-csv .\Reports\SandCInformationBarrierPolicies.csv -NoTypeInformation
#Labels
Write-Host "Pulling information about Labels..." -ForegroundColor Magenta
$labels=Get-Label|select *
$labels|export-csv .\Reports\SandCLabels.csv -NoTypeInformation
#Label Policies
Write-Host "Pulling information about Label Policies..." -ForegroundColor Magenta
$labelpol=Get-LabelPolicy|select *
$labelpol|export-csv .\Reports\SandCLabelPolicies.csv -NoTypeInformation
#Organization Segments
Write-Host "Pulling information about Organization Segments..." -ForegroundColor Magenta
$orgseg=Get-OrganizationSegment|select *
$orgseg|export-csv .\Reports\SandCOrganizationSegments.csv -NoTypeInformation
#Protection Alerts
Write-Host "Pulling information about Protection Alerts..." -ForegroundColor Magenta
$protalerts=Get-ProtectionAlert|select *
$protalerts|export-csv .\Reports\SandCProtectionAlerts.csv -NoTypeInformation
#Supervisory Review Policies
Write-Host "Pulling information about Supervisory Review Policies..." -ForegroundColor Magenta
$supervisoryRevPol=Get-SupervisoryReviewPolicyV2|select *
$supervisoryRevPol|export-csv .\Reports\SandCSupervisoryReviewPoliciesV2.csv -NoTypeInformation
#Supervisory Review Rules
Write-Host "Pulling information about Supervisory Review Rules..." -ForegroundColor Magenta
$supervisoryRevRule=Get-SupervisoryReviewRule|select *
$supervisoryRevRule|export-csv .\Reports\SandCSupervisoryReviewRule.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - CONTENT SEARCH
#region
#Compliance Security Filter
Write-Host "Pulling information about Compliance Security Filters..." -ForegroundColor Magenta
$csf=(Get-ComplianceSecurityFilter|select *)
$csf|Export-Csv .\Reports\SandCComplianceSecurityFilter.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE -DATA LOSS PREVENTION
#region
#Compliance Policies
Write-Host "Pulling information about Compliance Policies..." -ForegroundColor Magenta
$dlpcp=(Get-DLPCompliancePolicy|select *)
$dlpcp|Export-Csv .\Reports\SandCDLPCompliancePolicies.csv -NoTypeInformation
#Compliance Rules
Write-Host "Pulling information about Compliance Rules..." -ForegroundColor Magenta
$dlpcr=(Get-DLPComplianceRule|select *)
$dlpcr|Export-Csv .\Reports\SandCDLPComplianceRules.csv -NoTypeInformation
#EDM Schemas
Write-Host "Pulling information about EDM Schemas..." -ForegroundColor Magenta
$dlpedmschemas=Get-DlpEdmSchema|select *
$dlpedmschemas|export-csv .\Reports\SandCEDMSchemas.csv -NoTypeInformation
#Keyword Dictionaries
Write-Host "Pulling information about Keyword Dictionaries..." -ForegroundColor Magenta
$dlpkeyworddicts=Get-DlpKeywordDictionary|select *
$dlpkeyworddicts|export-csv .\Reports\SandCDlpKeywordDictionaries.csv -NoTypeInformation
#Sensitive information types
Write-Host "Pulling information about Sensitive Information Types..." -ForegroundColor Magenta
$dlpsit=(Get-DLPSensitiveInformationType|select *)
$dlpsit|Export-Csv .\Reports\SandCDLPSensitiveInformationTypes.csv -NoTypeInformation
#Sensitive Information Type Rule Package
Write-Host "Pulling information about Sensitive Information Type Rule Packages..." -ForegroundColor Magenta
$dlpsitpackage=(Get-DLPSensitiveInformationTypeRulePackage|select *)
$dlpsitpackage|Export-Csv .\Reports\SandCDLPSensitiveInformationTypeRulePackages.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - EDISCOVERY
#region
#Case Hold Rules
Write-Host "Pulling information about Case Hold Rules..." -ForegroundColor Magenta
$chr=(Get-CaseHoldRule|select *)
$chr|Export-Csv .\Reports\SandCCaseHoldRules.csv -NoTypeInformation
#eDiscovery Case Admins
Write-Host "Pulling information about eDiscovery Case Admins..." -ForegroundColor Magenta
$ediscca=Get-eDiscoveryCaseAdmin
$ediscca|Export-Csv .\Reports\SandCeDiscoveryCaseAdmins.csv -NoTypeInformation
#endregion

#### POLICY AND COMPLIANCE - RETENTION
#region
#Compliance Retention Event Types
Write-Host "Pulling information about Compliance Retention Event Types..." -ForegroundColor Magenta
$compreteventtypes=Get-ComplianceRetentionEventType|select *
$compreteventtypes|export-csv .\Reports\SandCComplianceRetentionEventTypes.csv -NoTypeInformation
#Get-ComplianceTag
Write-Host "Pulling information about Compliance Tags..." -ForegroundColor Magenta
$comptag=Get-ComplianceTag|select *
$comptag|Export-Csv .\Reports\SandCComplianceTags.csv -NoTypeInformation
#Get-ComplianceTagStorage
Write-Host "Pulling information about Compliance Tag Storage..." -ForegroundColor Magenta
$comptagstor=Get-ComplianceTagStorage|select *
$comptagstor|Export-Csv .\Reports\SandCComplianceTagStorage.csv -NoTypeInformation
<#DEPRECATED #Hold Compliance Policies
Write-Host "Pulling information about Hold Compliance Policies..." -ForegroundColor Magenta
$holdcomppol=Get-HoldCompliancePolicy|select *
$holdcomppol|export-csv .\Reports\SandCHoldCompliancePolicies.csv -NoTypeInformation
#DEPRECATED #Hold Compliance Rules
Write-Host "Pulling information about Hold Compliance Rules..." -ForegroundColor Magenta
$holdcomprules=Get-HoldComplianceRule|select *
$holdcomprules|export-csv .\Reports\SandCHoldComplianceRules.csv -NoTypeInformation#>
#Retention Compliance Policies
Write-Host "Pulling information about Retention Compliance Policies..." -ForegroundColor Magenta
$rcp=(Get-RetentionCompliancePolicy|select *)
$rcp|Export-Csv .\Reports\SandCRetentionCompliancePolicy.csv -NoTypeInformation
#Retention Compliance Rules
Write-Host "Pulling information about Retention Compliance Rules..." -ForegroundColor Magenta
$rcr=(Get-RetentionComplianceRule|select *)
$rcr|Export-Csv .\Reports\SandCRetentionComplianceRule.csv -NoTypeInformation
#endregion

#### ROLE BASED ACCESS CONTROL
#region
#Management Roles
Write-Host "Pulling information about Management Roles..." -ForegroundColor Magenta
$mr=(Get-ManagementRole|select *)
$mr|Export-Csv .\Reports\SandCManagementRole.csv -NoTypeInformation
#Role Groups
Write-Host "Pulling information about Role Groups..." -ForegroundColor Magenta
$rg=(Get-RoleGroup|select *)
$rg|Export-csv .\Reports\SandCRoleGroups.csv -NoTypeInformation
#Role Group Members
Write-Host "Pulling information about Role Group Members..." -ForegroundColor Magenta
$rgandmember=@()
foreach($rolegroup in $rg.name){
    $rgm=Get-RoleGroupMember -Identity $rolegroup    
    foreach($member in $rgm){
        $rgmentry = [pscustomobject]@{roleGroup='';Name='';RecipientType=''}
        $rgmentry.roleGroup = $rolegroup
        $rgmentry.Name = $member.Name
        $rgmentry.RecipientType = $member.RecipientType
        $rgandmember+=$rgmentry
    }
}
$rgandmember|Export-Csv .\Reports\SandCRoleGroupMembers.csv -NoTypeInformation
#endregion

Get-pssession|Remove-PSSession
#endregion

#----------------------------------------------------------
#Skype for Business 
#----------------------------------------------------------
#region
Import-Module LyncOnlineConnector
$SkypeForBusinessSession = New-CsOnlineSession -Credential $msocred
Import-PSSession $SkypeForBusinessSession

#AUDIO CONFERENCING PROVIDERS
#region
Write-Host "Pulling information about Skype Audio Conferencing Providers..." -ForegroundColor Magenta
$csacp=Get-CSAudioConferencingProvider|select *
$csacp|Export-Csv .\Reports\SFBAudioConferencingProviders.csv -NoTypeInformation
#endregion

#### AUTOATTENDANT
#region
Write-Host "Pulling information about Skype Auto Attendants..." -ForegroundColor Magenta
$csautoattendant=Get-CsAutoAttendant|select *
$csautoattendant|Export-Csv .\Reports\SFBAutoAttendants.csv -NoTypeInformation
Write-Host "Pulling information about Skype Auto Attendant Holidays..." -ForegroundColor Magenta
$csAutoAttendantHolidays=@()
foreach($csautoat in $csautoattendant){
    $csAutoAttendantHolidays+=Get-CsAutoAttendantHolidays -identity $csautoat|select *
}
$csAutoAttendantHolidays|Export-Csv .\Reports\SFBAutoAttendantHolidays.csv -NoTypeInformation
Write-Host "Pulling information about Skype Auto Attendant Holidays ..." -ForegroundColor Magenta
$csAutoAttendantStatus=@()
foreach($csautoat in $csautoattendant){
    $csAutoAttendantStatus+=Get-CsAutoAttendantStatus -identity $csautoat|select *    
}
$csAutoAttendantStatus|Export-Csv .\Reports\SFB.csv -NoTypeInformation
Write-Host "Pulling information about Skype Auto Attendant Supported Languages..." -ForegroundColor Magenta
$csAutoAttendantSupportedLanguages=@()
foreach($csautoat in $csautoattendant){
    $csAutoAttendantSupportedLanguages+=Get-CsAutoAttendantSupportedLanguage -identity $csautoat|select *
}
$csAutoAttendantSupportedLanguages|Export-Csv .\Reports\SFBAutoAttendantSupportedLanguages.csv -NoTypeInformation
Write-Host "Pulling information about Skype Auto Attendant Supported Timezones..." -ForegroundColor Magenta
$csAutoAttendantSupportedTimezones=@()
foreach($csautoat in $csautoattendant){
    $csAutoAttendantSupportedTimezone+=Get-CsAutoAttendantSupportedTimezone -identity $csautoat|select *
}
$csAutoAttendantSupportedTimezones|Export-Csv .\Reports\SFBAutoAttendantSupportedTimezones.csv -NoTypeInformation
Write-Host "Pulling information about Skype Auto Attendant Tenant Information..." -ForegroundColor Magenta
$csAutoAttendantTenantInformation=@()
foreach($csautoat in $csautoattendant){
    $csAutoAttendantTenantInformation+=Get-CsAutoAttendantTenantInformation -identity $csautoat|select *
}
$csAutoAttendantTenantInformation|Export-Csv .\Reports\SFBAutoAttendantTenantInformation.csv -NoTypeInformation
#endregion

#### BROADCAST
#region
Write-Host "Pulling information about Skype Broadcast Meeting Configuration..." -ForegroundColor Magenta
$csbcmc=Get-CsBroadcastMeetingConfiguration|select *
$csbcmc|export-csv .\Reports\SFBBroadcastMeetingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Broadcast Meeting Policy..." -ForegroundColor Magenta
$csbcmp=Get-CsBroadcastMeetingPolicy|select *
$csbcmp|export-csv .\Reports\SFBBroadcastMeetingPolicy.csv -NoTypeInformation
#endregion

#### CALLING LINE
#region
Write-Host "Pulling information about Skype Calling Line Identities..." -ForegroundColor Magenta
$cscli=Get-CsCallingLineIdentity|select *
$cscli|export-csv .\Reports\SFBCallingLineIdentities.csv -NoTypeInformation
#endregion

#### HUNT GROUP
#region
Write-Host "Pulling information about Skype Hunt Groups..." -ForegroundColor Magenta
$cshg=Get-CsHuntGroup|select *
$cshg|export-csv .\Reports\SFBHuntGroups.csv -NoTypeInformation
#endregion

#### CLIENT POLICY
#region
Write-Host "Pulling information about Skype Client Policies..." -ForegroundColor Magenta
$cscp=Get-CSClientPolicy
$cscp|Export-Csv .\Reports\SFBClientPolicies.csv -NoTypeInformation
#endregion

#### CLOUD MEETING
#region
<#DEPRECATED
Write-Host "Pulling information about Skype Cloud Meeting Configurations..." -ForegroundColor Magenta
$csmc=Get-CSCloudMeetingConfiguration
$csmc|Export-Csv .\Reports\SFBCloudMeetingConfiguration.csv -NoTypeInformation.
#>
Write-Host "Pulling information about Skype Cloud Meeting Policiess..." -ForegroundColor Magenta
$cscmp=Get-CSCloudMeetingPolicy|select *
$cscmp|Export-Csv .\Reports\SFBCloudMeetingPolicies.csv -NoTypeInformation.
#endregion

#### CONFERENCING POLICY
#region
Write-Host "Pulling information about Skype Conferencing Policies..." -ForegroundColor Magenta
$csconfp=Get-CSConferencingPolicy
$csconfp|Export-Csv .\Reports\SFBConferencingPolicies.csv -NoTypeInformation
#endregion

#### EXTERNAL ACCESS POLICY
#region
Write-Host "Pulling information about Skype External Access Policies..." -ForegroundColor Magenta
$cseap=Get-CSExternalAccessPolicy
$cseap|Export-Csv .\Reports\SFBExternalAccessPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Skype External User Communication Policies..." -ForegroundColor Magenta
$csextusercommpol=Get-CsExternalUserCommunicationPolicy|select *
$csextusercommpol|Export-Csv .\Reports\SFBExternalUserCommunicationPolicies.csv -NoTypeInformation
#endregion

#### GRAPH POLICIES
#region
Write-Host "Pulling information about Skype Graph Policies..." -ForegroundColor Magenta
$csGraphPolicy=Get-CSGraphPolicy|select *
$csGraphPolicy|Export-Csv .\Reports\SFBGraphPolicies.csv -NoTypeInformation
#endregion

#### HOSTED VOICEMAIL POLICIES
#region
Write-Host "Pulling information about Skype Hosted Voicemail Policies..." -ForegroundColor Magenta
$cshvp=(Get-CSHostedVoicemailPolicy|select *)
$cshvp|Export-Csv .\Reports\SFBOnlineVoicemailPolicy.csv -NoTypeInformation
#endregion

#### HOSTING PROVIDERS
#region
Write-Host "Pulling information about Skype Hosting Providers..." -ForegroundColor Magenta
$cshostprov=Get-CsHostingProvider|select *
$cshostprov|Export-Csv .\Reports\SFBHostingProviders.csv -NoTypeInformation
#endregion

#### HUNT GROUPS
#region
Write-Host "Pulling information about Skype Hunt Groups..." -ForegroundColor Magenta
$cshg=Get-CsHuntGroup|select *
$cshg|export-csv .\Reports\SFBHuntGroups.csv -NoTypeInformation
Write-Host "Pulling information about Skype Hunt Group Tenant Information..." -ForegroundColor Magenta
$csHuntGroupTenantInfo=Get-CsHuntGroupTenantInformation|select *
$csHuntGroupTenantInfo|Export-Csv .\Reports\SFBHuntGroupTenantInformation.csv -NoTypeInformation
#endregion

#### HYBRID PSTN SITE AND USER
#region
Write-Host "Pulling information about Skype Hybrid PSTN Appliances..." -ForegroundColor Magenta
$csHybridPSTNAppliances=Get-CsHybridPSTNAppliance|select *
$csHybridPSTNAppliances|Export-Csv .\Reports\SFBHybridPSTNAppliances.csv -NoTypeInformation
Write-Host "Pulling information about Skype Hybrid PSTN Sites..." -ForegroundColor Magenta
$cshpstns=Get-CsHybridPSTNSite|select *
$cshpstns|Export-Csv .\Reports\SFBHybridPSTNSites.csv -NoTypeInformation
#endregion

#### IM FILTER CONFIGURATION
#region
Write-Host "Pulling information about Skype IM Filter Configuration..." -ForegroundColor Magenta
$csimfcon=(Get-CSImFilterConfiguration|select *)
$csimfcon|Export-Csv .\Reports\SFBIMFilterConfiguration.csv -NoTypeInformation
#endregion

#### INBOUND BLOCKED NUMBER PATTERN
#region
Write-Host "Pulling information about Skype Inbound Blocked Number Patterns..." -ForegroundColor Magenta
$csinboundbnp=Get-CsInboundBlockedNumberPattern|select *
$csinboundbnp|Export-Csv .\Reports\SFBInboundBlockedNumberPatterns.csv -NoTypeInformation
#endregion

#### INTERNET PROTOCOL PHONES
#region
Write-Host "Pulling information about Skype IP Phone Policy..." -ForegroundColor Magenta
$csippp=Get-CsIPPhonePolicy|select *
$csippp|Export-Csv .\Reports\SFBIPPhonePolicy.csv -NoTypeInformation
#endregion

#### MEETING CONFIGURATION
#region
Write-Host "Pulling information about Skype Meeting Configurations..." -ForegroundColor Magenta
$csmeetingconfig=Get-CSMeetingConfiguration|select *
$csmeetingconfig|Export-Csv .\Reports\SFBMeetingConfigurations.csv -NoTypeInformation
#endregion

#### MEETING ROOMS
#region
Write-Host "Pulling information about Skype Meeting Rooms..." -ForegroundColor Magenta
$csmr=(Get-CSMeetingRoom|select *)
$csmr|Export-Csv .\Reports\SFBMeetingRooms.csv -NoTypeInformation
#endregion

#### MOBILE POLICY
#region
Write-Host "Pulling information about Skype Mobility Policy..." -ForegroundColor Magenta
$csmp=Get-CsMobilityPolicy|select *
$csmp|Export-Csv .\Reports\SFBMobilityPolicy.csv -NoTypeInformation
#endregion

#### NETWORK CONFIGURATION
#region
Write-Host "Pulling information about Skype Network Configuration..." -ForegroundColor Magenta
$csNetConfig=Get-CsNetworkConfiguration|select *
$csNetConfig|Export-Csv .\Reports\SFBNetworkConfiguration.csv -NoTypeInformation
#endregion

#### OAUTH CONFIGURATION
#region
Write-Host "Pulling information about Skype OAuth Configuration..." -ForegroundColor Magenta
$csOAuthConfig=Get-CsOAuthConfiguration|select *
$csOAuthConfig|Export-Csv .\Reports\SFBOAuthConfiguration.csv -NoTypeInformation
#endregion

#### ONLINE APPLICATIONS
#region 
Write-Host "Pulling information about Skype Application Instances..." -ForegroundColor Magenta
$csAppInstances=Get-CsOnlineApplicationInstance|select *
$csAppInstances|Export-Csv .\Reports\SFBApplicationInstances.csv -NoTypeInformation
Write-Host "Pulling information about Skype Application Instance Association..." -ForegroundColor Magenta
$csAppInstanceAssociations=@()
foreach($csappinst in $csAppInstances){
    $csAppInstanceAssociations+=Get-CsOnlineApplicationInstanceAssociation -identity $csappinst.ApplicationID|select *
}
$csAppInstanceAssociations|Export-Csv .\Reports\SFBApplicationInstanceAssociations.csv -NoTypeInformation
#endregion

#### DIAL IN CONFERENCING
#region
Write-Host "Pulling information about Skype DialIn Conferencing Bridges..." -ForegroundColor Magenta
$csodicb=Get-CsOnlineDialInConferencingBridge|select *
$csodicb|Export-Csv .\Reports\SFBOnlineDialInConferencingBridges.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Languages Supported..." -ForegroundColor Magenta
$csodils=Get-CsOnlineDialInConferencingLanguagesSupported|select *
$csodils|Export-Csv .\Reports\SFBOnlineDialInLanguagesSupported.csv -NoTypeInformation
Write-Host "Pulling information about Skype Dialin Conferencing Policies..." -ForegroundColor Magenta
$csDialinConfPol=Get-CsOnlineDialinConferencingPolicy|select *
$csDialinConfPol|Export-Csv .\Reports\SFBDialinConferencingPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Service Number..." -ForegroundColor Magenta
$csodicsn=Get-CsOnlineDialInConferencingServiceNumber|select *
$csodicsn|Export-Csv .\Reports\SFBOnlineDialInConferencingServiceNumber.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Tenant Configuration ..." -ForegroundColor Magenta
$csodictc=Get-CsOnlineDialInConferencingTenantConfiguration|select *
$csodictc|Export-Csv .\Reports\SFBOnlineDialInConferencingTenantConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype DialIn Conferencing Tenant Settings..." -ForegroundColor Magenta
$csodicts=Get-CsOnlineDialInConferencingTenantSettings|select *
$csodicts|Export-Csv .\Reports\SFBOnlineDialInConferencingTenantSettings.csv -NoTypeInformation
#endregion

#### DIAL OUT POLICY
#region
Write-Host "Pulling information about Skype Dial Out Policies ..." -ForegroundColor Magenta
$csdialoutpol=Get-CsOnlineDialOutPolicy|select *
$csdialoutpol|Export-Csv .\Reports\SFBDialOutPolicies.csv -NoTypeInformation
#endregion

#### DIRECTORY TENANT
#region
Write-Host "Pulling information about Skype Directory Tenant..." -ForegroundColor Magenta
$csodt=Get-CsOnlineDirectoryTenant|select *
$csodt|Export-Csv .\Reports\SFBOnlineDirectoryTenant.csv -NoTypeInformation
Write-Host "Pulling information about Skype Directory Tenant Number Cities..." -ForegroundColor Magenta
$csodtnc=Get-CsOnlineDirectoryTenantNumberCities|select *
$csodtnc|Export-Csv .\Reports\SFBOnlineDirectoryTenantNumberCities.csv -NoTypeInformation
#endregion

#### E911 AND LOCATION INFORMATION SERVICE (LIS)
#region
Write-Host "Pulling information about Skype LIS Civic Address..." -ForegroundColor Magenta
$csolisca=Get-CsOnlineLisCivicAddress
$csolisca|Export-Csv .\Reports\SFBOnlineLISLocation.csv -NoTypeInformation
Write-Host "Pulling information about Skype LIS Location..." -ForegroundColor Magenta
$csolislocation=Get-CsOnlineLisLocation
$csolislocation|Export-Csv .\Reports\SFBOnlineLISLocation.csv -NoTypeInformation
Write-Host "Pulling information about Skype Lis Ports..." -ForegroundColor Magenta
$cslisport=Get-CsOnlineLisPort
$cslisport|Export-Csv .\Reports\SFBLisPorts.csv -NoTypeInformation
Write-Host "Pulling information about Skype LIS Subnets..." -ForegroundColor Magenta
$csLisSubnet=Get-CsOnlineLisSubnet
$csLisSubnet|Export-Csv .\Reports\SFBLisSubnets.csv -NoTypeInformation
Write-Host "Pulling information about Skype LIS Switches..." -ForegroundColor Magenta
$csLisSwitch=Get-CsOnlineLisSwitch
$csLisSwitch|Export-Csv .\Reports\SFBLisSwitches.csv -NoTypeInformation 
Write-Host "Pulling information about Skype LIS Wireless Access Points..." -ForegroundColor Magenta
$csLisWAP=Get-CsOnlineLisWirelessAccessPoint
$csLisWAP|Export-Csv .\Reports\SFBLisWirelessAccessPoint.csv -NoTypeInformation
#endregion

#### PUBLIC SWITCHED TELEPHONE NETWORK
#region
Write-Host "Pulling information about Skype PSTN Gateways..." -ForegroundColor Magenta
$csPSTNGateways=Get-CsOnlinePSTNGateway|select *
$csPSTNGateways|Export-Csv .\Reports\SFBPSTNGateways.csv -NoTypeInformation
#endregion

#### SCHEDULES
#region
Write-Host "Pulling information about Skype Schedule..." -ForegroundColor Magenta
$csSchedule=Get-CsOnlineSchedule|select *
$csSchedule|Export-Csv .\Reports\SFBSchedule.csv -NoTypeInformation
#endregion

#### SIP DOMAINS
#region
Write-Host "Pulling information about Skype SIP Domains ..." -ForegroundColor Magenta
$sipdomainnames=(Get-CsOnlineSipDomain).name
$sipdomainstatus=(Get-CsOnlineSipDomain).status
$cssipdomains=@()
$cssipdomaincount=0
while($cssipdomaincount -lt $sipdomainnames.count){
    $cssipdomains+=[pscustomobject]@{Name="$($sipdomainnames[$cssipdomaincount])";Status="$($sipdomainstatus[$cssipdomaincount])"}
    $cssipdomaincount++
}
$cssipdomains|Export-Csv .\Reports\SFBSIPDomains.csv -NoTypeInformation
#endregion

#### ONLINE VOICEMAIL POLICIES
#region
Write-Host "Pulling information about Skype Online Voicemail Policies..." -ForegroundColor Magenta
$csovp=(Get-CSOnlineVoicemailPolicy|select *)
$csovp|Export-Csv .\Reports\SFBOnlineVoicemailPolicy.csv -NoTypeInformation
#endregion

#### VOICE ROUTES
#region
Write-Host "Pulling information about Skype Voice Routes..." -ForegroundColor Magenta
$csVoiceRoutes=Get-CsOnlineVoiceRoute|select *
$csVoiceRoutes|Export-Csv .\Reports\SFBVoiceRoutes.csv -NoTypeInformation
Write-Host "Pulling information about Skype Voice Routing Policies..." -ForegroundColor Magenta
$csVoiceRoutingPol=Get-CsOnlineVoiceRoutingPolicy|select *
$csVoiceRoutingPol|Export-Csv .\Reports\SFBVoiceRoutingPolicies.csv -NoTypeInformation
#endregion

#### ORGANIZATIONAL AUTO ATTENDANTS
#region
Write-Host "Pulling information about Skype Organizational AutoAttendants..." -ForegroundColor Magenta
$csorgautoattendants=Get-CsOrganizationalAutoAttendant|select *
$csorgautoattendants|export-csv .\Reports\SFBOrganizationalAutoAttendants.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Statuses..." -ForegroundColor Magenta
$csorgautoattendantstatusArray=@()
$csorgautoattendantURIs=$csorgautoattendants.primaryuri.originalstring
foreach($csuri in $csorgautoattendantURIs){
    $csorgaastatustemp=Get-CsOrganizationalAutoAttendantStatus -primaryURI $csuri|select *
    $csorgautoattendantstatusArray+=$csorgaastatustemp
}
$csorgautoattendantstatusArray|export-csv .\Reports\SFBOrganizationalAutoAttendantStatuses.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Supported Languages..." -ForegroundColor Magenta
$csoaasl=(Get-CsOrganizationalAutoAttendantSupportedLanguage|select *)
$csoaasl|Export-Csv .\Reports\SFBOrganizationalAutoAttendantSupportedLanguages.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational AutoAttendant Supported Time Zones..." -ForegroundColor Magenta
$csoaastz=(Get-CsOrganizationalAutoAttendantSupportedTimeZone|select *)
$csoaastz|Export-Csv .\Reports\SFBOrganizationalAutoAttendantSupportedTimeZones.csv -NoTypeInformation
Write-Host "Pulling information about Skype Organizational Auto Attendant Tenant Information..." -ForegroundColor Magenta
$csOrgAutoAttendantTenantInformation=@()
foreach($csautoat in $csautoattendant){
    $csOrgAutoAttendantTenantInformation+=Get-CsOrganizationalAutoAttendantTenantInformation -identity $csautoat|select *
}
$csOrgAutoAttendantTenantInformation|Export-Csv .\Reports\SFBOrganizationalAutoAttendantTenantInformation.csv -NoTypeInformation
#endregion

#### PRESENCE POLICY
#region
Write-Host "Pulling information about Skype Presence Policies..." -ForegroundColor Magenta
$cspp=(Get-CSPresencePolicy|select *)
$cspp|Export-Csv .\Reports\SFBPresencePolicy.csv -NoTypeInformation
#endregion

#### PRIVACY CONFIGURATION
#region
Write-Host "Pulling information about Skype Privacy Configuration..." -ForegroundColor Magenta
$cspc=(Get-CSPrivacyConfiguration|select *)
$cspc|Export-Csv .\Reports\SFBPrivacyConfiguration.csv -NoTypeInformation
#endregion

#### PUSH NOTIFICATION CONFIGURATION
#region
Write-Host "Pulling information about Skype Push Notification Configuration..." -ForegroundColor Magenta
$cspnc=Get-CSPushNotificationConfiguration
$cspnc|Export-Csv .\Reports\SFBPushNotificationConfiguration.csv -NoTypeInformation
#endregion

#### TENANT
#region
Write-Host "Pulling information about Skype Tenant..." -ForegroundColor Magenta
$cst=Get-CSTenant
$cst|Export-Csv .\Reports\SFBTenant.csv -NoTypeInformation
Write-Host "Pulling information about Skype Blocked Number Exception Patterns..." -ForegroundColor Magenta
$csTBNEPattern=Get-CSTenantBlockedNumberExceptionPattern|select *
$csTBNEPattern|Export-Csv .\Reports\SFBBlockedNumberExceptionPatterns.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Dial Plans..." -ForegroundColor Magenta
$cstenantDP=(Get-CsTenantDialPlan|select *)
$cstenantDP|Export-Csv .\Reports\SFBTenantDialPlans.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Federation Configuration..." -ForegroundColor Magenta
$tfc=(Get-CSTenantFederationConfiguration|select *)
$tfc|Export-Csv .\Reports\SFBTenantFederationConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Hybrid Configuration..." -ForegroundColor Magenta
$cstenanthybridconfig=(Get-CsTenantHybridConfiguration|select *)
$cstenanthybridconfig|Export-Csv .\Reports\SFBTenantHybridConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Licensing Configuration..." -ForegroundColor Magenta
$cstlc=Get-CSTenantLicensingConfiguration
$cstlc|Export-Csv .\Reports\SFBTenantLicensingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Migration Configuration..." -ForegroundColor Magenta
$csTenantMigConfig=Get-CsTenantMigrationConfiguration|select *
$csTenantMigConfig|Export-Csv .\Reports\SFBTenantMigrationConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Network Regions..." -ForegroundColor Magenta
$csTenantNetworkRegion=Get-CsTenantNetworkRegion|select *
$csTenantNetworkRegion|Export-Csv .\Reports\SFBTenantNetworkRegions.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Network Sites..." -ForegroundColor Magenta
$csTenantNetworkSite=Get-CsTenantNetworkSite|select *
$csTenantNetworkSite|Export-Csv .\Reports\SFBTenantNetworkSites.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Network Subnets..." -ForegroundColor Magenta
$csTenantNetworkSubnet=Get-CsTenantNetworkSubnet|select *
$csTenantNetworkSubnet|Export-Csv .\Reports\SFBTenantNetworkSubnets.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Public Providers..." -ForegroundColor Magenta
$tpp=(Get-CSTenantPublicProvider|select *)
$tpp|Export-Csv .\Reports\SFBTenantPublicProviders.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Trusted IP Addresses..." -ForegroundColor Magenta
$csTenTrustedIP=Get-CsTenantTrustedIPAddress|select *
$csTenTrustedIP|Export-Csv .\Reports\SFBTenantTrustedIPAddresses.csv -NoTypeInformation
Write-Host "Pulling information about Skype Tenant Update Time Windows..." -ForegroundColor Magenta
$csTenUpdateTime=Get-CsTenantUpdateTimeWindow|select *
$csTenUpdateTime|Export-Csv .\Reports\SFBTenantUpdateTimeWindows.csv -NoTypeInformation
#endregion

#### UC PHONE CONFIGURATION
#region
Write-Host "Pulling information about Skype UC Phone Configuration..." -ForegroundColor Magenta
$csUCPhoneConfig=Get-CsUCPhoneConfiguration|select *
$csUCPhoneConfig|Export-Csv .\Reports\SFBUCPhoneConfiguration.csv -NoTypeInformation
#endregion

#### VOICE NORMALIZATION RULE
#region
Write-Host "Pulling information about Skype Voice Normalization Rules..." -ForegroundColor Magenta
$csVNR=Get-CsVoiceNormalizationRule|select *
$csVNR|Export-Csv .\Reports\SFBVoiceNormalizationRules.csv -NoTypeInformation
#endregion

#### VOICE ROUTING POLICY
#region
Write-Host "Pulling information about Skype Voice Routing Policies..." -ForegroundColor Magenta
$csvrp=(Get-CsVoiceRoutingPolicy|select *)
$csvrp|Export-Csv .\Reports\SFBVoiceRoutingPolicies.csv -NoTypeInformation
#endregion

Get-PSSession|Remove-PSSession

#endregion

#----------------------------------------------------------
#Microsoft Teams 
#----------------------------------------------------------
#region
Import-Module LyncOnlineConnector
$SkypeForBusinessSession = New-CsOnlineSession -Credential $msocred
Import-PSSession $SkypeForBusinessSession

Connect-MicrosoftTeams -Credential $msoCred

Write-Host "Pulling information about Teams Group Policy Assignments..." -ForegroundColor Magenta
$teamsGroupPolicyAssignments=Get-CsGroupPolicyAssignment|select *
if($teamsGroupPolicyAssignments){
    $teamsGroupPolicyAssignments|Export-Csv .\Reports\TeamsGroupPolicyAssignments.csv -NoTypeInformation
}
else{
    @()|Export-Csv .\Reports\TeamsGroupPolicyAssignments.csv -NoTypeInformation
}

Write-Host "Pulling information about Teams Policy Packages..." -ForegroundColor Magenta
$teamsPolicyPackages=Get-CsPolicyPackage|select *
$teamsPolicyPackages|Export-Csv .\Reports\TeamsPolicyPackages.csv -NoTypeInformation

Write-Host "Pulling information about Teams Apps..." -ForegroundColor Magenta
$teamsApps=Get-TeamsApp|select *
$teamsApps|Export-Csv .\Reports\TeamsApps.csv -NoTypeInformation
Write-Host "Pulling information about Teams App Permission Policies..." -ForegroundColor Magenta
$teamsAppPermissionPolicy=Get-CsTeamsAppPermissionPolicy|select *
$teamsAppPermissionPolicy|Export-Csv .\Reports\TeamsAppPermissionPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Teams App Setup Policies ..." -ForegroundColor Magenta
$teamsAppSetupPolicies=Get-CsTeamsAppSetupPolicy|select *
$teamsAppSetupPolicies|Export-Csv .\Reports\TeamsAppSetupPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Calling Policies..." -ForegroundColor Magenta
$teamsCallingPolicies=Get-CsTeamsCallingPolicy|select *
$teamsCallingPolicies|Export-Csv .\Reports\TeamsCallingPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Teams Call Park Policies..." -ForegroundColor Magenta
$teamsCallParkPolicies=Get-CsTeamsCallParkPolicy|select *
$teamsCallParkPolicies|Export-Csv .\Reports\TeamsCallParkPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Channels Policies..." -ForegroundColor Magenta
$teamsChannelsPolicies=Get-CsTeamsChannelsPolicy|select *
$teamsChannelsPolicies|Export-Csv .\Reports\TeamsChannelsPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Client Configuration..." -ForegroundColor Magenta
$teamsClientConfig=Get-CsTeamsClientConfiguration|select *
$teamsClientConfig|Export-Csv .\Reports\TeamsClientConfiguration.csv -NoTypeInformation

Write-Host "Pulling information about Teams Education Assignments App Policy..." -ForegroundColor Magenta
$teamsEdAssAppPol=Get-CsTeamsEducationAssignmentsAppPolicy|select *
$teamsEdAssAppPol|Export-Csv .\Reports\TeamsEducationAssignmentsAppPolicy.csv -NoTypeInformation

Write-Host "Pulling information about Teams Emergency Calling Policies..." -ForegroundColor Magenta
$teamsEmCallPol=Get-CsTeamsEmergencyCallingPolicy|select *
$teamsEmCallPol|Export-Csv .\Reports\TeamsEmergencyCallingPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Teams Emergency Call Routing Policies..." -ForegroundColor Magenta
$teamsEmCallRoutePol=Get-CsTeamsEmergencyCallRoutingPolicy|select *
$teamsEmCallRoutePol|Export-Csv .\Reports\TeamsEmergencyCallRoutingPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Guest Calling Configuration..." -ForegroundColor Magenta
$teamsGuestCallConfig=Get-CsTeamsGuestCallingConfiguration|select *
$teamsGuestCallConfig|Export-Csv .\Reports\TeamsGuestCallingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Teams Guest Meeting Configuration..." -ForegroundColor Magenta
$teamsGuestMeetingConfig=Get-CsTeamsGuestMeetingConfiguration|select *
$teamsGuestMeetingConfig|Export-Csv .\Reports\TeamsGuestMeetingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Teams Guest Messaging Configuration..." -ForegroundColor Magenta
$teamsGuestMessagingConfig=Get-CsTeamsGuestMessagingConfiguration|select *
$teamsGuestMessagingConfig|Export-Csv .\Reports\TeamsGuestMessagingConfiguration.csv -NoTypeInformation

Write-Host "Pulling information about Teams Meeting Broadcast Configuration..." -ForegroundColor Magenta
$teamsMeetBroadConfig=Get-CsTeamsMeetingBroadcastConfiguration|select *
$teamsMeetBroadConfig|Export-Csv .\Reports\TeamsMeetingBroadcastConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Teams Meeting Broadcast Policies..." -ForegroundColor Magenta
$teamsMeetBroadPol=Get-CsTeamsMeetingBroadcastPolicy|select *
$teamsMeetBroadPol|Export-Csv .\Reports\TeamsMeetingBroadcastPolicies.csv -NoTypeInformation
Write-Host "Pulling information about Teams Meeting Configuration..." -ForegroundColor Magenta
$teamsMeetConfig=Get-CsTeamsMeetingConfiguration|select *
$teamsMeetConfig|Export-Csv .\Reports\TeamsMeetingConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Teams Meeting Policies..." -ForegroundColor Magenta
$teamsMeetPol=Get-CsTeamsMeetingPolicy|select *
$teamsMeetPol|Export-Csv .\Reports\TeamsMeetingPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Messaging Policies..." -ForegroundColor Magenta
$teamsMessPol=Get-CsTeamsMessagingPolicy|select *
$teamsMessPol|Export-Csv .\Reports\TeamsMessagingPolicies.csv -NoTypeInformation

Write-Host "Pulling information about Teams Mobility Policies..." -ForegroundColor Magenta
$teamsMobPol=Get-CsTeamsMobilityPolicy|select *
if($teamsMobPol){
    $teamsMobPol|Export-Csv .\Reports\TeamsMobilityPolicies.csv -NoTypeInformation
}
else{
    @()|Export-Csv .\Reports\TeamsMobilityPolicies.csv -NoTypeInformation
}

Write-Host "Pulling information about Teams Translation Rules..." -ForegroundColor Magenta
$teamsTransRules=Get-CsTeamsTranslationRule|select *
$teamsTransRules|Export-Csv .\Reports\TeamsTranslationRules.csv -NoTypeInformation

Write-Host "Pulling information about Teams Upgrade Configuration..." -ForegroundColor Magenta
$teamsUpConfig=Get-CsTeamsUpgradeConfiguration|select *
$teamsUpConfig|Export-Csv .\Reports\TeamsUpgradeConfiguration.csv -NoTypeInformation
Write-Host "Pulling information about Teams Upgrade Policies..." -ForegroundColor Magenta
$teamsUpPol=Get-CsTeamsUpgradePolicy|select *
$teamsUpPol|Export-Csv .\Reports\TeamsUpgradePolicies.csv -NoTypeInformation
Write-Host "Pulling information about Teams Upgrade Status..." -ForegroundColor Magenta
$teamsUpStatus=Get-CsTeamsUpgradeStatus|select *
$teamsUpStatus|Export-Csv .\Reports\TeamsUpgradeStatus.csv -NoTypeInformation

Write-Host "Pulling information about Teams Video Interop Service Policy..." -ForegroundColor Magenta
$teamsVidInteropSP=Get-CsTeamsVideoInteropServicePolicy|select *
$teamsVidInteropSP|Export-Csv .\Reports\TeamsVideoInteropServicePolicy.csv -NoTypeInformation

Get-PSSession|Remove-PSSession
Disconnect-MicrosoftTeams
#endregion 

Stop-Transcript