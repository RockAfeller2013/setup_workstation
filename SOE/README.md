# Homage - Automated - Microsoft Windows 11 - SOE / Template for Proxmox

This is my Windows 11 development environment for Vibe coding, which I call Homage, in honor of [Omarchy](https://omarchy.org/). It even includes US DoD Windows 11 STIG security and a lot of other tweaks. I also have a Proxmox helper script to set up Omarchy as well! A true Viber code environment with Windows, Linux, and macOS all at once. Here comes a Salesforce clone, Lez Go!

I plan to put this behind a secure firewall/DMZ with everything configured so I can invite other developers via Parsec.app without them being able to access or steal any code. I can also access this remotely and continue my Vibe coding adventures from my Mac laptop. THe reason for this, I do am interested in allot of different things and some of them only run on specific operating systems, so this, why, I have virtulized, Linux, Windows, MacOS and even iOS for testing. I am running all of this on a single workstation, nowdays CPU, and M.2 is so fast and cheap. I have about 20 machines all at once and don't even have any performacne issues. cray cray.

## Windows 11 for Vibe Codeing

This is my SOE (Standard Operating Environment) for Windows 11, which can be built on Proxmox. I use this as the base for my primary Windows Vibe code development environment and testing.

## Download Windows 11 Enterprise ISO

- Use this method to download the ISO - https://www.majorgeeks.com/content/page/how_to_download_the_latest_windows_10_iso_images_directly_in_google_chrome.html
- https://massgrave.dev/windows_11_links
- https://licendi.com/en/blog/download-windows-11-enterprise-iso-file/
- Windows VirtIO Drivers - https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#:~:text=download%20the%20latest%20stable
- Windows 11 guest best practices - https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#:~:text=download%20the%20latest%20stable
- Windows 2022 guest best practices - https://pve.proxmox.com/wiki/Windows_2022_guest_best_practices

### Download Windows 11 ISO - Offical

- Open Google Chrome in Developer Mode, Change the Responsive to iPad Pro, then download the full ISO from - https://www.microsoft.com/en-au/software-download/windows11
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016

## Proxmox Windows Configuration and Setup

1. CPU: host
2. Start the VM: 
3. Connect via noVNC or SPICE console
4. Skip license 
5. During Windows installation:
   - When prompted for storage drivers, click 'Load driver'
   - Browse to the VirtIO CD-ROM → D:\amd64\w11
   - Select the 'Red Hat VirtIO SCSI controller' driver
   - NETWORK ISSUES - https://learn.microsoft.com/en-us/answers/questions/2350856/set-up-windows-11-without-internet-oobebypassnro?forum=insider-all&referrer=answers
   - FN + SHIFT + F10
   - oobe\bypassnro
   - dont enter password, setup one later for RDP
   - after login install drivers from D:\netkvm\win11\amd64
6. After installation:
   - Install remaining VirtIO drivers from the virtio-win.iso
   - Change display adapter to 'virtio-gpu' in VM hardware settings
   - Install QEMU guest agent for better integration

Note: Windows 11 requires TPM 2.0 and Secure Boot, which are both enabled in this configuration.
### Features 


- Proxmox Build Script - https://www.detectx.com.au/migrate-to-proxmon-ve/#Automated_Windows_Build
- Install VirtIO Drivers - https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/
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
