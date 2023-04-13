Install-Module -Name "IntuneWin32App" -Scope CurrentUser
Install-Module -Name "AzureAD" -Scope CurrentUser

# Connect to Intune Graph API
Connect-MSIntuneGraph -TenantID "962e2a52-eb05-44c1-a323-124fb1823091"

# Connect to Azure AD API
Connect-AzureAD -TenantID "962e2a52-eb05-44c1-a323-124fb1823091"

## Start------------------------------------------------------------------------------
# assign permissions
# Get a specific Win32 app by it's display name
$Win32App = Get-IntuneWin32App -DisplayName "VSCode.bat" -Verbose

# create a new group
$newgroup = New-AzureADGroup -DisplayName "VSCode Security Group" -Description "VSCode - User Input Required: security group" -MailEnabled $false -MailNickName "NotSet" -SecurityEnabled $true

# get group ID
$groupidlookup = Get-AzureADGroup -ObjectId $newgroup.ObjectId

# Add an include assignment for a specific Azure AD group
$GroupID = $groupidlookup
Add-IntuneWin32AppAssignmentGroup -Include -ID $Win32App.id -GroupId $GroupID.ObjectId -Intent "available" -Notification "showAll" -Verbose

## End ---------------------------------------------------------------------------------------------
