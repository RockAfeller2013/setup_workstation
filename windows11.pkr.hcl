variable "iso_path" {
  default = "windows11.iso"
}

variable "autounattend_path" {
  default = "autounattend.xml"
}

source "vmware-iso" "windows11" {
  iso_url           = var.iso_path
  iso_checksum      = "none"

  communicator      = "winrm"
  winrm_username    = "vagrant"
  winrm_password    = "vagrant"

  boot_wait         = "5s"
  boot_command      = [
    "<tab><enter>"
  ]

  shutdown_command  = "shutdown /s /t 10"

  floppy_files      = [
    var.autounattend_path
  ]

  vmx_data = {
    "memsize"      = "8192"
    "numvcpus"     = "4"
    "firmware"     = "efi"
    "vhv.enable"   = "TRUE"
  }
}

build {
  sources = ["source.vmware-iso.windows11"]
  post-processors {
    output = "windows11.box"
  }
}
