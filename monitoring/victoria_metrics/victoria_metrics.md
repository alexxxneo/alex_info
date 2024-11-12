

# Скрипт установки на сервер

```bash
#!/bin/bash

set -e  # Прекращает выполнение скрипта, если какая-либо команда завершается с ошибкой

# Задаём переменные
VM_VERSION="v1.106.0"  # https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v1.106.0
VM_DIR="/usr/bin/"  # Путь для установки бинарного файла
VM_STORAGE="/var/lib/victoria-metrics-data"  # Директория для хранения данных
VM_PORT="8428"  # Порт, на котором будет работать VictoriaMetrics
SERVER_BINARY="victoria-metrics-prod"  # Имя бинарного файла сервера

echo "Установка VictoriaMetrics на сервер..."

# Создаём директорию для хранения данных, если её нет
sudo mkdir -p $VM_STORAGE

# Создаём директорию для бинарного файла, если её нет
sudo mkdir -p $VM_DIR

# Скачиваем архив с бинарным файлом VictoriaMetrics
wget "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/$VM_VERSION/victoria-metrics-amd64-$VM_VERSION.tar.gz" -O /tmp/victoria-metrics.tar.gz

# Распаковываем архив
tar -xzvf /tmp/victoria-metrics.tar.gz -C /tmp

# Перемещаем бинарный файл в целевую директорию
sudo mv /tmp/$SERVER_BINARY $VM_DIR

# Создаём системную службу для VictoriaMetrics
echo "Настройка службы для VictoriaMetrics..."
sudo bash -c "cat > /etc/systemd/system/victoria-metrics.service" <<EOF
[Unit]
Description=VictoriaMetrics  # Описание службы
After=network.target  # Запуск службы после настройки сети

[Service]
ExecStart=$VM_DIR/$SERVER_BINARY -storageDataPath=$VM_STORAGE -retentionPeriod=3 -httpListenAddr=:${VM_PORT}  # Команда запуска VictoriaMetrics
Restart=always  # Перезапуск службы при сбоях

[Install]
WantedBy=multi-user.target  # Служба будет запущена в стандартном многопользовательском режиме
EOF

# Перезагружаем системные службы, чтобы учесть новую
sudo systemctl daemon-reload

# Включаем автоматический запуск службы при старте системы
sudo systemctl enable victoria-metrics

# Запускаем службу
sudo systemctl start victoria-metrics

echo "VictoriaMetrics успешно установлена на сервере!"

```

## Подробнее о systemd юните 


### [Unit]
```ini
[Unit]
Description=VictoriaMetrics
After=network.target
```

- **`[Unit]`**: Этот раздел содержит общую информацию о сервисе.
  
- **`Description=VictoriaMetrics`**: Описание сервиса. Это строка, которая описывает, что делает данный сервис (в данном случае — это сервис VictoriaMetrics).

- **`After=network.target`**: Определяет, что сервис VictoriaMetrics должен запускаться **после того, как будет доступна сеть**. `network.target` — это целевая точка, которая указывает, что система должна начать работать с сетью (например, сетевые интерфейсы должны быть настроены). Это важно для сервисов, которые требуют сетевого подключения.

---

### [Service]
```ini
[Service]
Type=simple
User=victoriametrics
PIDFile=/run/victoriametrics/victoriametrics.pid
ExecStart=/usr/local/bin/victoria-metrics-prod -storageDataPath /var/lib/victoriametrics -retentionPeriod 12
ExecStop=/bin/kill -s SIGTERM $MAINPID
StartLimitBurst=5
StartLimitInterval=0
Restart=on-failure
RestartSec=1
```

- **`[Service]`**: Этот раздел описывает, как сервис будет работать в системе, а также параметры его работы.

- **`Type=simple`**: Указывает, что сервис запускается сразу, и `systemd` будет считать его активным, как только он будет запущен. Для VictoriaMetrics это означает, что нет необходимости ожидать, пока процесс установит дополнительные соединения или откроет порты — как только процесс будет запущен, он считается активным.

- **`User=victoriametrics`**: Указывает, что сервис будет выполняться от имени пользователя `victoriametrics`. Этот пользователь был создан ранее, чтобы изолировать процесс VictoriaMetrics и повысить безопасность.

- **`PIDFile=/run/victoriametrics/victoriametrics.pid`**: Указывает, что файл с **идентификатором процесса (PID)** будет храниться в `/run/victoriametrics/victoriametrics.pid`. Это нужно для того, чтобы `systemd` мог отслеживать, какой процесс является основным для этого сервиса. Обычно PID-файл используется для управления процессом (например, для остановки сервиса).

- **`ExecStart=/usr/local/bin/victoria-metrics-prod -storageDataPath /var/lib/victoriametrics -retentionPeriod 12`**: Указывает команду, которая будет выполнена для запуска сервиса. В данном случае это запуск программы **VictoriaMetrics** с аргументами:
  - **`-storageDataPath /var/lib/victoriametrics`** — путь, где будут храниться данные базы данных VictoriaMetrics.
  - **`-retentionPeriod 12`** — период хранения данных (в данном случае 12 месяцев). Это означает, что старые данные будут удаляться через 12 месяцев.

- **`ExecStop=/bin/kill -s SIGTERM $MAINPID`**: Определяет команду для корректной остановки сервиса. В данном случае используется команда `kill`, которая отправляет сигнал **SIGTERM** основному процессу сервиса (`$MAINPID` — это переменная, которая указывает на PID запущенного процесса). Сигнал SIGTERM используется для аккуратного завершения работы процесса.

- **`StartLimitBurst=5`**: Указывает максимальное количество попыток запуска сервиса, которое разрешено за короткий период времени. Если сервис не запускается 5 раз подряд, `systemd` считает, что возникла проблема.

- **`StartLimitInterval=0`**: Этот параметр задает интервал в секундах, в течение которого будет отслеживаться количество попыток запуска сервиса. Здесь `0` означает, что интервал не ограничен, и `StartLimitBurst` применяется к попыткам запуска без ограничения времени.

- **`Restart=on-failure`**: Определяет, что сервис будет автоматически перезапущен, если он завершится с ошибкой. Система будет пытаться перезапустить сервис, если он завершится с ненулевым кодом выхода (ошибкой). Если процесс завершится нормально (с кодом 0), перезапуск не будет происходить.

- **`RestartSec=1`**: Указывает, сколько секунд `systemd` должен подождать перед тем, как попытаться перезапустить сервис. В данном случае — 1 секунда.

---

### [Install]
```ini
[Install]
WantedBy=multi-user.target
```

- **`[Install]`**: Этот раздел описывает, как и когда сервис должен быть активирован.

- **`WantedBy=multi-user.target`**: Этот параметр указывает, что сервис должен быть включен при загрузке системы, в момент достижения целевой точки **`multi-user.target`**, которая соответствует многопользовательскому режиму работы системы (когда сеть доступна и система готова к работе). Это стандартная цель для большинства сервисов, которые должны запускаться в операционной системе.

---

### Итоговое объяснение:

Этот файл юнита описывает, как управлять сервисом **VictoriaMetrics** с помощью `systemd`. Вот что делает каждый раздел:

1. **[Unit]**: Содержит описание и информацию о том, когда сервис должен быть запущен (после того, как будет доступна сеть).
2. **[Service]**: Описывает параметры самого сервиса:
   - Путь к исполнимому файлу для запуска;
   - Команды для запуска и остановки сервиса;
   - Опции для перезапуска при сбоях.
3. **[Install]**: Указывает, что сервис должен запускаться при загрузке системы, когда достигается многопользовательский режим.

Этот юнит позволяет `systemd` управлять сервисом VictoriaMetrics: запускать, останавливать, перезапускать его, а также гарантировать, что он будет работать после перезагрузки системы.