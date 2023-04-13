# Package MSI as .intunewin file
$SourceFolder = "C:\Local Code\Source"
$SetupFile = "npp.exe"
$OutputFolder = "C:\Local Code\Output"
New-IntuneWin32AppPackage -SourceFolder $SourceFolder -SetupFile $SetupFile -OutputFolder $OutputFolder -Verbose