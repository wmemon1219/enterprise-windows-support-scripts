$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$keyName = "NC_ShowSharedAccessUI"
$keyValue = 0

Try {
    If (-Not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    New-ItemProperty -Path $regPath -Name $keyName -Value $keyValue -PropertyType DWORD -Force | Out-Null
    Write-Output "Mobile Hotspot policy successfully applied."
}
Catch {
    Write-Error "Failed to apply Mobile Hotspot policy: $_"
}
