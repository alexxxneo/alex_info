FROM --platform=linux/amd64 node:alpine AS build-stage

WORKDIR /app

# Копируем файл package.json и package-lock.json для установки зависимостей
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем весь исходный код в контейнер
COPY . .

# Сборка приложения (например, React, Vue или Angular)
RUN npm run build

# Второй этап — настройка Nginx
# Используем образ Nginx для создания финального образа
FROM nginx:alpine AS production-stage

# Метаданные для финального образа
LABEL maintainer="alex@example.com" \
      version="1.0" \
      description="Production-ready Nginx server for serving static files"

# Указываем порт, на котором будет работать Nginx
EXPOSE 80

# Копируем скомпилированные файлы из этапа сборки
COPY --from=build-stage /app/build /usr/share/nginx/html

# Копируем файл конфигурации Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Указываем команду для запуска Nginx
CMD ["nginx", "-g", "daemon off;"]

# Настройка точки монтирования для внешних данных
VOLUME ["/usr/share/nginx/html/data"]

# Добавляем проверку здоровья контейнера
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost || exit 1

# Указываем, что контейнер будет работать от имени пользователя nginx
USER nginx

# Устанавливаем сигнал для безопасной остановки контейнера
STOPSIGNAL SIGTERM

# Настройка shell для выполнения команд (sh для alpine)
SHELL ["/bin/sh", "-c"]