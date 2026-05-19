# install.ps1
# this goes in .\acrobat\source
$ErrorActionPreference = "Stop"
$setupPath = ".\setup.exe"
$arguments = "/sAll /re"

$process = Start-Process -FilePath $setupPath -ArgumentList $arguments -Wait -PassThru
Write-Host "Setup exited with code: $($process.ExitCode)"

$regPath = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"
$regKey = "bIsSCReducedModeEnforcedEx"
$value = 1

if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
New-ItemProperty `
    -Path $regPath `
    -Name $regKey `
    -Value $value `
    -PropertyType DWord `
    -Force | Out-Null

exit 0
