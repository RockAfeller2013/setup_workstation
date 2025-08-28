# change computer name
Rename-Computer -NewName "NEW-HOSTNAME" -Force -PassThru


# setup NTP/timezone
Set-TimeZone -Name "E. Australia Standard Time"
Get-TimeZone

w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update; w32tm /resync
w32tm /query /status

# setup DNS
# Disable IPV6
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -PassThru


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

# WSL
wsl --install

# Install Apps

choco install classic-shell -force -y
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


choco install git --force -y
choco install gitkraken --force -y
choco install nodejs-lts --force -y
choco install python --force -y
choco install openjdk --force -y
choco install visualstudio2019community --force -y
choco install docker-desktop --force -y
choco install cmder --force -y
choco install vscode-insiders --force -y
choco install jetbrains-toolbox --force -y
choco install neovim --force -y

choco install curl --force -y
choco install wget --force -y
choco install httpie --force -y

choco install notepadplusplus --force -y
choco install sysinternals --force -y
choco install powershell-core --force -y
choco install everything --force -y
choco install f.lux --force -y
choco install clipjump --force -y

choco install awscli --force -y
choco install azure-cli --force -y
choco install kubernetes-cli --force -y
choco install gcp-cli --force -y
choco install docker-desktop --force -y

choco install x64dbg.portable --force -y
choco install ollydbg --force -y

choco install cursoride --force -y
choco install nvidia-broadcast --force -y
choco install claude --force -y
choco install warp-terminal --force -y
choco install windsurf --force -y
choco install pycharm-community --force -y
choco install pycharm-edu --force -y
choco install pycharm --force -y


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

# Auto Login issue corrected, as per discussion here: https://twitter.com/stefscherer/status/1011120268222304256
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "vagrant"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "vagrant"
Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogonCount -Confirm -ErrorAction SilentlyContinue 

# Big Info Setup
Copy-Item "C:\vagrant\shell\bginfo.bgi" 'C:\programdata\chocolatey\lib\sysinternals\tools\bginfo.bgi'
Set-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name bginfo -Value 'c:\programdata\chocolatey\lib\bginfo\tools\bginfo.exe c:\vagrant\shell\bginfo.bgi /accepteula /silent /timer:0'
}

# Adapted from http://stackoverflow.com/a/29571064/18475
# Get the OS
$osData = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName

$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
if (Test-Path $AdminKey) {
    New-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force | Out-Null
    Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for Admin."
}

if (Test-Path $UserKey) {
    New-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force | Out-Null
    Write-Output "IE Enhanced Security Configuration (ESC) has been disabled for User."
}

#Stop-Process -Name Explorer -Force

# http://techrena.net/disable-ie-set-up-first-run-welcome-screen/
$key = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
if (Test-Path $key) {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 1 -PropertyType "DWord" -Force | Out-Null
    Write-Output "IE first run welcome screen has been disabled."
}

Write-Output 'Setting Windows Update service to Manual startup type.'
Set-Service -Name wuauserv -StartupType Manual

#Set-ExecutionPolicy Unrestricted

# Ensure there is a profile file so we can get tab completion
New-Item -ItemType Directory $(Split-Path $profile -Parent) -Force
Set-Content -Path $profile -Encoding UTF8 -Value "" -Force

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'

# Set Preferences
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
$advancedKey = "$key\Advanced"
Set-ItemProperty $advancedKey Hidden 1
Set-ItemProperty $advancedKey HideFileExt 0
Set-ItemProperty $advancedKey ShowSuperHidden 1

$identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$parts = $identity.Name -split "\\"
$user = @{Domain = $parts[0]; Name = $parts[1]}

try {
    try { $explorer = Get-Process -Name explorer -ErrorAction stop -IncludeUserName }
    catch {$global:error.RemoveAt(0)}

    if ($explorer -ne $null) {
        $explorer | ? { $_.UserName -eq "$($user.Domain)\$($user.Name)"} | Stop-Process -Force -ErrorAction Stop | Out-Null
    }

    Start-Sleep 1

    if (!(Get-Process -Name explorer -ErrorAction SilentlyContinue)) {
        $global:error.RemoveAt(0)
        start-Process -FilePath explorer
    }
}
catch {$global:error.RemoveAt(0)}

# Enable Network Discovery and File and Print Sharing
# Taken from here: http://win10server2016.com/enable-network-discovery-in-windows-10-creator-edition-without-using-the-netsh-command-in-powershell
Write-Host "Enabling Network Discovery."
$null = Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru
Write-Host "Enabling File and Printer Sharing."
$null = Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru

Get-NetAdapter | ForEach-Object {
    Write-Host "Setting '$($_.Name)' interface to a 'Private' network."
    Get-NetConnectionProfile -InterfaceIndex $_.ifIndex | Set-NetConnectionProfile -NetworkCategory Private
}

Write-Host "Disabling IPv6"
Get-NetAdapterBinding | Where-Object ComponentID -eq 'ms_tcpip6' | Disable-NetAdapterBinding

# Server OS
if ($osData.ProductType -eq 3) {
    Write-Host 'Disabling Server Manager for starting at login.'
    Get-ScheduledTask -TaskName 'ServerManager' | Disable-ScheduledTask | Out-Null
}

######

# Download and Run https://winhance.net/ Manualy 
# Download and Run https://windhawk.net/mods
# Select all and download and run -https://privacy.sexy/





