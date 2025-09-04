# TaskbarShortcuts.ps1
# Creates Shutdown, Reboot, PowerShell, and PowerShell ISE taskbar icons with matching system icons

$Shell = New-Object -ComObject WScript.Shell
$Desktop = [Environment]::GetFolderPath("Desktop")

# --- Shutdown shortcut ---
$ShutdownLnk = Join-Path $Desktop "Shutdown.lnk"
$Shutdown = $Shell.CreateShortcut($ShutdownLnk)
$Shutdown.TargetPath = "shutdown.exe"
$Shutdown.Arguments = "/s /t 0"
$Shutdown.IconLocation = "shell32.dll,27"   # Power button icon
$Shutdown.Save()

# --- Reboot shortcut ---
$RebootLnk = Join-Path $Desktop "Reboot.lnk"
$Reboot = $Shell.CreateShortcut($RebootLnk)
$Reboot.TargetPath = "shutdown.exe"
$Reboot.Arguments = "/r /t 0"
$Reboot.IconLocation = "shell32.dll,176"   # Restart arrows icon
$Reboot.Save()

# --- PowerShell shortcut ---
$PSLnk = Join-Path $Desktop "PowerShell.lnk"
$PowerShell = $Shell.CreateShortcut($PSLnk)
$PowerShell.TargetPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe"
$PowerShell.IconLocation = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe,0"
$PowerShell.Save()

# --- PowerShell ISE shortcut ---
$ISELnk = Join-Path $Desktop "PowerShell ISE.lnk"
$PowerShellISE = $Shell.CreateShortcut($ISELnk)
$PowerShellISE.TargetPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell_ise.exe"
$PowerShellISE.IconLocation = "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell_ise.exe,0"
$PowerShellISE.Save()

# --- Pin shortcuts to taskbar ---
$VerbPin = "Pin to Tas&kbar"
$ShellApp = New-Object -ComObject Shell.Application

foreach ($Shortcut in @($ShutdownLnk, $RebootLnk, $PSLnk, $ISELnk)) {
    $Item = $ShellApp.Namespace((Split-Path $Shortcut)).ParseName((Split-Path $Shortcut -Leaf))
    foreach ($Verb in $Item.Verbs()) {
        if ($Verb.Name -eq $VerbPin) {
            $Verb.DoIt()
        }
    }
}
