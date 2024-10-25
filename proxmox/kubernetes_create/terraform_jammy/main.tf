terraform {
    required_version = ">= 0.13.0"          
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "3.0.1-rc4"           
        }
    }
}

provider "proxmox" {
  pm_api_url = "https://10.10.10.10:8006/api2/json"
  pm_user = "root@pam"
  pm_password = "123123"
  pm_tls_insecure = true                    # Игнорирует ошибки SSL-сертификата при подключении к Proxmox (например, если сертификат самоподписанный).
}
variable "ssh_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0kgn6k1dSJqoKiUXv7qqbS9oLtHptlMK58zZTlU8Dm"

}

# Мастер нода
resource "proxmox_vm_qemu" "kube-master" {
  count = 1                                 # Количество виртуалок
  name = "kuber-master-2${count.index}"     # Имя виртуалки
  target_node = "anderson"                  # Узел Proxmox
  vmid = "12${count.index}"                 # id для виртуальной машины (например, 301).

  clone = "Ubuntu-22-Template"              # Используется существующий шаблон виртуальной машины для клонирования.
  
  agent = 1                         # Включает агент QEMU, который нужен для взаимодействия хоста с гостевой ОС.
  os_type = "cloud-init"            # Указывает тип операционной системы с использованием cloud-init для автоматизации начальной конфигурации.
  cores = 2                         # Количество ядер процессора для виртуальной машины.
  sockets = 1                       # Количество процессоров
  cpu = "host"                      # Устанавливает тип процессора как "host", что даёт виртуальной машине доступ к возможностям CPU хоста.
  memory = 4096                     # Выделяет 4 ГБ оперативной памяти для виртуальной машины.
  scsihw = "virtio-scsi-single"     # Используется контроллер VirtIO SCSI для лучшей производительности диска.
  bootdisk = "scsi0"                # Определяет диск, с которого будет загружаться система (scsi0).
  ciuser      = "ubuntu"            # имя пользователя, которое будет создано в виртуальной машине при помощи cloud-init.
  cipassword  = "123"               # 
  #vm_state = "stopped"             # Cозданиt виртуальной машины в остановленном состоянии.

  disks {                                         # Описание дисков виртуальной машины.
        ide {
            ide2 {
                cloudinit {                       # Указывает, что cloud-init будет использовать диск IDE2.
                    storage = "local-lvm"         # Определяет хранилище для cloud-init в Proxmox.
                }
            }
        }
        virtio {
            virtio0 {                             # Описание основного диска, подключённого через контроллер VirtIO.
                disk {
                   size            = "20G"        # Размер основного диска — 20 ГБ.
                    storage         = "local-lvm" # Хранилище для основного диска в Proxmox.
                    replicate       = false       # Отключает репликацию диска.
                }
            }
        }
    }

  network {                 # Первая сетевая карта для доступа узлов из домашней сети.
    model = "virtio"        # Модель сетевой карты — VirtIO (рекомендуется для лучшей производительности).
    bridge = "vmbr0"        # Подключение к сетевому мосту vmbr0 (основная сеть Proxmox).
  }
  
  network {                 # Вторая сетевая карта. Сеть для подов
    model = "virtio"        # Модель сетевой карты — VirtIO.
    bridge = "vmbr1"        # Подключение к сетевому мосту vmbr1 (дополнительная сеть, например, для внутренней связи).
  }

  lifecycle {
    ignore_changes = [      # Игнорировать изменения конфигурации сети при повторных применениях Terraform.
      network,
    ]
  }

  ipconfig0 = "ip=10.10.10.2${count.index}/24,gw=10.10.10.1"  
                            # Статическая конфигурация для первой сети
  
  ipconfig1 = "ip=192.168.0.2${count.index}/24"
                            # Статическая конфигурация для второй сети (внутренняя сеть).

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}

# Воркер ноды
resource "proxmox_vm_qemu" "kube-worker" { 
  count = 2
  name = "kube-worker-3${count.index}"
  target_node = "anderson"
  vmid = "13${count.index}"

  clone = "Ubuntu-22-Template"

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 4096
  scsihw = "virtio-scsi-single"
  bootdisk = "scsi0"
  ciuser      = "ubuntu" 
  cipassword  = "123"    
  #vm_state = "stopped"

 disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "local-lvm"
                }
            }
        }
        virtio {
            virtio0 {
                disk {
                   size            = "20G"
                    storage         = "local-lvm"
                    replicate       = false
                }
            }
        }
    }


  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  
  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.10.10.3${count.index}/24,gw=10.10.10.1"
  ipconfig1 = "ip=192.168.0.3${count.index}/24"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}