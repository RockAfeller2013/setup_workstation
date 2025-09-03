# Disable Tamper Protection manully; Windows Security > Virus & threat protection > Manage settings > Tamper Protection → switch off manually.

# --- Disable Microsoft Defender via Local Group Policy registry keys ---

# Disable core Defender
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Type DWord

# Disable real-time protection
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableIOAVProtection" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1 -Type DWord

# Disable Defender Security Center notifications
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Name "DisableEnhancedNotifications" -Value 1 -Type DWord

# --- Disable Defender-related services ---
$services = @(
    "WinDefend",     # Microsoft Defender Antivirus Service
    "WdNisSvc",      # Microsoft Defender Antivirus Network Inspection Service
    "Sense",         # Windows Defender Advanced Threat Protection (ATP)
    "SecurityHealthService" # Windows Security Health Service
)

foreach ($svc in $services) {
    Write-Output "Disabling service: $svc"
    Get-Service -Name $svc -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Service $_ -Force -ErrorAction SilentlyContinue
        Set-Service $_ -StartupType Disabled
    }
}

Write-Output "Defender policies applied. Reboot required."
