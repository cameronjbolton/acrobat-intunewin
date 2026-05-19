# install.ps1
# this goes in .\acrobat\source

$ErrorActionPreference = "Stop"

$setupPath = ".\setup.exe"

$arguments = "/sAll /re"

$process = Start-Process -FilePath $setupPath -ArgumentList $arguments -Wait -PassThru

if ($process.ExitCode -ne 0) {
    Write-Host "Exiting with code: $process.ExitCode"
    exit $process.ExitCode
}

$regKey = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"
$regValue = "bIsSCReducedModeEnforcedEx"
$value = 1

if (-not (Test-Path $regKey)) {
    Write-Host "No FeatureLockDown reg key. Creating key."
    New-Item -Path $regKey -Force | Out-Null
}

New-ItemProperty `
    -Path $regKey `
    -Name $regValue `
    -Value $value `
    -PropertyType DWord `
    -Force | Out-Null

exit 0
