& "C:\Program Files\Classic Shell\ClassicStartMenu.exe" -exit

$keys = @{
    "ClassicExplorer" = @{ ShowedToolbar = 1 }
    "ClassicShell"    = @{ }  # Add values as needed
    "ClassicStartMenu"= @{ CSettingsDlg = [byte[]](248,1,0,0) }
}

# Iterate all user SIDs
Get-ChildItem "HKU:" | ForEach-Object {
    $sid = $_.PSChildName
    foreach ($key in $keys.Keys) {
        $path = "HKU:\$sid\Software\IvoSoft\$key"
        if (-not (Test-Path $path)) { New-Item -Path $path -Force }
        foreach ($name in $keys[$key].Keys) {
            New-ItemProperty -Path $path -Name $name -Value $keys[$key][$name] -PropertyType DWORD -Force
        }
    }
}

& "C:\Program Files\Classic Shell\ClassicStartMenu.exe" -settings
& "C:\Program Files\Classic Shell\ClassicStartMenu.exe"
