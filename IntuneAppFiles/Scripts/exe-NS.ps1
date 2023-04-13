
# Modules Needed
# https://github.com/MSEndpointMgr/IntuneWin32App

# Storage Account Information
# https://github.com/Azure/azure-storage-azcopy
# Blob Endpoint - https://nthriveaman.blob.core.windows.net/

Install-Module -Name "IntuneWin32App" -Scope CurrentUser

# Connect to Intune Graph API
Connect-MSIntuneGraph -TenantID "962e2a52-eb05-44c1-a323-124fb1823091"

# To list Intune Apps
# Get-IntuneWin32App -Verbose

# Packaging MSI as .intunewin File
$SourceFolder = "C:\Local Code\Source\VSCode"
$SetupFile = "VSCode.bat"
$OutputFolder = "C:\Local Code\Output"
New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $OutputFolder -Verbose -Force

# Copy Local file to Blob
# azcopy copy "C:\Local Code\Output" "C:\Local Code\Src\AzCopy"

##Start ------------------------------------------------------------------------------------------------------------------------
## Create a new EXE/script based installation as a Win32 app
# Get EXE meta data from .intunewin file
$IntuneWinFile = "C:\Local Code\Output\VSCode.intunewin"
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
# This line is for MSI
# $Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"

# Create PowerShell script detection rule

$DetectionScriptFile = "C:\Local Code\Src\IntuneAppFiles\PowerShell\Detection.ps1"
$DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $DetectionScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false

# Add new EXE Win32 app
$InstallCommandLine = "ServiceUI.exe -process:explorer.exe VSCode.bat"
$UninstallCommandLine = "uninstall.bat"
Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "VSCode/User Input is here, it's .exe file Install" -Publisher "VSCode" -InstallExperience "user" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Verbose

# # Add new EXE Win32 app
# $InstallCommandLine = "powershell.exe -ExecutionPolicy Bypass -File .\Enable-BitLockerEncryption.ps1"
# $UninstallCommandLine = "cmd.exe /c"
# Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "Start BitLocker silent encryption" -Publisher "MSEndpointMgr" -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -ReturnCode $ReturnCode -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Verbose