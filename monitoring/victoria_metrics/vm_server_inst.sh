#!/bin/bash

#set -e  # Прекращает выполнение скрипта, если какая-либо команда завершается с ошибкой

set -x # режим отладки - показывает выполнение каждой команды

VM_VERSION="v1.106.0"  # https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.106.0
VM_DIR="/usr/bin"  # Путь для установки бинарного файла
VM_STORAGE="/var/lib/victoria_metrics_data"  # Директория для хранения данных

VM_TMP="/run/victoriametrics "
# VictoriaMetrics может использовать /run/victoriametrics для хранения состояния процесса (например, временные файлы, PID-файлы или сокеты), которые необходимы только во время работы приложения.
# Например, если программа работает в виде демона, она может создать файл PID (идентификатор процесса) в этой папке, чтобы отслеживать свой процесс или взаимодействовать с другими сервисами.

VM_PORT="8428"  # Порт, на котором будет работать VictoriaMetrics
SERVER_BINARY="victoria-metrics-prod"  # Имя бинарного файла сервера


echo "Установка VictoriaMetrics на сервер..."

cd /tmp
wget https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/$VM_VERSION/victoria-metrics-linux-amd64-$VM_VERSION.tar.gz

tar xvfz victoria-metrics-linux-amd64-$VM_VERSION.tar.gz

mv $SERVER_BINARY $VM_DIR


# Создаём директорию для хранения данных, если её нет
mkdir -p $VM_STORAGE
mkdir -p $VM_TMP

# добавляем системного пользователя без возможности логина
useradd -rs /bin/false victoriametrics

# меняем владельца папок для безопасности
chown victoriametrics:victoriametrics $VM_TMP $VM_STORAGE


# Создаём системную службу для VictoriaMetrics
echo "Настройка службы для VictoriaMetrics..."

cat <<EOF> /etc/systemd/system/victoriametrics.service
[Unit]
Description=VictoriaMetrics
After=network.target

[Service]
Type=simple
User=victoriametrics
PIDFile=$VM_TMP/victoriametrics.pid
ExecStart=$VM_DIR/$SERVER_BINARY -storageDataPath $VM_STORAGE -retentionPeriod 12
ExecStop=/bin/kill -s SIGTERM $MAINPID
StartLimitBurst=5
StartLimitInterval=0
Restart=on-failure
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF

# Перезагружаем системные службы, чтобы учесть новую
sudo systemctl daemon-reload

# Включаем автоматический запуск службы при старте системы
sudo systemctl enable victoriametrics

# Запускаем службу
sudo systemctl start victoriametrics

echo "VictoriaMetrics успешно установлена на сервере!"

systemctl status victoriametrics