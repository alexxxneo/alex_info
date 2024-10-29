terraform {
  required_providers {
    yandex = {                        
      source = "yandex-cloud/yandex"  
      version = "0.131.0" 
    }
  }
}

provider "yandex" {
  token     = var.token 
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_disk" "boot_disk" {
  count    = 2                     # Количество дисков
  name     = "boot-disk-${count.index + 1}"  # Уникальное название для каждого диска
  type     = "network-hdd"
  size     = "20"
  image_id = "f2ecv4ak2tq0v77ljn4b"  # ID образа Ubuntu 24
}

resource "yandex_compute_instance" "vm" {
  count = 2                         # Количество инстансов
  name  = "terraform${count.index + 1}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk[count.index].id  # Привязываем соответствующий диск
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_addresses" {
  value = [for instance in yandex_compute_instance.vm : instance.network_interface.0.ip_address]
}

output "external_ip_addresses" {
  value = [for instance in yandex_compute_instance.vm : instance.network_interface.0.nat_ip_address]
}
