


# Обновляем индекс пакетов системы для получения последних версий пакетов
sudo apt-get update -y

# Устанавливаем утилиту для добавления репозиториев PPA (Personal Package Archive)
sudo apt install software-properties-common -y

# Добавляем репозиторий PPA для установки более новой версии Python (в данном случае - Python 3.11)
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Повторно обновляем индекс пакетов, чтобы включить пакеты из добавленного репозитория PPA
sudo apt-get update -y

# Устанавливаем Git, pip и Python 3.11. Git нужен для клонирования репозитория Kubespray, а pip - для установки Python-библиотек
sudo apt-get install git pip python3.11 -y


curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.11
python3.11 -m venv ~/kubespray-venv
source ~/kubespray-venv/bin/activate
pip install ansible==2.17.0
# Скачиваем скрипт для установки последней версии pip (используется для управления пакетами Python)

# Устанавливаем pip для Python 3.11, чтобы затем использовать его для установки зависимостей Kubespray
#python3.11 get-pip.py






# Клонируем репозиторий Kubespray с GitHub. Kubespray - это набор Ansible-плейбуков для автоматизированной установки Kubernetes.
git clone https://github.com/kubernetes-sigs/kubespray.git

# Переходим в директорию kubespray
cd kubespray/

# Устанавливаем зависимости Kubespray, указанные в файле requirements.txt, используя pip для Python 3.11
pip3.11 install -r requirements.txt

# Дополнительно устанавливаем библиотеку ruamel.yaml, которая может потребоваться для работы с YAML-файлами в Ansible
python3.11 -m pip install ruamel.yaml

# Копируем шаблонный инвентарь "sample" в новую директорию "mycluster"
# Этот инвентарь будет использоваться для конфигурации нашего Kubernetes кластера
cp -rfp inventory/sample inventory/mycluster

# Определяем массив IP-адресов для узлов кластера
# Эти IP-адреса будут использоваться для построения Ansible-инвентаря с помощью скрипта inventory_builder
declare -a IPS=(10.10.10.20 10.10.10.30 10.10.10.31)

# Запускаем скрипт inventory_builder для создания файла hosts.yaml с конфигурацией узлов кластера
# CONFIG_FILE указывает на файл, в который будет записан инвентарь, а ${IPS[@]} передает IP-адреса узлов в скрипт
CONFIG_FILE=inventory/mycluster/hosts.yaml python3.11 contrib/inventory_builder/inventory.py ${IPS[@]}


# Должен получиться такой примерно инвентори yaml. В него незабываем добавить нужного пользователя:
# vars:
#    ansible_user: ubuntu

all:
  hosts:
    node1:
      ansible_host: 10.10.10.20
      ip: 10.10.10.20
      access_ip: 10.10.10.20
    node2:
      ansible_host: 10.10.10.30
      ip: 10.10.10.30
      access_ip: 10.10.10.30
    node3:
      ansible_host: 10.10.10.31
      ip: 10.10.10.31
      access_ip: 10.10.10.31
  vars:
    ansible_user: ubuntu
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}


# Копируем приватный SSH-ключ на Ansible-хост
# Это нужно для того, чтобы Ansible мог подключаться к узлам кластера без пароля
# Замените yc-user@158.160.110.13 на ваш действительный адрес и путь к SSH-ключу
scp -i ~/.ssh/yandex ubuntu@158.160.110.13:.ssh/id_rsa ~/.ssh/

# Устанавливаем права доступа 600 на приватный ключ, чтобы он мог использоваться только текущим пользователем
sudo chmod 600 ~/.ssh/id_rsa



# Запускаем Ansible-плейбук для установки Kubernetes кластера
# Плейбук cluster.yml выполняет все необходимые шаги для установки и настройки Kubernetes
# Флаг -i указывает путь к инвентарю, -b - включает привилегии sudo, -v - увеличивает уровень детализации вывода
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v

# Создаем директорию для конфигурации kubectl (инструмента для управления Kubernetes)
mkdir ~/.kube

# Копируем файл конфигурации Kubernetes, чтобы kubectl мог управлять кластером от имени текущего пользователя
# Этот файл содержит настройки подключения к кластеру
sudo cp /etc/kubernetes/admin.conf ~/.kube/config

# Меняем владельца файла конфигурации kubectl на текущего пользователя
# Это необходимо, чтобы пользователь имел права на доступ к файлу конфигурации
sudo chown $(id -u):$(id -g) ~/.kube/config

