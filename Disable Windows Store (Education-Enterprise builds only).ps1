# Disable Microsoft Store
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "RemoveWindowsStore" -Value 1 -Type DWord
