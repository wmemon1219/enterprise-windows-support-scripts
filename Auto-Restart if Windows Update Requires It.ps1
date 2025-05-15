# Restart if updates require it
if ((Get-WURebootStatus).RebootRequired -eq $true) {
    Restart-Computer -Force
}
