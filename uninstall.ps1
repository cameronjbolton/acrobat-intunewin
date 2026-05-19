# uninstall.ps1

$apps = Get-ItemProperty `
    HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, `
    HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* `
    -ErrorAction SilentlyContinue |
Where-Object {
    $_.DisplayName -like "*Adobe Acrobat*" -or
    $_.DisplayName -like "*Adobe Reader*"
}

foreach ($app in $apps) {
    if ($app.UninstallString -match "\{[A-Fa-f0-9-]+\}") {
        $productCode = $matches[0]

        Start-Process "msiexec.exe" `
            -ArgumentList "/x $productCode /qn /norestart" `
            -Wait
    }
}