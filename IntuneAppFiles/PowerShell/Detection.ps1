$File = "$($env:USERPROFILE)\AppData\Local\Programs\Microsoft VS Code\VSCodeisHere"
if (Test-Path $File) {
    write-output "VSCode detected, exiting"
    exit 0
}
else {
    exit 1
}