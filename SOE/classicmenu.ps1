@ "C:\Program Files\Classic Shell\ClassicStartMenu.exe" -exit



# Source values from current user
$src = "HKCU:\Software\IvoSoft"

# Apply to default profile (for new users)
$dstDefault = "HKU:\.DEFAULT\Software\IvoSoft"
if (-not (Test-Path $dstDefault)) {
    New-Item -Path $dstDefault -Force | Out-Null
}
Copy-Item -Path $src\* -Destination $dstDefault -Recurse -Force

# Apply to each existing user hive
Get-ChildItem "HKU:\" | Where-Object { $_.Name -match '^HKEY_USERS\\S-1-5-21' } | ForEach-Object {
    $dst = "$($_.PSPath)\Software\IvoSoft"
    if (-not (Test-Path $dst)) {
        New-Item -Path $dst -Force | Out-Null
    }
    Copy-Item -Path $src\* -Destination $dst -Recurse -Force
}

@ "C:\Program Files\Classic Shell\ClassicStartMenu.exe" -settings
@ "C:\Program Files\Classic Shell\ClassicStartMenu.exe"
