# Disable Cortana and web search
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-Not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "AllowCortana" -Value 0 -Type DWord
Set-ItemProperty -Path $regPath -Name "DisableWebSearch" -Value 1 -Type DWord
