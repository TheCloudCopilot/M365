# Get-MsolUser | Sort DisplayName | Select DisplayName | More
# Get-MsolUser | Where DisplayName -like "John*" | Sort DisplayName | Select DisplayName | More
$dispName='<The Display Name of the account>'

# Get-MsolRole | Sort Name | Select Name,Description
$roleName='<The role name you want to assign to the account>'

Add-MsolRoleMember -RoleMemberEmailAddress (Get-MsolUser | Where DisplayName -eq $dispName).UserPrincipalName -RoleName $roleName