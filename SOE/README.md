# Homage - Automated - Microsoft Windows 11 - SOE / Template for Proxmox

This is my Windows 11 development environment for Vibe coding, which I call Homage, in honor of [Omarchy](https://omarchy.org/). It even includes US DoD Windows 11 STIG security and a lot of other tweaks. I also have a Proxmox helper script to set up Omarchy as well! A true Viber code environment with Windows, Linux, and macOS all at once. Here comes a Salesforce clone, Lez Go!

I plan to put this behind a secure firewall/DMZ with everything configured so I can invite other developers via Parsec.app without them being able to access or steal any code. I can also access this remotely and continue my Vibe coding adventures from my Mac laptop. THe reason for this, I do am interested in allot of different things and some of them only run on specific operating systems, so this, why, I have virtulized, Linux, Windows, MacOS and even iOS for testing. I am running all of this on a single workstation, nowdays CPU, and M.2 is so fast and cheap. I have about 20 machines all at once and don't even have any performacne issues. cray cray.

## Windows 11 for Vibe Codeing

This is my SOE (Standard Operating Environment) for Windows 11, which can be built on Proxmox. I use this as the base for my primary Windows Vibe code development environment and testing.

## Download Windows 11 Enterprise ISO

You have to download Windows 11 Entperise ISO from your https://my.visualstudio.com/, it works better and networking works, otherwise you need to do the following;

### Workarond download

- https://massgrave.dev/windows_11_links
- https://licendi.com/en/blog/download-windows-11-enterprise-iso-file/

### Download Windows 11 ISO - Offical

- Open Google Chrome in Developer Mode, Change the Responsive to iPad Pro, then download the full ISO from - https://www.microsoft.com/en-au/software-download/windows11
- Use this method to download the ISO - https://www.majorgeeks.com/content/page/how_to_download_the_latest_windows_10_iso_images_directly_in_google_chrome.html
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019
- https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016

## Proxmox Windows Configuration and Setup

- Windows VirtIO Drivers - https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#:~:text=download%20the%20latest%20stable
- Windows 11 guest best practices - https://pve.proxmox.com/wiki/Windows_VirtIO_Drivers#:~:text=download%20the%20latest%20stable
- Windows 2022 guest best practices - https://pve.proxmox.com/wiki/Windows_2022_guest_best_practices
- How to install Win11 in Proxmox | Quick guide | And fix problems of network search - https://forum.proxmox.com/threads/how-to-install-win11-in-proxmox-quick-guide-and-fix-problems-of-network-search.136596/
- Paravirtualized Block Drivers for Windows - https://pve.proxmox.com/wiki/Paravirtualized_Block_Drivers_for_Windows
- Windows 11 VM (Best Performance) - https://forum.proxmox.com/threads/windows-11-vm-best-performance.135614/
- How to install Win11 in Proxmox | Quick guide | And fix problems of network search - https://forum.proxmox.com/threads/how-to-install-win11-in-proxmox-quick-guide-and-fix-problems-of-network-search.136596/

VirtIO provides better performance in virtualized environments. SATA and Realtek work without extra drivers but add emulation overhead, which slows performance. VirtIO is purpose-built for VMs, so disk and network I/O are much faster. If you can install the drivers, the performance gain is worth it.
- Automated Installation - https://pve.proxmox.com/wiki/Automated_Installation




'''
VM Configuration Requirements

Processor: 1 gigahertz (GHz) or faster with 2 or more cores on a compatible 64-bit processor or system on a chip (SoC). 
RAM: 4 GB or more. 
Storage: A storage device with 64 GB or larger capacity. 
System Firmware: Unified Extensible Firmware Interface (UEFI) and Secure Boot capable. 
TPM: Trusted Platform Module (TPM) version 2.0. 
Graphics Card: DirectX 12 compatible graphics / WDDM 2.x. 
Internet Connection: An internet connection is necessary for updates, setup, and to utilize certain features. 
Microsoft Account:


'''
1. CPU: host: qm set <vmid> --cpu host - Required for WSL
3. Start the VM: 
4. Connect via noVNC or SPICE console
5. Skip license 
6. During Windows installation:
   - When prompted for storage drivers, click 'Load driver'
   - Browse to the VirtIO CD-ROM → D:\amd64\w11
   - Select the 'Red Hat VirtIO SCSI controller' driver and Click Next 
   - NETWORK ISSUES - https://learn.microsoft.com/en-us/answers/questions/2350856/set-up-windows-11-without-internet-oobebypassnro?forum=insider-all&referrer=answers
   - FN + SHIFT + F10
   - oobe\bypassnro
   - dont enter password, setup one later for RDP
   - after login install drivers from D:\netkvm\win11\amd64
7. After installation:
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
