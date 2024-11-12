# Установка Prometheus на двух машинах с Ubuntu 24, где одна из них будет также использоваться в качестве веб-сервера NGINX

`sudo systemctl daemon-reload`
 `sudo systemctl restart prometheus.service ` перезапуск сервиса прометеуса


### Выолняем скрипт автоматической установки prometheus на сервере
Выполнять скрипт с повышенными правами sudo
```bash
#!/bin/bash

PROMETHEUS_VERSION="3.0.0-rc.0"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"

cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
tar xvfz prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz
cd prometheus-$PROMETHEUS_VERSION.linux-amd64

mv prometheus /usr/bin/
rm -rf /tmp/prometheus*

mkdir -p $PROMETHEUS_FOLDER_CONFIG
mkdir -p $PROMETHEUS_FOLDER_TSDATA


cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name      : "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

useradd -rs /bin/false prometheus
chown prometheus:prometheus /usr/bin/prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_TSDATA


cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
  --config.file       ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
  --storage.tsdb.path ${PROMETHEUS_FOLDER_TSDATA}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus --no-pager
prometheus --version
```


#### Этот же скрипт с комментариями
```bash
#!/bin/bash  # Задает интерпретатор Bash для выполнения скрипта

PROMETHEUS_VERSION="3.0.0-rc.0"  # Версия Prometheus, которую нужно установить
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"  # Путь к директории для конфигурации Prometheus
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"  # Путь к директории для хранения данных Prometheus

cd /tmp  # Переходит в временную директорию /tmp
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz  # Загружает архив Prometheus с GitHub
tar xvfz prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz  # Распаковывает архив с Prometheus
cd prometheus-$PROMETHEUS_VERSION.linux-amd64  # Переходит в распакованную директорию Prometheus

mv prometheus /usr/bin/  # Перемещает бинарный файл prometheus в /usr/bin для глобального доступа
rm -rf /tmp/prometheus*  # Удаляет загруженные файлы Prometheus из /tmp

mkdir -p $PROMETHEUS_FOLDER_CONFIG  # Создает директорию для конфигурации Prometheus, если она не существует
mkdir -p $PROMETHEUS_FOLDER_TSDATA  # Создает директорию для хранения данных Prometheus, если она не существует

# Создает файл конфигурации prometheus.yml с базовыми настройками
cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
  scrape_interval: 15s  # Интервал сбора метрик (15 секунд)

scrape_configs:
  - job_name      : "prometheus"  # Название задания для сбора метрик
    static_configs:
      - targets: ["localhost:9090"]  # Адрес целевого узла (Prometheus сам себя мониторит)
EOF

useradd -rs /bin/false prometheus  # Создает системного пользователя prometheus с ограниченным доступом (без shell)
chown prometheus:prometheus /usr/bin/prometheus  # Устанавливает права на /usr/bin/prometheus для пользователя prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG  # Устанавливает права на директорию конфигурации для пользователя prometheus
chown prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG/prometheus.yml  # Устанавливает права на конфигурационный файл prometheus.yml
chown prometheus:prometheus $PROMETHEUS_FOLDER_TSDATA  # Устанавливает права на директорию для данных

# Создает файл службы systemd для автоматического запуска Prometheus
cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server  # Описание службы
After=network.target  # Зависимость от сети (запуск после сетевых служб)

[Service]
User=prometheus  # Пользователь для запуска службы
Group=prometheus  # Группа для запуска службы
Type=simple  # Тип службы — simple (запускается как одиночный процесс)
Restart=on-failure  # Перезапуск службы в случае ошибки
ExecStart=/usr/bin/prometheus \  # Команда запуска Prometheus с указанием конфигурации и пути к данным
  --config.file       ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
  --storage.tsdb.path ${PROMETHEUS_FOLDER_TSDATA}

[Install]
WantedBy=multi-user.target  # Позволяет запускать службу на уровне multi-user
EOF

systemctl daemon-reload  # Перезагружает настройки systemd для применения изменений
systemctl start prometheus  # Запускает службу Prometheus
systemctl enable prometheus  # Включает автозапуск службы Prometheus при загрузке системы
systemctl status prometheus --no-pager  # Показывает статус службы без разбиения на страницы
prometheus --version  # Проверяет и выводит текущую установленную версию Prometheus

```






















```bash

PROMETHEUS_VERSION="3.0.0-rc.0"
PROMETHEUS_FOLDER_CONFIG="/etc/prometheus"
PROMETHEUS_FOLDER_TSDATA="/etc/prometheus/data"

# apt update
# apt install -y curl wget # если нет

cd /tmp

wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz # Скачиваем последнюю версию с https://prometheus.io/download/
tar xvf prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz   распаковываем 
# x — извлечение файлов из архива (разархивирование).
# v — выводит подробную информацию о каждом извлекаемом файле (verbose), полезно для контроля процесса.
# f — указывает файл-архив, с которым нужно работать (prometheus-3.0.0-rc.0.linux-amd64.tar.gz).
cd prometheus-$PROMETHEUS_VERSION.linux-amd64

mv prometheus /usr/bin/ # устанавливаем
rm -rf /tmp/prometheus* # удаляем ненужное


mkdir -p $PROMETHEUS_FOLDER_CONFIG
mkdir -p $PROMETHEUS_FOLDER_TSDATA 


cat <<EOF> $PROMETHEUS_FOLDER_CONFIG/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['10.10.10.41:9090']

  - job_name: 'nginx'
    static_configs:
      - targets: ['10.10.10.42:9113']
EOF 


useradd -rs /bin/false prometheus # создаем системного пользователя prometheus с ограниченными правами без домашней директории, без логина 
# -r — создаёт системного пользователя (UID ниже 1000), который не будет виден в списке обычных пользователей.
# -s /bin/false — устанавливает оболочку /bin/false, предотвращая возможность входа под этим пользователем.
# Таким образом, пользователь prometheus не сможет выполнять команды напрямую и используется только для фоновых служб или приложений.


# Устанавливаем права доступа
chown -R prometheus:prometheus $PROMETHEUS_FOLDER_CONFIG
chown prometheus:prometheus $PROMETHEUS_FOLDER_TSDATA


# Создаем юнит для автозагрузки прометеуса
cat <<EOF> /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
ExecStart=/usr/bin/prometheus \
    --config.file          ${PROMETHEUS_FOLDER_CONFIG}/prometheus.yml \
    --storage.tsdb.path    ${PROMETHEUS_FOLDER_TSDATA}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl status prometheus --no-pager
prometheus --version
```








### Добавляем target сервера в prometheus.yml

редактируем /etc/prometheus/prometheus.yml
```yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name      : "prometheus"
    static_configs:
      - targets: ["10.10.10.41:9090"]

  - job_name      :  "ubuntu-servers"
    static_configs: 
      - targets: 
          - 10.10.10.42:9100  
          - 10.10.10.43:9100  
```

### Установка node-exporter на target сервера

```bash
#!/bin/bash
# https://prometheus.io/download/
# https://github.com/prometheus/node_exporter/releases
NODE_EXPORTER_VERSION="1.8.2"

cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
tar xvfz node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
cd node_exporter-$NODE_EXPORTER_VERSION.linux-amd64

mv node_exporter /usr/bin/
rm -rf /tmp/node_exporter*

useradd -rs /bin/false node_exporter
chown node_exporter:node_exporter /usr/bin/node_exporter


cat <<EOF> /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
systemctl status node_exporter
node_exporter --version

```



























### Шаг 4: Установка Node Exporter на обеих машинах
Для мониторинга системных метрик на обеих машинах установим Node Exporter.

1. **Скачайте Node Exporter**:
   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
   ```

2. **Распакуйте архив и переместите файлы**:
   ```bash
   tar xvf node_exporter-1.6.1.linux-amd64.tar.gz
    mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
   ```

3. **Создайте системный юнит для Node Exporter**:
   ```bash
    tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
   [Unit]
   Description=Node Exporter
   Wants=network-online.target
   After=network-online.target

   [Service]
   User=prometheus
   ExecStart=/usr/local/bin/node_exporter

   [Install]
   WantedBy=default.target
   EOF
   ```

4. **Запустите и включите Node Exporter**:
   ```bash
    systemctl daemon-reload
    systemctl start node_exporter
    systemctl enable node_exporter
   ```

### Шаг 5: Установка NGINX и экспортер NGINX
На второй машине установите NGINX и NGINX Exporter.

1. **Установите NGINX**:
   ```bash
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
   ```

2. **Скачайте и настройте NGINX Exporter**:
   ```bash
   wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
   tar xvf nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
    mv nginx-prometheus-exporter /usr/local/bin/
   ```

3. **Создайте системный юнит для NGINX Exporter**:
   ```bash
    tee /etc/systemd/system/nginx_exporter.service > /dev/null <<EOF
   [Unit]
   Description=NGINX Exporter
   Wants=network-online.target
   After=network-online.target

   [Service]
   ExecStart=/usr/local/bin/nginx-prometheus-exporter -nginx.scrape-uri=http://localhost:8080/stub_status
   User=prometheus

   [Install]
   WantedBy=default.target
   EOF
   ```

4. **Настройте и включите endpoint** в конфигурации NGINX:
   ```bash
    tee /etc/nginx/conf.d/stub_status.conf > /dev/null <<EOF
   server {
       listen 8080;
       location /stub_status {
           stub_status;
           allow 127.0.0.1;
           deny all;
       }
   }
   EOF
   ```

   Перезапустите NGINX:
   ```bash
    systemctl restart nginx
   ```

5. **Запустите и включите NGINX Exporter**:
   ```bash
    systemctl daemon-reload
    systemctl start nginx_exporter
    systemctl enable nginx_exporter
   ```

### Шаг 6: Запуск и проверка Prometheus
1. На первой машине создайте системный юнит для Prometheus:
   ```bash
    tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
   [Unit]
   Description=Prometheus Monitoring
   Wants=network-online.target
   After=network-online.target

   [Service]
   User=prometheus
   ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/

   [Install]
   WantedBy=default.target
   EOF
   ```

2. **Запустите и включите Prometheus**:
   ```bash
    systemctl daemon-reload
    systemctl start prometheus
    systemctl enable prometheus
   ```

3. **Проверьте, работает ли Prometheus**:
   Откройте браузер и перейдите по адресу `http://<IP-адрес первой машины>:9090`. Вы должны увидеть интерфейс Prometheus.



   Unit для автозагрузки prometheus

   ```conf
[Unit]
Description=Prometheus Server                  # Описание службы для удобства идентификации
After=network.target                     # Задает порядок запуска, чтобы Prometheus запускался после сети

[Service]
User=prometheus                                 # Указывает, что служба будет запускаться от пользователя prometheus
Group=prometheus                                # Указывает группу, от имени которой будет работать служба
Type=simple                                     # Тип службы: простой, без дополнительных процессов или разветвлений
Restart=on-failure                              # Автоматически перезапускает службу, если произошел сбой
ExecStart=/usr/bin/prometheus \                 # Основная команда для запуска Prometheus, указана с полным путём
    --config.file          /etc/prometheus/prometheus.yml \  # Путь к конфигурационному файлу Prometheus
    --storage.tsdb.path    /etc/prometheus/data             # Путь к каталогу, где Prometheus будет хранить данные

[Install]
WantedBy=multi-user.target                      # Определяет целевую группу для запуска при старте системы, здесь — многопользовательский режим
   ```