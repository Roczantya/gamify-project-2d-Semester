resource "proxmox_lxc" "homelab_container" {
  # Looping: Membuat jumlah container sesuai variabel container_count
  count = var.container_count

  target_node  = var.target_node
  hostname     = "ubuntu-lab-${count.index + 1}" # Nama akan jadi ubuntu-lab-1, ubuntu-lab-2, dst.
  vmid         = 204 + count.index              # ID akan mulai dari 150, 151, dst.
  ostemplate   = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged = true
  start        = true

  # Spesifikasi Resource
  cores  = 1
  memory = 512 # Dalam MB

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = dhcp
  }# Bisa diatur statis jika diperlukan
}
