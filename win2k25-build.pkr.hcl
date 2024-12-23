locals {
  SSHUser          = "administrator"
  SSHPass          = "Neverforg3t!"
  vcenter_admin    = "administrator@vsphere.local"
  vcenter_password = "Neverforg3t!"
  timestamp        = regex_replace(timestamp(), "[- TZ:01]", "")
  buildtime        = formatdate("DD-MM-YYYY",timestamp())
  manifest_date    = formatdate("DD-MM-YYYY hh:mm:ss", timestamp())
  
}

# Plug-ins

# Windows Update plug-in
# https://github.com/rgl/packer-plugin-windows-update

packer {
  required_version = ">= 1.9.0"
  required_plugins {
    vsphere = {
      version = ">= v1.4.2"
      source  = "github.com/hashicorp/vsphere"
    }
  }
  required_plugins {
    windows-update = {
      version = ">= 0.16.8"
      source  = "github.com/rgl/windows-update"
    }
  }
}



source "vsphere-iso" "winsrv2025" {
  insecure_connection = true  
  CPUs     = var.vm_cpus
  notes    = "Built by HashiCorp Packer on ${local.buildtime}."
  RAM      = var.vm_memory
  firmware = var.vm_firmware
  # Enable nested hardware virtualization for the virtual machine.
  NestedHV        = true
  RAM_reserve_all = var.vm_memory_reserve_all
  cluster         = var.vcenter_cluster
  configuration_parameters = {
    "devices.hotplug"  = var.vm_hotplug
    "logging"          = var.vm_logging
    "svga.autodetect"  = "FALSE"
    "svga.numDisplays" = "2"
  }
  create_snapshot      = var.create_snapshot
  remove_cdrom         = var.remove_cdrom
  cpu_cores            = var.vm_cores
  datastore            = var.vcenter_datastore
  disk_controller_type = var.vm_disk_controller_type
  floppy_files         = ["${path.root}/setup/"]
  guest_os_type        = var.operating_system_vm
  host                 = var.host
  iso_paths            = [var.winsrv_iso]
  network_adapters {
    network      = var.vcenter_network
    network_card = var.vm_network_card
  }
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin
  }
  username       = local.vcenter_admin
  password       = local.vcenter_password
  vcenter_server = var.vcenter_host
  vm_name        = "${var.name}_${local.buildtime}"
  //vm_version     = var.vm_hardwareversion
  # CPU
  vTPM = var.vm_tpm
  # Enable VBS
  vbs_enabled  = var.vbs_enabled
  vvtd_enabled = var.vvtd_enabled
  # SSH
  communicator              = "ssh"
  ssh_username              = local.SSHUser
  ssh_password              = local.SSHPass
  ssh_timeout               = "2h"
  ssh_clear_authorized_keys = "true"

  // Boot and Provisioning Settings
  boot_order       = var.vm_boot_order
  boot_wait        = var.vm_boot_wait
  boot_command     = var.vm_boot_command
  shutdown_command = var.vm_shutdown_command

  convert_to_template = "true"
}

build {
  sources = ["source.vsphere-iso.winsrv2025"]
 

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }

  provisioner "windows-restart" {
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "20m"
  }


  provisioner "powershell" {
    elevated_user     = local.SSHUser
    elevated_password = local.SSHPass
    inline = [
      "Winget install -e --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements",
      "Winget upgrade --all"
    ]
  }

  provisioner "powershell" {
    elevated_user     = local.SSHUser
    elevated_password = local.SSHPass
    scripts = [
      "./setup/disable-autolog.ps1",
      "./setup/disable-ssh.ps1"
    ]
  }
}