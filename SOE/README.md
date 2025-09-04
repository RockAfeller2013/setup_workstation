# Automated - Microsoft Windows 11 - SOE / Template for Proxmox

## Windows 11 for Vibe Codeing

- This is my SOE ( Standard Operating Enviornment) for Windowns 11, that can be built on Proxmox. I use this as a the base for my primary Windows Vine Code Development environment and testing.


### Features 

- Proxmox Build Script - https://www.detectx.com.au/migrate-to-proxmon-ve/#Automated_Windows_Build
- Install Apps; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/SOE/ahocolatey.ps1').Content}"
- Setup BIGINFO; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/bginfo.ps1').Content}"
- Setup Classic Menu; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/classicmenu.ps1').Content}"
- Setup Open-Shell
- Use Licnese from MSDN Microsoft Windows 11 - Enterprise:; https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/kms.ps1
- NIST DSTIG; https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/stig.ps1
- NVidia passthrough
- Tunnnel for remote access and Graphics
- Autologin; https://github.com/RockAfeller2013/setup_workstation/blob/main/SOE/autologin.ps1
- Services; https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/services.ps1
- Setup Icons; https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/setupicons.ps1
- Configuration; https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/config.ps1


## Manual Configs
- Download and Run https://winhance.net/ Manualy 
- Download and Run https://windhawk.net/mods
- Select all and download and run -https://privacy.sexy/
- Download and install https://ninite.com/

#### Manual Install
- Claude Code
- Gemni
- LM Studio (AUR)
- Ollama
- Crush
- Opencode
- OpenGPT

#### Clone
- sysprep /generalize /mode:vm /shutdown
- Make into Proxmox Clone
