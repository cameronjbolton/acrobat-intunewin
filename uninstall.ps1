# uninstall.ps1
$ErrorActionPreference = "Stop"

$apps = Get-ItemProperty `
    HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, `
    HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
    -ErrorAction SilentlyContinue |
Where-Object {
    $_.DisplayName -like "*Adobe Acrobat*" -or
    $_.DisplayName -like "*Adobe Reader*"
}

if (-not $apps) {
    Write-Host "No matching Adobe apps found"
    exit 0
}

foreach ($app in $apps) {
    if ($app.UninstallString -match "\{[A-Fa-f0-9-]+\}") {
        $productCode = $matches[0]
        $process = Start-Process "msiexec.exe" `
            -ArgumentList "/x $productCode /qn /norestart" `
            -Wait -PassThru
        Write-Host "Uninstall of $($app.DisplayName) exited with code: $($process.ExitCode)"
    }
}

$regPath = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"
if (Test-Path $regPath) {
    Remove-Item -Path $regPath -Recurse -Force
    Write-Host "Removed registry key: $regPath"
}

exit 0
