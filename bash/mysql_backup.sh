#!/bin/bash

# Параметры для бэкапа
DB_NAME="my_database"           # Имя базы данных
DB_USER="my_user"               # Имя пользователя базы данных
DB_PASSWORD="my_password"       # Пароль пользователя базы данных
BACKUP_DIR="/path/to/backup"    # Путь к директории для хранения бэкапов
DATE=$(date +"%Y%m%d_%H%M%S")   # Форматируем текущую дату для использования в имени файла

# Проверяем, существует ли директория для бэкапов
if [ ! -d "$BACKUP_DIR" ]; then  # Если директория не существует
    mkdir -p "$BACKUP_DIR"       # Создаем директорию для бэкапов
fi

# Выполняем бэкап базы данных
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > "$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql" # Экспортируем базу данных в SQL файл

# Удаляем бэкапы старше 7 дней
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;  # Находим и удаляем старые бэкапы

# Сообщаем об успешном выполнении
echo "Бэкап базы данных $DB_NAME выполнен успешно и сохранен в $BACKUP_DIR/${DB_NAME}_backup_$DATE.sql" # Выводим сообщение об успешном завершении
