# Automated - Microsoft Windows 11 - SOE / Template for Proxmox

## Windows 11 for Vibe Codeing

- This is my SOE ( Standard Operating Enviornment) for Windowns 11, that can be built on Proxmox. I use this as a the base for my primary Windows Vine Code Development environment and testing.


### Features 

- Proxmox Build Script
- Install Apps; powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/SOE/ahocolatey.ps1').Content}"
- Setup BIGINFO;powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/main/SOE/biginfo.ps1').Content}"
- NIST DSTIG
- Use Licnese from MSDN Microsoft Windows 11 - Enterprise
- NVidia passthrough
- Tunnnel for remote access and Graphics

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
