$AcrobatPath = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

$RegPath = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"
$RegName = "bIsSCReducedModeEnforcedEx"
$ExpectedValue = 1

$AcrobatExists = Test-Path $AcrobatPath

$RegValue = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction SilentlyContinue

if ($AcrobatExists -and $RegValue.$RegName -eq $ExpectedValue) {
    exit 0
}
else {
    exit 1
}