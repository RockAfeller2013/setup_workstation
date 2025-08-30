# ============================================
# Windows Workstation Setup Script
# ============================================

# # powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/setup_new.ps1')"

# --- Rename Computer ---
Rename-Computer -NewName "WIN11" -Force -PassThru

# --- Set Timezone & NTP ---
Set-TimeZone -Name "E. Australia Standard Time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update
w32tm /resync
w32tm /query /status

# --- Disable IPv6 ---
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -PassThru

# --- Create GodMode Folder on Desktop ---
$Desktop = [Environment]::GetFolderPath("Desktop")
$GodMode = Join-Path $Desktop "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
New-Item -Path $GodMode -ItemType Directory -Force

# --- Install Chocolatey ---
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade chocolatey -y

# --- Add "CMD Here" Context Menu ---
New-Item -Path "HKCR:\*\shell\cmdhere" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\*\shell\cmdhere" -Name "(default)" -Value "Cmd&Here"
New-Item -Path "HKCR:\*\shell\cmdhere\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\*\shell\cmdhere\command" -Name "(default)" -Value "cmd.exe /c start cmd.exe /k pushd `"%L\\..`""

# --- Disable Windows Update ---
Stop-Service wuauserv -Force
Set-Service wuauserv -StartupType Disabled

# --- Disable Firewall ---
netsh advfirewall set allprofiles state off

# --- Enable WSL ---
wsl --install

# --- Install Applications via Chocolatey ---
$apps = @(
  "classic-shell","googlechrome","bginfo","7zip.install","foxitreader",
  "postman","insomnia-rest-api-client","thunderbird","mremoteng","putty",
  "filezilla","winscp","vlc","monosnap","rufus","git","gitkraken",
  "nodejs-lts","python","openjdk","visualstudio2019community","docker-desktop",
  "cmder","vscode-insiders","jetbrains-toolbox","neovim","curl","wget",
  "httpie","notepadplusplus","sysinternals","powershell-core","everything",
  "f.lux","clipjump","awscli","azure-cli","kubernetes-cli","gcp-cli",
  "x64dbg.portable","ollydbg","cursoride","nvidia-broadcast","claude",
  "warp-terminal","windsurf","pycharm-community","pycharm-edu","pycharm"
)

foreach ($app in $apps) {
    choco install $app --force -y --ignore-checksums
}

# --- Configure BGINFO (Download custom config manually if needed) ---
# --- Configure BGINFO ---
$bgExe   = "C:\ProgramData\chocolatey\bin\Bginfo64.exe"
$bgDst   = "C:\ProgramData\bginfo.bgi"
$bgUrl   = "https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/bginfo.bgi"

# Download bginfo.bgi if missing
if (-not (Test-Path $bgDst)) {
    Invoke-WebRequest -Uri $bgUrl -OutFile $bgDst -UseBasicParsing
    Write-Output "Downloaded bginfo.bgi to $bgDst"
}

# Run BGINFO silently
if (Test-Path $bgExe) {
    & $bgExe $bgDst /accepteula /silent /timer:0
    Write-Output "BGINFO applied using $bgDst"
}


# --- Disable Defender ---
Stop-Service WinDefend -Force
Set-Service WinDefend -StartupType Disabled
Set-MpPreference -DisableRealtimeMonitoring $true
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" -Name "NotificationDisabled" -Value 1 -PropertyType DWord -Force

# --- Enable Auto Login (Set your username & password) ---
$User = "vagrant"
$Pass = "vagrant"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $User
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Pass
Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogonCount -ErrorAction SilentlyContinue

# --- Disable IE First Run + ESC ---
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey  = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"

foreach ($key in @($AdminKey,$UserKey)) {
    if (Test-Path $key) { New-ItemProperty -Path $key -Name "IsInstalled" -Value 0 -Force }
}

$keyIE = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
if (Test-Path $keyIE) {
    New-ItemProperty -Path $keyIE -Name "DisableFirstRunCustomize" -Value 1 -PropertyType DWord -Force
}

# --- Explorer Preferences ---
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1

# --- Enable Network Discovery & File Sharing ---
Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled True
Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled True
Get-NetAdapter | ForEach-Object {
    Get-NetConnectionProfile -InterfaceIndex $_.ifIndex | Set-NetConnectionProfile -NetworkCategory Private
}

# --- Optional: Disable Server Manager on Server OS ---
$os = Get-CimInstance -ClassName Win32_OperatingSystem
if ($os.ProductType -eq 3) {
    Get-ScheduledTask -TaskName 'ServerManager' | Disable-ScheduledTask
}
# Disable Services

# Bare-bones Windows 11 Optimization Script
# WARNING: This will disable updates, security features, and system components.
# Run in PowerShell as Administrator

$services = @(
    # Updates and Store
    "wuauserv",         # Windows Update
    "UsoSvc",           # Update Orchestrator
    "WaaSMedicSvc",     # Windows Update Medic
    "DoSvc",            # Delivery Optimization
    "BITS",             # Background Intelligent Transfer
    "InstallService",   # Microsoft Store

    # Security / Defender
    "WdNisSvc",         # Windows Defender Antivirus Network Inspection
    "WinDefend",        # Windows Defender Antivirus
    "SecurityHealthService", # Security Center

    # Telemetry and Diagnostics
    "DiagTrack",        # Connected User Experiences and Telemetry
    "dmwappushservice", # WAP Push Service
    "diagnosticshub.standardcollector.service",
    "WerSvc",           # Windows Error Reporting
    "RemoteRegistry",

    # Cloud and Cortana
    "OneSyncSvc",       # Sync Host
    "OneDrive",         # OneDrive
    "PimIndexMaintenanceSvc", # Contact Data
    "CDPSvc",           # Connected Devices Platform
    "CDPUserSvc",
    "RetailDemo",

    # Network / Sharing
    "SharedAccess",     # Internet Connection Sharing
    "HomeGroupListener",
    "HomeGroupProvider",
    "lfsvc",            # Geolocation
    "RemoteAccess",     # Routing and Remote Access
    "RemoteDesktopServices",
    "TermService",      # Remote Desktop Services
    "RemoteDesktopConfiguration",
    "RemoteDesktopUserModePortRedirector",

    # Printing / Bluetooth
    "Spooler",          # Print Spooler
    "PrintNotify",
    "Fax",
    "BTAGService",      # Bluetooth Audio Gateway
    "bthserv",          # Bluetooth Support
    "BthHFSrv",         # Bluetooth Handsfree

    # Hyper-V
    "vmms",             # Hyper-V Virtual Machine Management
    "HvHost"            # Hyper-V Host
)

foreach ($svc in $services) {
    Write-Output "Disabling service: $svc"
    Stop-Service -Name $svc -ErrorAction SilentlyContinue
    Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
}

# Extra: Disable Scheduled Tasks related to telemetry
$tasks = @(
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "\Microsoft\Windows\Autochk\Proxy",
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "\Microsoft\Windows\Feedback\Siuf\DmClient",
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
)

foreach ($task in $tasks) {
    Write-Output "Disabling task: $task"
    schtasks /Change /TN $task /Disable 2>$null
}

Write-Output "System setup completed."

# Setup Product Key
#slmgr.vbs /ipk <your_product_key>
#slmgr.vbs /ato
#slmgr.vbs /dlv
#slmgr /dlv
#slmgr /skms kms8.msguides.com
#DISM /online /Set-Edition:Enterprise /ProductKey:XX /AcceptEula


######

# Download and Run https://winhance.net/ Manualy 
# Download and Run https://windhawk.net/mods
# Select all and download and run -https://privacy.sexy/
# Download and install https://ninite.com/

# Claude Code
#Gemni
#LM Studio (AUR)
#Ollama
#Crush
#Opencode

# sysprep /generalize /mode:vm /shutdown
# Make into Proxmox Clone
