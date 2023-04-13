## Create a new MSI based installation as a Win32 app
Use the New-IntuneWin32AppPackage function to first create the packaged Win32 app content file (.intunewin). Then call the Add-IntuneWin32App function to create a new Win32 app in Microsoft Intune. This function has dependencies for other functions in the module. For instance when passing the detection rule for the Win32 app, you need to use the New-IntuneWin32AppDetectionRule function to create the required input object. Below is an example how the dependent functions in this module can be used together with the Add-IntuneWin32App function to successfully upload a packaged Win32 app content file to Microsoft Intune:
```PowerShell
# Get MSI meta data from .intunewin file
$IntuneWinFile = "https://nthriveaman.file.core.windows.net/output/install.intunewin"
$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWinFile

# Create custom display name like 'Name' and 'Version'
$DisplayName = $IntuneWinMetaData.ApplicationInfo.Name + " " + $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion
$Publisher = $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiPublisher

# Create requirement rule for all platforms and Windows 10 20H2
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedWindowsRelease "20H2"

# Create MSI detection rule
$DetectionRule = New-IntuneWin32AppDetectionRuleMSI -ProductCode $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductCode -ProductVersionOperator "greaterThanOrEqual" -ProductVersion $IntuneWinMetaData.ApplicationInfo.MsiInfo.MsiProductVersion