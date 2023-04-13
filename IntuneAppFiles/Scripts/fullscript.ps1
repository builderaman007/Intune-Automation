# Modules Needed
# https://github.com/MSEndpointMgr/IntuneWin32App

# Storage Account Information
# https://github.com/Azure/azure-storage-azcopy
# Blob Endpoint - https://nthriveaman.blob.core.windows.net/

# Connect to Intune Graph API
Connect-MSIntuneGraph -TenantID "962e2a52-eb05-44c1-a323-124fb1823091"

# To list Intune Apps
# Get-IntuneWin32App -Verbose

# Packaging MSI as .intunewin File
$SourceFolder = "C:\Local Code\Source"
$SetupFile = "npp.exe"
$OutputFolder = "C:\Local Code\Output"
New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $OutputFolder -Verbose -Force

# Copy Local file to Blob
# azcopy copy "C:\Local Code\Output" "C:\Local Code\Src\AzCopy"

## Create a new MSI based installation as a Win32 app
## ----------------------------------------------------------------------------------------------------------------
# Get MSI meta data from .intunewin file
$IntuneWinFile = "C:\Local Code\Output\npp.intunewin"
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
$Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"

# Create MSI detection rule
$DetectionRule = New-IntuneWin32AppDetectionRuleMSI -ProductCode $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductCode -ProductVersionOperator "greaterThanOrEqual" -ProductVersion $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion

# Add new MSI Win32 app
Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "Install Notepad++ application" -Publisher $Publisher -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -Verbose
## End-------------------------------------------------------------------------------------------------------------------------

##Start ------------------------------------------------------------------------------------------------------------------------
## Create a new EXE/script based installation as a Win32 app
# Get EXE meta data from .intunewin file
$IntuneWinFile = "C:\Local Code\Output\npp.intunewin"
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
$Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"

# Create PowerShell script detection rule
## $DetectionScriptFile = "C:\Win32Apps\Output\Get-BitLockerEncryptionDetection.ps1"
## $DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false

# Add new EXE Win32 app
$InstallCommandLine = "powershell.exe -ExecutionPolicy Bypass -File .\Enable-BitLockerEncryption.ps1"
$UninstallCommandLine = "cmd.exe /c"
Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "Start BitLocker silent encryption" -Publisher "MSEndpointMgr" -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -ReturnCode $ReturnCode -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Verbose
## End --------------------------------------------------------------------------

## Start------------------------------------------------------------------------------
# assign permissions
# Get a specific Win32 app by it's display name
$Win32App = Get-IntuneWin32App -DisplayName "Notepad++" -Verbose

# create a new group
$newgroup = New-AzureADGroup -DisplayName "New Security Group"

# get group ID
$groupidlookup = Get-AzureADGroup -DisplayName $newgroup | Select-Object objectid

# Add an include assignment for a specific Azure AD group
$GroupID = $groupidlookup
Add-IntuneWin32AppAssignmentGroup -Include -ID $Win32App.id -GroupID $GroupID -Intent "available" -Notification "showAll" -Verbose

## End ---------------------------------------------------------------------------------------------
