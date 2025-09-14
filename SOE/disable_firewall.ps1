# Disable Windows Firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Verify firewall status
Get-NetFirewallProfile | Format-Table Name, Enabled

# Optional: Disable Windows Firewall service completely
Stop-Service -Name "mpssvc" -Force
Set-Service -Name "mpssvc" -StartupType Disabled
