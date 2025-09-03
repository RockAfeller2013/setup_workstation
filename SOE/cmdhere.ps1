# --- “CMD here” context menu (current path) ---
New-Item -Path "HKCR:\Directory\shell\cmdhere" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere" -Name "(default)" -Value "Cmd&Here"
New-Item -Path "HKCR:\Directory\shell\cmdhere\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere\command" -Name "(default)" -Value "cmd.exe /c start cmd.exe /k pushd `"%V`""
