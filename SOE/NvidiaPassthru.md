# NVIDIA GPU Passthrough for Windows 11 on Proxmox

This guide assumes a GTX 980 and Windows 11 VM (ID 1000). It automates blacklisting, VFIO binding, initramfs update, and prepares the VM for GPU passthrough.

---

## 1. Blacklist Conflicting Drivers

Create a file `/etc/modprobe.d/blacklist-nvidia.conf`:

```bash
cat <<EOF > /etc/modprobe.d/blacklist-nvidia.conf
blacklist nouveau
blacklist nvidiafb
blacklist snd_hda_intel
EOF

# 2. Bind GPU and Audio to VFIO
cat <<EOF > /etc/modprobe.d/vfio.conf
options vfio-pci ids=10de:13c0,10de:0fbb disable_vga=1
EOF

echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" >> /etc/modules

# 3. Update Initramfs
update-initramfs -u -k all

# 4. Reboot Host
reboot

# 5. Verify VFIO Binding
lspci -nnk | grep -iA3 nvidia
# Expected output:
# Kernel driver in use: vfio-pci

# 6. Check IOMMU Groups
for d in /sys/kernel/iommu_groups/*/devices/*; do
    echo "Group $(basename $(dirname $d)) : $(lspci -nns $(basename $d))"
done | grep 01:00

# VGA and audio must be in the same group.

# 7. Add GPU and Audio to VM 1000
# Edit /etc/pve/qemu-server/1000.conf or use Proxmox GUI:
hostpci0: 01:00.0,pcie=1
hostpci1: 01:00.1,pcie=1
cpu: host,hidden=1
machine: pc-q35-9.2+pve1

# hostpci0 → GPU
# hostpci1 → GPU audio
# cpu: host,hidden=1 → prevents NVIDIA Error 43

# 8. Start VM
# Boot Windows 11 VM
# Open Device Manager → Display adapters → GPU should appear.

# 9. Install NVIDIA Drivers and App (inside VM)
# Run in PowerShell:
$driverUrl = "https://us.download.nvidia.com/Windows/581.15/581.15-desktop-win10-win11-64bit-international-dch-whql.exe"
$appUrl    = "https://us.download.nvidia.com/nvapp/client/11.0.5.245/NVIDIA_app_v11.0.5.245.exe"
$tempPath  = "C:\Temp"

if (-not (Test-Path $tempPath)) { New-Item -Path $tempPath -ItemType Directory }

$driverPath = Join-Path $tempPath "nvidia-driver.exe"
Invoke-WebRequest $driverUrl -OutFile $driverPath
Start-Process -FilePath $driverPath -ArgumentList "-s" -Wait

$appPath = Join-Path $tempPath "nvidia-app.exe"
Invoke-WebRequest $appUrl -OutFile $appPath
Start-Process -FilePath $appPath -ArgumentList "/S" -Wait

Remove-Item $driverPath, $appPath

