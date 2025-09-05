#!/bin/bash
# Run this inside Proxmox to detect Nvidia and set the corresponding VM with GPU Passthrough, request Proxmox reboot.
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/RockAfeller2013/setup_workstation/refs/heads/main/SOE/setup-vfio-gpu.sh)"
set -e

VMID=1000
VM_CONF="/etc/pve/qemu-server/${VMID}.conf"

# Detect NVIDIA GPU PCI IDs
GPU_IDS=($(lspci -nn | grep -i nvidia | grep -Eo '^[0-9a-f:.]+' | tr -d '\n'))
if [ ${#GPU_IDS[@]} -eq 0 ]; then
    echo "No NVIDIA GPU detected."
    exit 1
fi

GPU_PCI=${GPU_IDS[0]}
AUDIO_PCI=${GPU_IDS[1]}

echo "Detected NVIDIA GPU: $GPU_PCI"
echo "Detected NVIDIA Audio: $AUDIO_PCI"

# Bind to VFIO
NVIDIA_IDS=$(lspci -nn | grep -i nvidia | grep -Eo '\[....:....\]' | tr -d '[]' | tr '\n' | sed 's/ /,/g')
echo "options vfio-pci ids=${NVIDIA_IDS} disable_vga=1" > /etc/modprobe.d/vfio.conf

# Blacklist default drivers
cat >/etc/modprobe.d/blacklist-nvidia.conf <<EOF
blacklist nouveau
blacklist nvidia
blacklist nvidiafb
EOF

update-initramfs -u -k all
echo "VFIO binding updated. Reboot required."

# Backup VM config
cp $VM_CONF ${VM_CONF}.bak

# Add GPU passthrough
sed -i '/^hostpci0:/d' $VM_CONF
sed -i '/^hostpci1:/d' $VM_CONF
echo "hostpci0: ${GPU_PCI},pcie=1" >> $VM_CONF
echo "hostpci1: ${AUDIO_PCI},pcie=1" >> $VM_CONF

# Set CPU to host,hidden=1
if grep -q "^cpu:" $VM_CONF; then
    sed -i "s/^cpu:.*/cpu: host,hidden=1/" $VM_CONF
else
    echo "cpu: host,hidden=1" >> $VM_CONF
fi

# Ensure machine type q35
if ! grep -q "^machine:" $VM_CONF; then
    echo "machine: pc-q35-7.2" >> $VM_CONF
fi

echo "GPU passthrough configured for VM $VMID with Error 43 prevention."
