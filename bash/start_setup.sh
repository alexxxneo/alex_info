#!/bin/bash

# Функция для вывода сообщений
function log {
  echo "[INFO] $(date +'%Y-%m-%d %H:%M:%S') - $1"
}


log "Изменение раскладки клавиатуры на Alt+Shift-------------"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"  
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"

log "Установка git---------------"
sudo apt install -y git

log "Установка Terraform через snap---------------"
sudo snap install -y terraform --classic

log "Установка VS Code через snap---------------"
sudo snap install -y code --classic

log "Установка Ansible через apt---------------"
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible


log "Запись конфигурации в файл .terraformrc----------"
cat <<EOF > .terraformrc
provider_installation {
  network_mirror {
    url     = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF


log "Установка Anydesk---------------"
sudo wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install -y anydesk
sudo apt install -y libcanberra-gtk-module libcanberra-gtk3-module

log "Установка Docker---------"

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER


log " Установка Яндекс Браузера------------"
log "Установка зависимостей..."
sudo apt install -y wget apt-transport-https

log "Добавление репозитория Яндекс Браузера..."
wget -qO - https://yum.yandex.ru/yandex-browser/YANDEX-BROWSER-GPG.KEY | sudo apt-key add -
echo "deb https://repo.yandex.ru/yandex-browser/debian stable main" | sudo tee /etc/apt/sources.list.d/yandex-browser.list

log "Обновление списка пакетов снова..."
sudo apt update

log "Установка Яндекс Браузера..."
sudo apt install -y yandex-browser-beta

log "Скрипт завершен успешно."
exit 0

