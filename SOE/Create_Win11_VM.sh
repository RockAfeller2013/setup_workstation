# Start fresh
qm destroy 100 --destroy-unreferenced-disks --purge

# Create the base VM
qm create 100 --name "Windows-test" --memory 32000 --cores 4 --sockets 1 --cpu "x86-64-v2-AES" --machine pc-q35-8.0 --bios ovmf --scsihw virtio-scsi-single --agent enabled=1,fstrim_cloned_disks=1 --vga std --tpmstate0 "local-lvm:4,version=v2.0" --numa 1 --ostype win11 --net0 virtio,bridge=vmbr0,firewall=0 --scsi0 local-lvm:100,format=raw,iothread=1,cache=none,discard=on --bootdisk scsi0

# Add EFI disk
qm set 100 --efidisk0 "local-lvm:4,efitype=4m,pre-enrolled-keys=1"

# Attach Windows ISO (bootable)
qm set 100 --cdrom local:iso/Win11_24H2_EnglishInternational_x64.iso

# Attach VirtIO ISO
qm set 100 --ide3 "local:iso/virtio-win.iso,media=cdrom"

# Set boot order (Windows ISO first, then hard disk)
qm set 100 --boot order='ide2;scsi0'

# Allows the VM to use hardware-assisted virtualization (Intel VT-x/AMD-V) This sets the CPU type to emulate the exact same CPU as your Proxmox host
qm set 100 --cpu host --kvm 1

# enable Proxmox tools (QEMU Guest Agent) on VM 100 is:
qm set 100 --agent enabled=1

# Verify the configuration
qm config 100

# Change Boot order after build
# qm set 100 --boot order='scsi0'
