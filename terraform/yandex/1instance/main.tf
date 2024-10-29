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

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"       # Название диска, которое будет видно в Yandex Cloud
  type     = "network-hdd"       # Тип диска; network-hdd - сетевой HDD-диск
  size     = "20"                # Размер диска в гигабайтах
  image_id = "f2ecv4ak2tq0v77ljn4b"  # ID образа Ubuntu 24
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"            # Имя виртуальной машины в Yandex Cloud

  resources {
    cores  = 2                   # Количество виртуальных процессоров
    memory = 2                   # Объем оперативной памяти в гигабайтах
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id         # Подключаем ранее созданный диск как загрузочный
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id            # Указываем подсеть, к которой будет подключен интерфейс
    nat       = true                                     # Включаем NAT для выхода в интернет
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}" # Подключаем публичный SSH-ключ для доступа к ВМ
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"                                      # Имя сети для группировки ресурсов в Yandex Cloud
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"                             # Имя подсети
  network_id     = yandex_vpc_network.network-1.id       # Привязка подсети к созданной ранее сети
  v4_cidr_blocks = ["192.168.10.0/24"]                   # Указываем диапазон IP-адресов для подсети в формате CIDR
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address  # Вывод внутреннего IP адреса ВМ
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address  # Вывод внешнего IP адреса ВМ
}
