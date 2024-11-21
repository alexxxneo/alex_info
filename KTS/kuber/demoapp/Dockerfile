# Используем node последней версии на базе alpine 
FROM node:alpine AS build-stage

# Устанавливаем рабочую директорию для сборки
WORKDIR /app

# Копируем файл package.json и package-lock.json для установки зависимостей. Отдельно чтобы закешировать слой
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install 

# Копируем весь исходный код в контейнер
COPY . .

# Осуществляем сборку. Результаты попадают в /app/build
RUN npm run build

# CMD ["npm", "start"]

# Второй этап — настройка Nginx
# Используем образ Nginx для создания финального образа
FROM nginx:alpine AS production-stage

WORKDIR /app

# Копируем скомпилированные файлы из этапа сборкиNO
COPY --from=build-stage /app/build /app

# Копируем файл конфигурации Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Указываем команду для запуска Nginx
CMD ["nginx", "-g", "daemon off;"]

