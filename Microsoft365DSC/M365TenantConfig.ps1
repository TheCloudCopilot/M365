# Generated with Microsoft365DSC version 1.23.621.1
# For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC
param (
    [parameter()]
    [System.Management.Automation.PSCredential]
    $Credential
)

Configuration M365TenantConfig
{
    param (
        [parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    if ($null -eq $Credential)
    {
        <# Credentials #>
        $Credscredential = Get-Credential -Message "Credentials"

    }
    else
    {
        $CredsCredential = $Credential
    }

    $OrganizationName = $CredsCredential.UserName.Split('@')[1]

    Import-DscResource -ModuleName 'Microsoft365DSC' -ModuleVersion '1.23.621.1'

    Node localhost
    {
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Exchange Online Requires Compliant Device"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            BuiltInControls                          = @("compliantDevice");
            ClientAppTypes                           = @("browser","mobileAppsAndDesktopClients");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            Credential                               = $Credscredential;
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Exchange Online Requires Compliant Device";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            GrantControlOperator                     = "OR";
            Id                                       = "e3cb0c63-141a-4d71-abea-1630c158bc40";
            IncludeApplications                      = @("00000002-0000-0ff1-ce00-000000000000");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @("sg-Sales and Marketing");
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @();
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "disabled";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-Office 365 App Control"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            BuiltInControls                          = @();
            ClientAppTypes                           = @("browser","mobileAppsAndDesktopClients");
            CloudAppSecurityIsEnabled                = $True;
            CloudAppSecurityType                     = "mcasConfigured";
            Credential                               = $Credscredential;
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "Office 365 App Control";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @();
            Id                                       = "d94e6a2e-ea7b-4de2-b1b2-ec27130eaf6f";
            IncludeApplications                      = @("00000002-0000-0ff1-ce00-000000000000","00000003-0000-0ff1-ce00-000000000000");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @();
            IncludeUserActions                       = @();
            IncludeUsers                             = @("All");
            PersistentBrowserIsEnabled               = $False;
            PersistentBrowserMode                    = "";
            SignInFrequencyIsEnabled                 = $False;
            SignInFrequencyType                      = "";
            SignInRiskLevels                         = @();
            State                                    = "disabled";
            UserRiskLevels                           = @();
        }
        AADConditionalAccessPolicy "AADConditionalAccessPolicy-CA01 - Enforce MFA for all Administrator Roles"
        {
            ApplicationEnforcedRestrictionsIsEnabled = $False;
            BuiltInControls                          = @("mfa");
            ClientAppTypes                           = @("all");
            CloudAppSecurityIsEnabled                = $False;
            CloudAppSecurityType                     = "";
            Credential                               = $Credscredential;
            CustomAuthenticationFactors              = @();
            DeviceFilterRule                         = "";
            DisplayName                              = "CA01 - Enforce MFA for all Administrator Roles";
            Ensure                                   = "Present";
            ExcludeApplications                      = @();
            ExcludeExternalTenantsMembers            = @();
            ExcludeExternalTenantsMembershipKind     = "";
            ExcludeGroups                            = @();
            ExcludeLocations                         = @();
            ExcludePlatforms                         = @();
            ExcludeRoles                             = @();
            ExcludeUsers                             = @("AdeleV@$OrganizationName");
            GrantControlOperator                     = "OR";
            Id                                       = "7b5d226f-3d85-4e21-a818-d79a038fd229";
            IncludeApplications                      = @("All");
            IncludeExternalTenantsMembers            = @();
            IncludeExternalTenantsMembershipKind     = "";
            IncludeGroups                            = @();
            IncludeLocations                         = @();
            IncludePlatforms                         = @();
            IncludeRoles                             = @("Global Administrator");
            IncludeUserActions                       = @();
            IncludeUsers                             = @();
            PersistentBrowserIsEnabled               = $True;
            PersistentBrowserMode                    = "never";
            SignInFrequencyIsEnabled                 = $True;
            SignInFrequencyType                      = "hours";
            SignInFrequencyValue                     = 3;
            SignInRiskLevels                         = @();
            State                                    = "enabledForReportingButNotEnforced";
            UserRiskLevels                           = @();
        }
        AADGroup "AADGroup-Contoso Life"
        {
            Credential           = $Credscredential;
            Description          = "Contoso Life";
            DisplayName          = "Contoso Life";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "02f1f6e3-c92b-429d-9313-e008be5ec4f1";
            MailEnabled          = $True;
            MailNickname         = "contosolife";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-sg-Executive"
        {
            Credential           = $Credscredential;
            Description          = "All executives";
            DisplayName          = "sg-Executive";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "1012968e-33e1-446d-95cb-ba989f0180cb";
            MailEnabled          = $False;
            MailNickname         = "sgExecutive";
            MemberOf             = @();
            Members              = @("PattiF@$OrganizationName","GerhartM@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-sg-Legal"
        {
            Credential           = $Credscredential;
            Description          = "All legal executives";
            DisplayName          = "sg-Legal";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "16ac9885-fd16-4d22-be00-437962adce81";
            MailEnabled          = $False;
            MailNickname         = "sgLegal";
            MemberOf             = @();
            Members              = @("JoniS@$OrganizationName","IrvinS@$OrganizationName","GradyA@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-SCR-Tremonia"
        {
            Credential           = $Credscredential;
            Description          = "Check here for organization announcements and important info.";
            DisplayName          = "SCR-Tremonia";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "1fbd773b-f9d4-4925-a757-0c0f5c8c3273";
            MailEnabled          = $True;
            MailNickname         = "SCR-Tremonia";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","ms-serviceaccount@$OrganizationName","AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","CameronW@$OrganizationName","MiriamG@$OrganizationName","DeliaD@$OrganizationName","GerhartM@$OrganizationName","RaulR@$OrganizationName","BiancaP@$OrganizationName","MalloryC@$OrganizationName","AutomateB@$OrganizationName","BrianJ@$OrganizationName");
            Owners               = @("admin@$OrganizationName","ms-serviceaccount@$OrganizationName","AllanD@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LidiaH@$OrganizationName","MiriamG@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Communications"
        {
            Credential           = $Credscredential;
            Description          = "Communications Team";
            DisplayName          = "Communications";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "2b4794a4-617f-4afa-92de-004acfabf4a3";
            MailEnabled          = $True;
            MailNickname         = "Communications";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","JoniS@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LidiaH@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("admin@$OrganizationName","MeganB@$OrganizationName","DiegoS@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Private";
        }
        AADGroup "AADGroup-Parents of Contoso"
        {
            Credential           = $Credscredential;
            Description          = "Parents of Contoso";
            DisplayName          = "Parents of Contoso";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "2faed893-7ff5-415a-b018-7ad8e6c479b7";
            MailEnabled          = $True;
            MailNickname         = "parentsofcontoso";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-CEO Connection"
        {
            Credential           = $Credscredential;
            Description          = "Contribute your ideas and ask your questions to our leadership team. And tune in for regular Employee Q & A live events. You can learn more about what";
            DisplayName          = "CEO Connection";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "3fc0175b-585e-405f-8506-43c2d5a368a8";
            MailEnabled          = $True;
            MailNickname         = "ceoconnection";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-ssg-Contoso Bug Bashers"
        {
            Credential           = $Credscredential;
            Description          = "Self-service group of employees who wish to provide feedback on early-release Contoso software.";
            DisplayName          = "ssg-Contoso Bug Bashers";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "42cc5cb2-46a4-4176-bd18-ed60511b9b64";
            MailEnabled          = $False;
            MailNickname         = "ssgBugBashers";
            MemberOf             = @();
            Members              = @("PattiF@$OrganizationName","RaulR@$OrganizationName","BiancaP@$OrganizationName");
            Owners               = @("PattiF@$OrganizationName");
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-sg-Sales and Marketing"
        {
            Credential           = $Credscredential;
            Description          = "All marketing personnel";
            DisplayName          = "sg-Sales and Marketing";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "4bc62350-11ff-4caa-b015-729a3f1a0d2a";
            MailEnabled          = $False;
            MailNickname         = "sgSalesandMarketing";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","ChristieC@$OrganizationName","IsaiahL@$OrganizationName","AdeleV@$OrganizationName","LidiaH@$OrganizationName","LynneR@$OrganizationName","MiriamG@$OrganizationName","BiancaP@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-Office 365 Adoption"
        {
            Credential           = $Credscredential;
            Description          = "Office 365 Adoption";
            DisplayName          = "Office 365 Adoption";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "50840f3a-8337-4b9c-9842-b964a5e09f9b";
            MailEnabled          = $True;
            MailNickname         = "office365adoption";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-sg-HR"
        {
            Credential           = $Credscredential;
            Description          = "All HR personnel";
            DisplayName          = "sg-HR";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "679b8949-7f80-4119-a13d-bf25ce973304";
            MailEnabled          = $False;
            MailNickname         = "sgHR";
            MemberOf             = @();
            Members              = @();
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-OpenAI & ChatGPT Community"
        {
            Credential           = $Credscredential;
            Description          = "Test";
            DisplayName          = "OpenAI & ChatGPT Community";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "6c48e63c-ff4a-4bad-9751-40ca70b3603e";
            MailEnabled          = $True;
            MailNickname         = "OpenAIChatGPTCommunity";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Leadership"
        {
            Credential           = $Credscredential;
            Description          = "Share what's on your mind and get important announcements from Patti and the rest of the Leadership Team.";
            DisplayName          = "Leadership";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "6e089e1c-8d71-40f1-ba14-ac0a10248f63";
            MailEnabled          = $True;
            MailNickname         = "leadership";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("admin@$OrganizationName","NestorW@$OrganizationName","MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-sg-management"
        {
            Credential           = $Credscredential;
            DisplayName          = "sg-management";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "77e2e624-266d-48d5-a424-f6443138f74d";
            MailEnabled          = $False;
            MailNickname         = "b1f63771-7";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-Operations"
        {
            Credential           = $Credscredential;
            Description          = "Share what's on your mind and get important operations announcements.";
            DisplayName          = "Operations";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "7e330571-4155-4d89-a4c9-2be942136994";
            MailEnabled          = $True;
            MailNickname         = "operations";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Sales Best Practices"
        {
            Credential           = $Credscredential;
            Description          = "Sales Best Practices";
            DisplayName          = "Sales Best Practices";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "88de812c-e1b9-484a-9e05-4cda2d952c32";
            MailEnabled          = $True;
            MailNickname         = "salesbestpractices";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Group Creators"
        {
            Credential           = $Credscredential;
            Description          = "People in this Group are allowed to create Microsoft 365 Groups";
            DisplayName          = "Group Creators";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "8a216cf0-8c70-4d25-aa86-a6f2a1444dc3";
            MailEnabled          = $False;
            MailNickname         = "57326ab3-8";
            MemberOf             = @();
            Members              = @();
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-sg-Operations"
        {
            Credential           = $Credscredential;
            Description          = "All operations personnel";
            DisplayName          = "sg-Operations";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "9c89ee13-d931-4f76-a241-66f2bc615e94";
            MailEnabled          = $False;
            MailNickname         = "sgOperations";
            MemberOf             = @();
            Members              = @("AllanD@$OrganizationName","NestorW@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-sg-IT"
        {
            Credential           = $Credscredential;
            Description          = "All IT personnel";
            DisplayName          = "sg-IT";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "a1edc9ae-fb0d-46b6-99b9-457d3feae1f6";
            MailEnabled          = $False;
            MailNickname         = "sgIT";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-ssg-Contoso Ambassadors"
        {
            Credential           = $Credscredential;
            Description          = "Self-service group of employees who wish to participate in welcoming Contoso visitors.";
            DisplayName          = "ssg-Contoso Ambassadors";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "a2da4fc1-bf32-4321-89a6-d96fbe660c55";
            MailEnabled          = $False;
            MailNickname         = "ssgAmbassadors";
            MemberOf             = @();
            Members              = @("PattiF@$OrganizationName","IsaiahL@$OrganizationName","BiancaP@$OrganizationName");
            Owners               = @("PattiF@$OrganizationName");
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-Ask HR"
        {
            Credential           = $Credscredential;
            Description          = "Ask HR";
            DisplayName          = "Ask HR";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "a3af2870-b232-41c9-8c0b-63563a3a0d2c";
            MailEnabled          = $True;
            MailNickname         = "askhr";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-SSPRSecurityGroupUsers"
        {
            Credential           = $Credscredential;
            Description          = "Self-service password reset enabled users";
            DisplayName          = "SSPRSecurityGroupUsers";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "ac6fd97a-07e4-4e5d-9c4e-22c7bbfc0e21";
            MailEnabled          = $False;
            MailNickname         = "SSPRSecurityGroupUsers";
            MemberOf             = @();
            Members              = @("RaulR@$OrganizationName","BiancaP@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-SOC Team"
        {
            Credential           = $Credscredential;
            Description          = "SOC Team";
            DisplayName          = "SOC Team";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "afb9d72f-311f-4b9c-96d2-b53e131727d0";
            MailEnabled          = $True;
            MailNickname         = "SOCTeam";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","AllanD@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LidiaH@$OrganizationName");
            Owners               = @("admin@$OrganizationName","AllanD@$OrganizationName","MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Private";
        }
        AADGroup "AADGroup-New Employee Onboarding"
        {
            Credential           = $Credscredential;
            Description          = "New Employee Onboarding";
            DisplayName          = "New Employee Onboarding";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "b0d718c8-7f13-4e39-bd0f-ce2ac4ec1e25";
            MailEnabled          = $True;
            MailNickname         = "newemployeeonboarding";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","PradeepG@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","MeganB@$OrganizationName","GradyA@$OrganizationName");
            Owners               = @("admin@$OrganizationName","MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Safety"
        {
            Credential           = $Credscredential;
            Description          = "Safety";
            DisplayName          = "Safety";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "b4ba8de1-5456-4420-901a-f3706fdb6454";
            MailEnabled          = $True;
            MailNickname         = "safety";
            MemberOf             = @();
            Members              = @("MeganB@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Design"
        {
            Credential           = $Credscredential;
            Description          = "Design Team";
            DisplayName          = "Design";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "b7c8f557-f7ce-4277-b4ea-2a63074e7d94";
            MailEnabled          = $True;
            MailNickname         = "Design";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("admin@$OrganizationName","ChristieC@$OrganizationName","MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Private";
        }
        AADGroup "AADGroup-sg-Retail"
        {
            Credential           = $Credscredential;
            Description          = "All retail Users";
            DisplayName          = "sg-Retail";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "be51139c-af2b-479e-a49a-5535561964f1";
            MailEnabled          = $False;
            MailNickname         = "sgRetail";
            MemberOf             = @();
            Members              = @("CameronW@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-Contoso marketing"
        {
            Credential           = $Credscredential;
            Description          = "Contoso marketing";
            DisplayName          = "Contoso marketing";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "bf4c7934-8689-47b5-975e-aebf0c12850d";
            MailEnabled          = $True;
            MailNickname         = "Contosomarketing";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("admin@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-sg-Engineering"
        {
            Credential           = $Credscredential;
            Description          = "All engineering personnel";
            DisplayName          = "sg-Engineering";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "c4b1024c-69f1-42e9-afb4-49171717a3f6";
            MailEnabled          = $False;
            MailNickname         = "sgEngineering";
            MemberOf             = @();
            Members              = @("JohannaL@$OrganizationName","LeeG@$OrganizationName","DeliaD@$OrganizationName","RaulR@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-sg-Finance"
        {
            Credential           = $Credscredential;
            Description          = "All finance personnel";
            DisplayName          = "sg-Finance";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "ca006728-6d9b-4bb3-b8b4-3fd0196a0306";
            MailEnabled          = $False;
            MailNickname         = "sgFinance";
            MemberOf             = @();
            Members              = @("PradeepG@$OrganizationName","DebraB@$OrganizationName","MeganB@$OrganizationName","DiegoS@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-All Company"
        {
            Credential           = $Credscredential;
            Description          = "This is the default group for everyone in the network";
            DisplayName          = "All Company";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "cf7c5a99-3870-4b6f-ab9b-ae5e69009c52";
            MailEnabled          = $True;
            MailNickname         = "allcompany";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName");
            Owners               = @("admin@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-Remote living"
        {
            Credential           = $Credscredential;
            Description          = "Remote living";
            DisplayName          = "Remote living";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "d249ff6d-dd28-40ed-99fe-9b94cf85cd6a";
            MailEnabled          = $True;
            MailNickname         = "Remoteliving";
            MemberOf             = @();
            Members              = @("admin@$OrganizationName","AlexW@$OrganizationName","PradeepG@$OrganizationName","DebraB@$OrganizationName","PattiF@$OrganizationName","AllanD@$OrganizationName","ChristieC@$OrganizationName","JoniS@$OrganizationName","JohannaL@$OrganizationName","NestorW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","LeeG@$OrganizationName","AdeleV@$OrganizationName","IrvinS@$OrganizationName","LidiaH@$OrganizationName","GradyA@$OrganizationName","LynneR@$OrganizationName","DiegoS@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @("admin@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Public";
        }
        AADGroup "AADGroup-CPC-Windows365-Enterprise-AADJoin"
        {
            Credential           = $Credscredential;
            DisplayName          = "CPC-Windows365-Enterprise-AADJoin";
            Ensure               = "Present";
            GroupTypes           = @();
            Id                   = "db41ae61-1ef0-4114-b734-343eff1a7a0c";
            MailEnabled          = $False;
            MailNickname         = "16d0f2d6-b";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","IsaiahL@$OrganizationName","MeganB@$OrganizationName","MiriamG@$OrganizationName");
            Owners               = @();
            SecurityEnabled      = $True;
        }
        AADGroup "AADGroup-Microsoft 365 - Einführung"
        {
            Credential           = $Credscredential;
            Description          = "Microsoft 365 - Einführung";
            DisplayName          = "Microsoft 365 - Einführung";
            Ensure               = "Present";
            GroupTypes           = @("Unified");
            Id                   = "ea9cf364-1955-4519-9389-dd88d6a8866f";
            MailEnabled          = $True;
            MailNickname         = "Microsoft365-Einfhrung";
            MemberOf             = @();
            Members              = @("AlexW@$OrganizationName","MeganB@$OrganizationName","philipp.kohn_sva.de#EXT#@$OrganizationName");
            Owners               = @("MeganB@$OrganizationName");
            SecurityEnabled      = $False;
            Visibility           = "Private";
        }
        AADTenantDetails "AADTenantDetails"
        {
            Credential                           = $Credscredential;
            IsSingleInstance                     = "Yes";
            MarketingNotificationEmails          = @();
            SecurityComplianceNotificationMails  = @();
            SecurityComplianceNotificationPhones = @();
            TechnicalNotificationMails           = @("transformprov@microsoft.com");
        }
        AADUser "AADUser-Conf Room Adams"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Adams";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Adams@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Adele Vance"
        {
            City                 = "Bellevue";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Retail";
            DisplayName          = "Adele Vance";
            Ensure               = "Present";
            FirstName            = "Adele";
            LastName             = "Vance";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "18/2111";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98004";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "205 108th Ave. NE, Suite 400";
            Title                = "Retail Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "AdeleV@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-MOD Administrator"
        {
            Country              = "NL";
            Credential           = $Credscredential;
            DisplayName          = "MOD Administrator";
            Ensure               = "Present";
            FirstName            = "MOD";
            LastName             = "Administrator";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","Win10_VDA_E3","EMSPREMIUM","ENTERPRISEPACK","ENTERPRISEPREMIUM");
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PreferredLanguage    = "en-US";
            Roles                = @("Global Administrator");
            UsageLocation        = "NL";
            UserPrincipalName    = "admin@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Alex Wilber"
        {
            City                 = "San Diego";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Marketing";
            DisplayName          = "Alex Wilber";
            Ensure               = "Present";
            FirstName            = "Alex";
            LastName             = "Wilber";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "131/1104";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "92121";
            Roles                = @();
            State                = "CA";
            StreetAddress        = "9256 Towne Center Dr., Suite 400";
            Title                = "Marketing Assistant";
            UsageLocation        = "NL";
            UserPrincipalName    = "AlexW@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Allan Deyoung"
        {
            City                 = "Waukesha";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "IT";
            DisplayName          = "Allan Deyoung";
            Ensure               = "Present";
            FirstName            = "Allan";
            LastName             = "Deyoung";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "24/1106";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "53188";
            Roles                = @("Global Administrator");
            State                = "WI";
            StreetAddress        = "N19 W24133 Riverwood Dr., Suite 150";
            Title                = "IT Admin";
            UsageLocation        = "NL";
            UserPrincipalName    = "AllanD@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Automate Bot"
        {
            Credential           = $Credscredential;
            DisplayName          = "Automate Bot";
            Ensure               = "Present";
            FirstName            = "Automate";
            LastName             = "Bot";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UsageLocation        = "NL";
            UserPrincipalName    = "AutomateB@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Conf Room Baker"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Baker";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Baker@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Bianca Pisani"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Sales";
            DisplayName          = "Bianca Pisani";
            Ensure               = "Present";
            FirstName            = "Bianca";
            LastName             = "Pisani";
            LicenseAssignment    = @();
            Office               = "20/2046";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            Title                = "Salesperson";
            UsageLocation        = "NL";
            UserPrincipalName    = "BiancaP@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Brian Johnson (TAILSPIN)"
        {
            Credential           = $Credscredential;
            DisplayName          = "Brian Johnson (TAILSPIN)";
            Ensure               = "Present";
            FirstName            = "Brian";
            LastName             = "Johnson";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "BrianJ@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Cameron White"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Sales";
            DisplayName          = "Cameron White";
            Ensure               = "Present";
            FirstName            = "Cameron";
            LastName             = "White";
            LicenseAssignment    = @();
            Office               = "20/2071";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            Title                = "Salesperson";
            UsageLocation        = "NL";
            UserPrincipalName    = "CameronW@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Christie Cline"
        {
            City                 = "San Diego";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Sales";
            DisplayName          = "Christie Cline";
            Ensure               = "Present";
            FirstName            = "Christie";
            LastName             = "Cline";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "131/2105";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "92121";
            Roles                = @();
            State                = "CA";
            StreetAddress        = "9257 Towne Center Dr., Suite 400";
            Title                = "Buyer";
            UsageLocation        = "NL";
            UserPrincipalName    = "ChristieC@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Conf Room Crystal"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Crystal";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Crystal@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Debra Berger"
        {
            City                 = "Bellevue";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Executive Management";
            DisplayName          = "Debra Berger";
            Ensure               = "Present";
            FirstName            = "Debra";
            LastName             = "Berger";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "18/2107";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98004";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "205 108th Ave. NE, Suite 400";
            Title                = "Administrative Assistant";
            UsageLocation        = "NL";
            UserPrincipalName    = "DebraB@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Delia Dennis"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Engineering";
            DisplayName          = "Delia Dennis";
            Ensure               = "Present";
            FirstName            = "Delia";
            LastName             = "Dennis";
            LicenseAssignment    = @();
            Office               = "20/2051";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            Title                = "Engineer";
            UsageLocation        = "NL";
            UserPrincipalName    = "DeliaD@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Diego Siciliani"
        {
            City                 = "Birmingham";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "HR";
            DisplayName          = "Diego Siciliani";
            Ensure               = "Present";
            FirstName            = "Diego";
            LastName             = "Siciliani";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "14/1108";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "35243";
            Roles                = @();
            State                = "AL";
            StreetAddress        = "3535 Gradview Parkway Suite 335";
            Title                = "HR Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "DiegoS@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Gerhart Moller"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            DisplayName          = "Gerhart Moller";
            Ensure               = "Present";
            FirstName            = "Gerhart";
            LastName             = "Moller";
            LicenseAssignment    = @();
            Office               = "20/2008";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            Title                = "Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "GerhartM@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Grady Archie"
        {
            City                 = "Bloomington";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "R&D";
            DisplayName          = "Grady Archie";
            Ensure               = "Present";
            FirstName            = "Grady";
            LastName             = "Archie";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "19/2109";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "61704";
            Roles                = @();
            State                = "IL";
            StreetAddress        = "2203 E. Empire St., Suite J";
            Title                = "Designer";
            UsageLocation        = "NL";
            UserPrincipalName    = "GradyA@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Conf Room Hood"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Hood";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Hood@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Irvin Sayers"
        {
            City                 = "Bloomington";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "R&D";
            DisplayName          = "Irvin Sayers";
            Ensure               = "Present";
            FirstName            = "Irvin";
            LastName             = "Sayers";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "19/2106";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "61704";
            Roles                = @();
            State                = "IL";
            StreetAddress        = "2203 E. Empire St., Suite J";
            Title                = "Project Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "IrvinS@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Isaiah Langer"
        {
            City                 = "Tulsa";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Sales";
            DisplayName          = "Isaiah Langer";
            Ensure               = "Present";
            FirstName            = "Isaiah";
            LastName             = "Langer";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "20/1101";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "74133";
            Roles                = @("Global Administrator");
            State                = "OK";
            StreetAddress        = "7633 E. 63rd Place, Suite 300";
            Title                = "Sales Rep";
            UsageLocation        = "NL";
            UserPrincipalName    = "IsaiahL@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-IT-Support"
        {
            Credential           = $Credscredential;
            DisplayName          = "IT-Support";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "ITSupport@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Johanna Lorenz"
        {
            City                 = "Louisville";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Engineering";
            DisplayName          = "Johanna Lorenz";
            Ensure               = "Present";
            FirstName            = "Johanna";
            LastName             = "Lorenz";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "23/2102";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "40223";
            Roles                = @();
            State                = "KY";
            StreetAddress        = "9900 Corporate Campus Dr., Suite 3000";
            Title                = "Senior Engineer";
            UsageLocation        = "NL";
            UserPrincipalName    = "JohannaL@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Joni Sherman"
        {
            City                 = "Charlotte";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Legal";
            DisplayName          = "Joni Sherman";
            Ensure               = "Present";
            FirstName            = "Joni";
            LastName             = "Sherman";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "20/1109";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "28273";
            Roles                = @();
            State                = "NC";
            StreetAddress        = "8055 Microsoft Way";
            Title                = "Paralegal";
            UsageLocation        = "NL";
            UserPrincipalName    = "JoniS@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Lee Gu"
        {
            City                 = "Overland Park";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Manufacturing";
            DisplayName          = "Lee Gu";
            Ensure               = "Present";
            FirstName            = "Lee";
            LastName             = "Gu";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "23/3101";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "66210";
            Roles                = @();
            State                = "KS";
            StreetAddress        = "10801 Mastin Blvd., Suite 620";
            Title                = "Director";
            UsageLocation        = "NL";
            UserPrincipalName    = "LeeG@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Lidia Holloway"
        {
            City                 = "Tulsa";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Engineering";
            DisplayName          = "Lidia Holloway";
            Ensure               = "Present";
            FirstName            = "Lidia";
            LastName             = "Holloway";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "20/2107";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "74133";
            Roles                = @("Global Administrator");
            State                = "OK";
            StreetAddress        = "7633 E. 63rd Place, Suite 300";
            Title                = "Product Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "LidiaH@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Lynne Robbins"
        {
            City                 = "Tulsa";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Retail";
            DisplayName          = "Lynne Robbins";
            Ensure               = "Present";
            FirstName            = "Lynne";
            LastName             = "Robbins";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "20/1104";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "74133";
            Roles                = @();
            State                = "OK";
            StreetAddress        = "7633 E. 63rd Place, Suite 300";
            Title                = "Planner";
            UsageLocation        = "NL";
            UserPrincipalName    = "LynneR@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Mallory Cortez"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            DisplayName          = "Mallory Cortez";
            Ensure               = "Present";
            FirstName            = "Mallory";
            LastName             = "Cortez";
            LicenseAssignment    = @();
            Office               = "20/2046";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            UsageLocation        = "NL";
            UserPrincipalName    = "MalloryC@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Megan Bowen"
        {
            City                 = "Pittsburgh";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Marketing";
            DisplayName          = "Megan Bowen";
            Ensure               = "Present";
            FirstName            = "Megan";
            LastName             = "Bowen";
            LicenseAssignment    = @("FLOW_FREE","INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "12/1110";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "15212";
            PreferredLanguage    = "en-US";
            Roles                = @("Global Administrator");
            State                = "PA";
            StreetAddress        = "30 Isabella St., Second Floor";
            Title                = "Marketing Manager";
            UsageLocation        = "NL";
            UserPrincipalName    = "MeganB@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Miriam Graham"
        {
            City                 = "San Diego";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Sales & Marketing";
            DisplayName          = "Miriam Graham";
            Ensure               = "Present";
            FirstName            = "Miriam";
            LastName             = "Graham";
            LicenseAssignment    = @("Win10_VDA_E3","INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "131/2103";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "92121";
            Roles                = @("Global Administrator");
            State                = "CA";
            StreetAddress        = "9255 Towne Center Dr., Suite 400";
            Title                = "Director";
            UsageLocation        = "NL";
            UserPrincipalName    = "MiriamG@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Microsoft Service Account"
        {
            Credential           = $Credscredential;
            DisplayName          = "Microsoft Service Account";
            Ensure               = "Present";
            FirstName            = "Microsoft";
            LastName             = "Service Account";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @("Global Administrator");
            UsageLocation        = "NL";
            UserPrincipalName    = "ms-serviceaccount@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Nestor Wilke"
        {
            City                 = "Seattle";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Operations";
            DisplayName          = "Nestor Wilke";
            Ensure               = "Present";
            FirstName            = "Nestor";
            LastName             = "Wilke";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "36/2121";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98109";
            Roles                = @("Global Administrator");
            State                = "WA";
            StreetAddress        = "320 Westlake Ave N. Thomas St.";
            Title                = "Director";
            UsageLocation        = "NL";
            UserPrincipalName    = "NestorW@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Patti Fernandez"
        {
            City                 = "Louisville";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Executive Management";
            DisplayName          = "Patti Fernandez";
            Ensure               = "Present";
            FirstName            = "Patti";
            LastName             = "Fernandez";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "15/1102";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "40223";
            Roles                = @();
            State                = "KY";
            StreetAddress        = "9900 Corporate Campus Dr., Suite 3000";
            Title                = "President";
            UsageLocation        = "NL";
            UserPrincipalName    = "PattiF@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-philipp.kohn"
        {
            Credential           = $Credscredential;
            DisplayName          = "philipp.kohn";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "philipp.kohn_sva.de#EXT#@$OrganizationName";
            UserType             = "Guest";
        }
        AADUser "AADUser-Pradeep Gupta"
        {
            City                 = "Cairo";
            Country              = "Egypt";
            Credential           = $Credscredential;
            Department           = "Finance";
            DisplayName          = "Pradeep Gupta";
            Ensure               = "Present";
            FirstName            = "Pradeep";
            LastName             = "Gupta";
            LicenseAssignment    = @("INFORMATION_PROTECTION_COMPLIANCE","EMSPREMIUM","ENTERPRISEPREMIUM");
            Office               = "98/2202";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            StreetAddress        = "Smart Village, Kilo 28, Cairo/Alex Desert Road";
            Title                = "Accountant";
            UsageLocation        = "NL";
            UserPrincipalName    = "PradeepG@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Conf Room Rainier"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Rainier";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Rainier@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Raul Razo"
        {
            City                 = "Redmond";
            Country              = "United States";
            Credential           = $Credscredential;
            Department           = "Engineering";
            DisplayName          = "Raul Razo";
            Ensure               = "Present";
            FirstName            = "Raul";
            LastName             = "Razo";
            LicenseAssignment    = @();
            Office               = "20/2003";
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            PostalCode           = "98052";
            Roles                = @();
            State                = "WA";
            StreetAddress        = "One Microsoft Way";
            Title                = "Engineer";
            UsageLocation        = "NL";
            UserPrincipalName    = "RaulR@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Conf Room Stevens"
        {
            Credential           = $Credscredential;
            DisplayName          = "Conf Room Stevens";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "Stevens@$OrganizationName";
            UserType             = "Member";
        }
        AADUser "AADUser-Umstellung Mobilgeräte"
        {
            Credential           = $Credscredential;
            DisplayName          = "Umstellung Mobilgeräte";
            Ensure               = "Present";
            LicenseAssignment    = @();
            Password             = New-Object System.Management.Automation.PSCredential('Password', (ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force));;
            PasswordNeverExpires = $False;
            Roles                = @();
            UserPrincipalName    = "UmstellungMobilgerte@$OrganizationName";
            UserType             = "Member";
        }
    }
}

M365TenantConfig -ConfigurationData .\ConfigurationData.psd1 -Credential $Credential
