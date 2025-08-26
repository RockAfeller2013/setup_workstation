# change computer name
# setup hostname
# setup IP
# setup NTP/timezone
# setup DNS
# Disable IPV6
#Disable Defender
#Disable IPV6
#Chrome as default
#Disable Updates

# Create Desktop folder GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}
# https://answers.microsoft.com/en-us/insider/forum/all/god-mode-other-windows-10-tips-tricks/9e81e023-9179-4b59-9937-f1e9aab537b4

$Desktop = [Environment]::GetFolderPath("Desktop")
$GodMode = Join-Path $Desktop "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
New-Item -Path $GodMode -ItemType Directory


# Choco install

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); choco upgrade chocolatey -y

# CMD Here
# https://gist.github.com/hotoo/452523

New-Item -Path "HKCR:\*\shell\cmdhere" -Force | Out-Null; Set-ItemProperty -Path "HKCR:\*\shell\cmdhere" -Name "(default)" -Value "Cmd&Here"; New-Item -Path "HKCR:\*\shell\cmdhere\command" -Force | Out-Null; Set-ItemProperty -Path "HKCR:\*\shell\cmdhere\command" -Name "(default)" -Value "cmd.exe /c start cmd.exe /k pushd `"%L\\..`""

# Disable updates / SCONFIG and set updates to Manual

Stop-Service wuauserv -Force; Set-Service wuauserv -StartupType Disabled; Write-Output "Windows Update service stopped and disabled."

# Create reboot icons


# Disable firewall
netsh advfirewall set allprofiles state off

# Install Apps

choco install googlechrome --ignore-checksums --force -y
choco install bginfo --force -y
choco install 7zip.install --force -y
choco install foxitreader --force -y
choco install postman --force -y
choco install insomnia-rest-api-client --force -y
choco install thunderbird --force -y
choco install mremoteng --force -y
choco install putty --force -y
choco install filezilla --force -y
choco install winscp --force -y
choco install vlc --force -y
choco install monosnap --force -y
choco install code --force -y


# Setup BGINFO

C:\BGInfo\Bginfo.exe /silent /accepteula /nolicprompt /timer:00 BGconfig.bgi
"C:\ProgramData\chocolatey\bin\Bginfo64.exe /timer:0 /silent /nolicprompt /accepteula /ALL"

# Setup Product Key
slmgr.vbs /ipk <your_product_key>
slmgr.vbs /ato
slmgr.vbs /dlv
slmgr /dlv
slmgr /skms kms8.msguides.com
DISM /online /Set-Edition:Enterprise /ProductKey:XX /AcceptEula


# Disable Defender
Stop-Service WinDefend -Force; Set-Service WinDefend -StartupType Disabled; Set-MpPreference -DisableRealtimeMonitoring $true; New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force; New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" -Name "NotificationDisabled" -Value 1 -PropertyType DWord -Force; New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAHealth" -Value 1 -PropertyType DWord -Force; Write-Output "Microsoft Defender disabled, notifications hidden, icon removed from taskbar."


https://github.com/chocolatey/chocolatey-environments/blob/master/scripts/PrepareWindows.ps1
https://github.com/memstechtips/UnattendedWinstall


