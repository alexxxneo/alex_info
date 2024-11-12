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
sudo snap install terraform --classic

log "Установка VS Code через snap---------------"
sudo snap install code --classic

log "Установка Ansible через apt---------------"
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible


log "Запись конфигурации в файл .terraformrc----------"
cd
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


# log " Установка Яндекс Браузера------------"
# log "Установка зависимостей..."
# sudo apt install -y wget apt-transport-https

# log "Добавление репозитория Яндекс Браузера..."
# wget -qO - https://yum.yandex.ru/yandex-browser/YANDEX-BROWSER-GPG.KEY | sudo apt-key add -
# echo "deb https://repo.yandex.ru/yandex-browser/debian stable main" | sudo tee /etc/apt/sources.list.d/yandex-browser.list

# log "Обновление списка пакетов снова..."
# sudo apt update

# log "Установка Яндекс Браузера..."
# sudo apt install -y yandex-browser-beta

log "Добавление алиасов"
echo "\
alias lsa="ls -la"\
alias t="terraform"\
alias k="kubectl"\
alias duh="du -h --max-depth=1"\
export YC_TOKEN=$(yc iam create-token)\
export YC_CLOUD_ID=$(yc config get cloud-id)\
export YC_FOLDER_ID=$(yc config get folder-id)" >> .bashrc


log "Установка minikube и kubectl"
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


log "Скрипт завершен успешно."
exit 0

