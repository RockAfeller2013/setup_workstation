# Step 1: Inside Windows VM
# Run diskmgmt.msc, shrink C: partition to ≤100 GB
# Shut down VM

# Step 2: On Proxmox host, find disk
qm config <VMID> | grep virtio
qm config <VMID> | grep scsi

# Step 3: Shrink virtual disk to 100 GB
qm resize <VMID> scsi0 100G
# or if virtio:
qm resize <VMID> virtio0 100G

# Step 4: Verify reclaimed space (LVM-thin auto recovers)
lvs

# Step 5: If qcow2 disk on directory storage
qemu-img resize --shrink /path/to/vm-<VMID>-disk-0.qcow2 100G
