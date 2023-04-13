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
$SourceFolder = "C:\Local Code\Source"
$SetupFile = "7zip.msi"
$OutputFolder = "C:\Local Code\Output"
New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $OutputFolder -Verbose -Force

# Copy Local file to Blob
# azcopy copy "C:\Local Code\Output" "C:\Local Code\Src\AzCopy"

## Create a new MSI based installation as a Win32 app
## ----------------------------------------------------------------------------------------------------------------
# Get MSI meta data from .intunewin file
$IntuneWinFile = "C:\Local Code\Output\7zip.intunewin"
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
$Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"

# Create MSI detection rule
$DetectionRule = New-IntuneWin32AppDetectionRuleMSI -ProductCode $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductCode -ProductVersionOperator "greaterThanOrEqual" -ProductVersion $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion

# Add new MSI Win32 app
Add-IntuneWin32App -FilePath $IntuneWinFile -DisplayName $DisplayName -Description "Install 7Zip MSI application" -Publisher $Publisher -InstallExperience "system" -RestartBehavior "suppress" -DetectionRule $DetectionRule -RequirementRule $RequirementRule -Verbose
## End-------------------------------------------------------------------------------------------------------------------------

