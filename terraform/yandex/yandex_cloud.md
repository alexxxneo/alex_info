# Terraform

Документация  
https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs

Добавить свой ssh ключ
https://center.yandex.cloud/organization/users/ajebs7v29da7tg2c085l/ssh-keys
Заходим в https://center.yandex.cloud/, выбираем пользователя. Вкладка ssh ключи


## Авторизации

Идем по вкладке CLI https://yandex.cloud/ru/docs/tutorials/infrastructure-management/terraform-quickstart#cli_1

1. https://yandex.cloud/ru/docs/cli/quickstart#install  переходим по ссылке в пункте 1.1 и копируем Oauth ключ
2. yc init                                              выбираем 1 в пункте выбора папки по умолчанию
3. ставим Y                                             на шаге Compute zone
4. yc config list                                       чтобы получить все данные для терраформ и копируем их в provider "yandex" {}

5. yc iam service-account create --name terraform       создаем сервисный аккаунт 
6. yc iam service-account list                          Узнаем id созданного нами сервисного аккаунта
7. Создаем сервисный аккаунт в консоли управления  в выбранной папке default  и далее справа сверху "Создать сервисный акк"
8. Заходим в IAM (Idantity and Access Managment), выбираем свой сервисный акк. Создать новый ключ справа сверху, далее создать авторизованный ключ. Скачиваем файл.
9. Берем переменные cloud_id  в разделе Данные аккаунта и folder_id для папки к примеру default в консоле
10. Записываем данные - задаем конфигурацию профиля
``` bash
yc config set service-account-key key.json
yc config set cloud-id <идентификатор_облака>
yc config set folder-id <идентификатор_каталога>
```
11. Добавляем это в переменные окружения в .bashrc

```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

## создание файла терраформ

yc compute image list --folder-id standard-images           выбираем образ ос: 
 fd86t95gnivk955ulbq8 | ubuntu-20-04-lts-v20220509                                 | ubuntu-2004-lts                  
```conf

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
  image_id = "fd86t95gnivk955ulbq8"  # ID образа Ubuntu 22
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

```


## Типы дисков

В Yandex Cloud можно выбрать следующие типы дисков:

1. **network-hdd**  
   - Тип: Сетевой HDD-диск.
   - Назначение: Подходит для хранения данных, где не требуются высокая скорость доступа и низкая задержка. Это более экономичный вариант.
   - Использование: Можно использовать для хранения данных архивного типа, логов и резервных копий.

2. **network-ssd**  
   - Тип: Сетевой SSD-диск.
   - Назначение: Обеспечивает более высокую производительность по сравнению с HDD. Хороший выбор для большинства стандартных задач, требующих более высокой скорости ввода-вывода.
   - Использование: Подходит для баз данных и приложений, требующих быстрой обработки данных.

3. **local-ssd**  
   - Тип: Локальный SSD-диск.
   - Назначение: Диск с самой высокой производительностью, так как подключен непосредственно к хостовой машине.
   - Использование: Идеален для высоконагруженных приложений с интенсивными операциями ввода-вывода (например, базы данных и кэши).
   - Особенность: Данные на локальных дисках не сохраняются при перезагрузке или остановке ВМ, поэтому для хранения критичных данных он менее подходит.