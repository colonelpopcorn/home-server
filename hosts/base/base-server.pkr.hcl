packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

variables {
  headless = false
}

locals {
  ubuntu_focal_dl_folder        = "http://www.releases.ubuntu.com/focal/"
  ubuntu_focal_iso_url          = "${local.ubuntu_focal_dl_folder}ubuntu-20.04.4-live-server-amd64.iso"
  ubuntu_focal_iso_checksum_url = "${local.ubuntu_focal_dl_folder}SHA256SUMS"
  source = {
    language     = "English"
    country      = "United States"
    locale       = "en_US"
    keyboard     = "us"
    vm_name      = "base-server"
    vm_domain    = "linghome.net"
    mirror       = "us.archive.ubuntu.com"
    ssh_password = "jlingtest22*.."
    ssh_username = "root"

    timezone            = "America/New_York"
    system_clock_in_utc = true
    ssh_key             = file("${path.root}/.ssh/id_rsa")
  }
}

source "virtualbox-iso" "base" {
  headless = var.headless

  iso_url      = local.ubuntu_focal_iso_url
  iso_checksum = "file:${local.ubuntu_focal_iso_checksum_url}"

  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  ssh_wait_timeout     = "15m"
  ssh_password         = "${local.source.ssh_password}"
  ssh_username         = "${local.source.ssh_username}"
  boot_wait            = "3s"
  memory               = "2048"
  cpus                 = "2"
  gfx_vram_size        = "64"
  http_content = {
    "/preseed.cfg" = templatefile("${path.root}/preseed.pkrtpl", local.source)
  }
  shutdown_command = "echo '${local.source.ssh_password}'|sudo -S shutdown -P now"

  boot_command = [
    "<enter><enter><f6><esc><wait> ",
    "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter><wait>"
    // "c",
    // "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;seedfrom=http://{{.HTTPIP}}:{{.HTTPPort}}/' net.ifnames=0 ",
    // "<enter><wait>",
    // "initrd /casper/initrd<enter><wait>",
    // "boot<enter>"
  ]

  output_directory = "virtualbox_iso_ubuntu_2022_amd64"
}

build {
  sources     = ["source.virtualbox-iso.base"]
  name        = "test_base"
  description = <<EOF
This build creates images for :
* Ubuntu 20.04
For the following builders :
* virtualbox-iso
It will create base images with:
* SSH key-based auth
* Automated apt updates
EOF
  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/vagrant"]
    execute_command   = "echo '${local.source.ssh_password}' | {{.Vars}} sudo -S -E sh -eux '{{.Path}}'"
    expect_disconnect = true
    inline = [
      "echo hello from the ${source.name} image",
      "${source.name} version"
    ]
  }



}
