# Clean temp folders and log files
$paths = @("$env:TEMP", "$env:WINDIR\Temp", "C:\Windows\Logs")
foreach ($path in $paths) {
    Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}
