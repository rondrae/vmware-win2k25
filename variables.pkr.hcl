variable "host" {
  type        = string
  description = "VMware ESXi host"
}

variable "name" {
  type        = string
  description = "Golden Image name"
}

variable "operating_system_vm" {
  type        = string
  description = "OS Guest OS"
}

variable "vcenter_cluster" {
  type        = string
  description = "vCenter cluster name"
}

variable "vcenter_datastore" {
  type        = string
  description = "vSphere datastore"
}

variable "vcenter_host" {
  type        = string
  description = "vCenter Server"
}

variable "vcenter_network" {
  type        = string
  description = "Portgroup name"
}

variable "vm_cores" {
  type        = string
  description = "Amount of cores"
}

variable "vm_cpus" {
  type        = string
  description = "amount of vCPUs"
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "Controller type"
}

variable "vm_disk_size" {
  type        = string
  description = "Harddisk size"
}

variable "vm_disk_thin" {
  type        = string
  description = "Enable/Disable thin provisioning"
}

variable "vm_hardwareversion" {
  type        = string
  description = "VM hardware version"
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. (e.g. 'efi-secure'. 'efi', or 'bios')"
  default     = "efi-secure"
}

variable "vm_cdrom_type" {
  type        = string
  description = "The virtual machine CD-ROM type. (e.g. 'sata', or 'ide')"
  default     = "sata"
}

variable "common_remove_cdrom" {
  type        = bool
  description = "Remove the virtual CD-ROM(s)."
  default     = true
}

variable "vm_hotplug" {
  type        = string
  description = "Enable/Disable hotplug?"
}

variable "vm_logging" {
  type        = string
  description = "Enable/Disable VM Logging"
}

variable "vm_memory" {
  type        = string
  description = "VM Memory"
}

variable "vm_memory_reserve_all" {
  type        = string
  description = "Reserve all memory?"
}

variable "vm_network_card" {
  type        = string
  description = "Networkcard type"
}

variable "winsrv_iso" {
  type        = string
  description = "Windows Server ISO location"
}

variable "vm_vgpu" {
  type        = string
  description = "VM vGPU size"
}

variable "vm_boot_order" {
  type        = string
  description = "The boot order for virtual machines devices. (e.g. 'disk,cdrom')"
  default     = "disk,cdrom"
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot."
}

variable "vm_boot_command" {
  type        = list(string)
  description = "The virtual machine boot command."
  default     = []
}

variable "vm_shutdown_command" {
  type        = string
  description = "Command(s) for guest operating system shutdown."
}

variable "vm_tpm" {
  type    = string
  default = "false"
}

variable "create_snapshot" {
  type = string
}

variable "remove_cdrom" {
  type = string
}

variable "vbs_enabled" {
  type = string
}

variable "vvtd_enabled" {
  type = string
}