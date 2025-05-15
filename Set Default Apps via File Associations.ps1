# Set Notepad++ as default for .txt files (example)
$assoc = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".txt" ProgId="Applications\notepad++.exe" ApplicationName="Notepad++" />
</DefaultAssociations>
"@
$assoc | Out-File -FilePath "C:\Temp\defaultassoc.xml" -Encoding UTF8
Dism.exe /Online /Import-DefaultAppAssociations:"C:\Temp\defaultassoc.xml"
