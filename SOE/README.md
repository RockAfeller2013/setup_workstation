# Homage - Automated - Microsoft Windows 11 - SOE / Template for Proxmox


This is my Windows 11 Development environment for Vibe coding, I call it Homage, in honour of https://omarchy.org/, it even includes US DOD Windows 11 STIG Secuirty and allot of other tweaks. I also have a Proxmox Helper scroipt to setup https://omarchy.org/ as well!, a true Viber code has Windows, Linux and a Mac OS all at once.. Here comes a Salesforce clone! Lez Go!, I play to put this behind a secure firewall/dmz with everything setup, so that i can invite other developers via Parsec.app and they can't take any code! I can access this remotley and continue my Vibe Coding adventures, from my Mac Laptop.

## Windows 11 for Vibe Codeing

- This is my SOE ( Standard Operating Enviornment) for Windowns 11, that can be built on Proxmox. I use this as a the base for my primary Windows Vibe Code Development environment and testing.


### Features 

- Proxmox Build Script - https://www.detectx.com.au/migrate-to-proxmon-ve/#Automated_Windows_Build
- Disable Defender; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/DefenderDisable.ps1').Content}" 
- Install Apps; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/SOE/ahocolatey.ps1').Content}"
- Setup BIGINFO; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/bginfo.ps1').Content}"
- Setup Open-Shell
- Use Licnese from MSDN Microsoft Windows 11 - Enterprise; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/kms.ps1').Content}" 
- NIST DSTIG; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/stig.ps1').Content}" 
- NVidia passthrough
- Tunnnel for remote access and Graphics
- Autologin; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://github.com/RockAfeller2013/setup_workstation/blob/main/SOE/autologin.ps1').Content}" 
- Services; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/services.ps1').Content}" 
- Setup Icons; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/setupicons.ps1').Content}"
- Configuration; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/config.ps1').Content}"
- Run the setup-vfio.gpu.sh on proxmox (need to update VM ID), then reboot proxmox
- Run the Nvidia Driver installer; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/driverinstall.ps1').Content}"
- Manaually install NVIDIA Drivers
| https://us.download.nvidia.com/Windows/581.15/581.15-desktop-win10-win11-64bit-international-dch-whql.exe"
| https://us.download.nvidia.com/nvapp/client/11.0.5.245/NVIDIA_app_v11.0.5.245.exe"
- Run driveinstall.ps1 to connect z: to NAS


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
