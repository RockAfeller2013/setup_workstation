#Requires -RunAsAdministrator
# ============================================
# Windows 11 Bare-Bones Privacy + Performance Setup
# ============================================

# Exit on errors
$ErrorActionPreference = "Stop"

# --- Computer name ---
Rename-Computer -NewName "WIN11" -Force

# --- Timezone & NTP ---
Set-Service -Name w32time -StartupType Automatic
Start-Service -Name w32time
Set-TimeZone -Name "E. Australia Standard Time"
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update
w32tm /resync

# --- Disable IPv6 on all adapters ---
Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -PassThru | Out-Null

# --- GodMode on Desktop ---
$desktop = [Environment]::GetFolderPath("Desktop")
$godMode = Join-Path $desktop "GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
New-Item -Path $godMode -ItemType Directory -Force | Out-Null

# --- Chocolatey bootstrap ---
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco upgrade chocolatey -y

# Helper: safe Chocolatey install (skips unknown packages)
function Install-ChocoPackage {
    param([Parameter(Mandatory)][string]$Id)
    $found = choco search $Id --exact --limit-output 2>$null | Select-String -Pattern "^\Q$Id\E(\||$)"
    if ($found) {
        Start-Process -FilePath "choco" -ArgumentList @("install",$Id,"-y","--ignore-checksums") -Wait | Out-Null
    } else {
        Write-Output "Skip (not found): $Id"
    }
}

# --- “CMD here” context menu (current path) ---
New-Item -Path "HKCR:\Directory\shell\cmdhere" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere" -Name "(default)" -Value "Cmd&Here"
New-Item -Path "HKCR:\Directory\shell\cmdhere\command" -Force | Out-Null
Set-ItemProperty -Path "HKCR:\Directory\shell\cmdhere\command" -Name "(default)" -Value "cmd.exe /c start cmd.exe /k pushd `"%V`""

# --- Disable Windows Update service (full) ---
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Set-Service -Name wuauserv -StartupType Disabled

# --- Disable Windows Firewall (all profiles) ---
netsh advfirewall set allprofiles state off | Out-Null

# --- WSL (WSL1 only; no Hyper-V) ---
dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All /NoRestart

# --- Applications via Chocolatey (robust install) ---
$apps = @(
  "googlechrome","7zip.install","bginfo","vlc","git","nodejs-lts","python",
  "openjdk","docker-desktop","vscode","neovim","curl","wget","httpie",
  "notepadplusplus","sysinternals","everything","awscli","azure-cli","kubernetes-cli",
  "google-cloud-sdk","putty","winscp","filezilla","rufus","foxitreader","thunderbird",
  "mremoteng","cmder","x64dbg.portable","ollydbg","powershell-core"
)
foreach ($app in $apps) { Install-ChocoPackage -Id $app }

# --- BGINFO configure ---
$bgExe = "C:\ProgramData\chocolatey\bin\Bginfo64.exe"
$bgDst = "C:\ProgramData\bginfo.bgi"
$bgUrl = "https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/bginfo.bgi"
if (-not (Test-Path $bgDst)) {
    Invoke-WebRequest -Uri $bgUrl -OutFile $bgDst -UseBasicParsing
}
if (Test-Path $bgExe) {
    & $bgExe $bgDst /accepteula /silent /timer:0
}

# --- Disable Microsoft Defender (may be limited by Tamper Protection) ---
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" -Force | Out-Null
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" -Name "NotificationDisabled" -Value 1 -PropertyType DWord -Force | Out-Null
Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
Set-Service -Name WinDefend -StartupType Disabled -ErrorAction SilentlyContinue

# --- Auto logon (set your own credentials) ---
$User = "vagrant"
$Pass = "vagrant"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value 1
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value $User
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value $Pass
Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogonCount -ErrorAction SilentlyContinue

# --- Explorer preferences (current user) ---
$keyAdv = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $keyAdv Hidden 1
Set-ItemProperty $keyAdv HideFileExt 0
Set-ItemProperty $keyAdv ShowSuperHidden 1

# --- Disable legacy IE first run (keys may not exist on Windows 11) ---
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey  = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
foreach ($k in @($AdminKey,$UserKey)) {
    if (Test-Path $k) { New-ItemProperty -Path $k -Name "IsInstalled" -Value 0 -PropertyType DWord -Force | Out-Null }
}
$keyIE = "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main"
if (Test-Path $keyIE) { New-ItemProperty -Path $keyIE -Name "DisableFirstRunCustomize" -Value 1 -PropertyType DWord -Force | Out-Null }

# --- Remove OneDrive (per-machine) ---
$odSetup = Join-Path $env:SystemRoot "System32\OneDriveSetup.exe"
if (Test-Path $odSetup) { Start-Process $odSetup "/uninstall" -Wait | Out-Null }
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSync" -Value 1 -PropertyType DWord -Force | Out-Null

# --- Disable services (exact names) ---
$svcExact = @(
    # Updates/Store
    "wuauserv","UsoSvc","WaaSMedicSvc","DoSvc","BITS","InstallService",
    # Defender/Security
    "WdNisSvc","WinDefend","SecurityHealthService",
    # Telemetry/Diag
    "DiagTrack","dmwappushservice","diagnosticshub.standardcollector.service","WerSvc","RemoteRegistry",
    # Networking
    "SharedAccess","lfsvc","RemoteAccess",
    # RDP
    "TermService","UmRdpService","SessionEnv",
    # Printing/Bluetooth
    "Spooler","PrintNotify","Fax","BTAGService","bthserv","BthHFSrv",
    # Hyper-V/Compute
    "vmms","HvHost","vmcompute","hns",
    # Performance tweaks
    "SysMain"
)
foreach ($s in $svcExact) {
    Write-Output "Disabling service: $s"
    Stop-Service -Name $s -ErrorAction SilentlyContinue
    Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
}

# --- Disable services (wildcards for per-user services) ---
$svcWild = @("OneSyncSvc*","PimIndexMaintenanceSvc*","CDPUserSvc*","DevicesFlowUserSvc*")
foreach ($pattern in $svcWild) {
    Get-Service -Name $pattern -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "Disabling service: $($_.Name)"
        Stop-Service -Name $_.Name -ErrorAction SilentlyContinue
        Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
    }
}

# --- Disable telemetry-related scheduled tasks ---
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
foreach ($t in $tasks) {
    schtasks /Change /TN $t /Disable 2>$null | Out-Null
}

Write-Output "System setup completed. Reboot recommended."
