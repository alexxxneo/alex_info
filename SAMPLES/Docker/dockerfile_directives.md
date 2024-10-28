Конечно! Вот список директив для `Dockerfile` в формате, аналогичном предыдущим ответам:

### Основные директивы `Dockerfile`

1. **FROM** – указывает базовый образ для нового образа.
2. **ARG** – задает переменные, которые могут быть переданы на этапе сборки.
3. **LABEL** – добавляет метаданные к образу, такие как автор или версия.
4. **RUN** – выполняет команду на этапе сборки и добавляет её результат в образ.
5. **CMD** – задает команду, выполняемую при запуске контейнера (переопределяется `docker run`).
6. **ENTRYPOINT** – определяет основную команду для контейнера (не переопределяется `docker run`).
7. **ENV** – задает переменные окружения, доступные в контейнере.
8. **EXPOSE** – указывает на порты, которые контейнер слушает в процессе работы.
9. **WORKDIR** – задает рабочую директорию для команд `RUN`, `CMD`, `ENTRYPOINT`, `COPY` и `ADD`.
10. **COPY** – копирует файлы и каталоги из контекста сборки в образ.
11. **ADD** – копирует файлы и каталоги, а также может извлекать архивы и загружать файлы по URL.
12. **VOLUME** – создает точку монтирования для внешнего тома.
13. **USER** – указывает пользователя для выполнения команд.
14. **ONBUILD** – задает инструкции, которые будут выполнены при создании образов на основе текущего.
15. **STOPSIGNAL** – задает сигнал для остановки контейнера (например, `SIGTERM`).
16. **HEALTHCHECK** – задает проверку здоровья контейнера с командой и интервалами.
17. **SHELL** – задает командный интерпретатор для выполнения команд, таких как `RUN`.

### Директивы с параметрами и дополнительными возможностями

18. **FROM <image> AS <name>** – позволяет создавать этапы сборки и использовать multi-stage build.
19. **ARG <name>=<default>** – объявляет аргумент с возможностью задать значение по умолчанию.
20. **LABEL <key>=<value> <key>=<value>** – позволяет использовать несколько меток одновременно.
21. **RUN <command>** – выполняет команду в `/bin/sh` (или в другом интерпретаторе, заданном через `SHELL`).
22. **CMD ["executable", "param1", "param2"]** – задает команду в формате JSON.
23. **ENTRYPOINT ["executable", "param1", "param2"]** – задает команду в формате JSON.
24. **ENV <key>=<value>** – позволяет объявить одну или несколько переменных окружения.
25. **EXPOSE <port>** – позволяет указывать несколько портов, разделяя их пробелом.
26. **WORKDIR <directory>** – позволяет создавать подкаталоги, если они не существуют.
27. **COPY <src> <dest>** – копирует файлы из контекста сборки, поддерживает `--chown=user:group`.
28. **ADD <src> <dest>** – копирует файлы, может использоваться для извлечения архивов.
29. **VOLUME ["/data"]** – задает том в формате JSON для поддержки множества точек монтирования.
30. **USER <user>** – позволяет задавать пользователя и группу, например, `USER user:group`.

### Продвинутые директивы и их особенности

31. **HEALTHCHECK --interval=30s --timeout=5s CMD <command>** – задает интервал и таймаут для проверки здоровья.
32. **ONBUILD RUN <command>** – выполняет команду при использовании образа как базового.
33. **ONBUILD COPY <src> <dest>** – копирует файлы при создании дочернего образа.
34. **SHELL ["powershell", "-Command"]** – задает командный интерпретатор для команд, кроме `CMD` и `ENTRYPOINT`.
35. **ARG VERSION** – позволяет использовать аргумент в других директивах, например, `RUN apt-get install -y mypackage=$VERSION`.
36. **RUN apt-get update && apt-get install -y curl** – комбинация нескольких команд в `RUN` для сокращения слоев.
37. **RUN --mount=type=cache,target=/path** – позволяет использовать кеш для улучшения производительности.
38. **RUN --mount=type=secret,id=my_secret** – подключает секретные данные в команду `RUN`.
39. **ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"** – позволяет изменять переменные окружения.
40. **VOLUME /data /logs** – указывает несколько точек монтирования одновременно.

### Дополнительные параметры для управления сборкой

41. **COPY --chown=user:group src dest** – копирует файлы с указанием владельца и группы.
42. **ADD --chown=user:group src dest** – добавляет файлы с указанием владельца и группы.
43. **HEALTHCHECK NONE** – отключает проверки здоровья для образа.
44. **CMD ["-D", "FOREGROUND"]** – добавляет параметры к команде `CMD`.
45. **ENTRYPOINT exec "$0" "$@"** – позволяет использовать `ENTRYPOINT` как шаблон для выполнения команд.
46. **ENV NODE_ENV=production** – задает переменные окружения для настройки приложений.
47. **USER 1001** – указывает UID для выполнения команд.
48. **WORKDIR /app/subdir** – задает подкаталог как рабочую директорию.
49. **LABEL version="1.0" description="Docker image"** – добавляет описание и версию.
50. **HEALTHCHECK --start-period=10s CMD curl -f http://localhost || exit 1** – задает команду и стартовый период для проверки здоровья.


Пример с использованием node для запуска приложения

```dockerfile
# Указываем первый этап сборки с именем "build-stage" и базовым образом
# На этом этапе собирается исходный код приложения
FROM node:18 AS build-stage

# Определяем переменную сборки для версии приложения
ARG VERSION=1.0.0

# Добавляем метаданные об образе, такие как автор и версия
LABEL maintainer="alex@example.com" \
      version="$VERSION" \
      description="Multi-stage build example for a Node.js application"

# Устанавливаем рабочую директорию для сборки
WORKDIR /app

# Копируем package.json и package-lock.json для установки зависимостей
COPY package*.json ./

# Устанавливаем переменные окружения для конфигурации установки зависимостей
ENV NODE_ENV=production \
    PATH="/app/node_modules/.bin:$PATH"

# Устанавливаем зависимости
RUN npm install --no-cache

# Копируем весь исходный код в контейнер
COPY . .

# Сборка проекта
RUN npm run build

# Второй этап, использующий multistage build для создания оптимизированного образа
FROM node:18-alpine AS production-stage

# Переменная сборки для минимизации временных файлов
ARG CLEANUP=true

# Метаданные для финального образа
LABEL maintainer="alex@example.com" \
      version="$VERSION" \
      stage="production" \
      description="Production-ready Node.js application"

# Указываем порт, на котором работает наше приложение
EXPOSE 3000

# Устанавливаем рабочую директорию для финального образа
WORKDIR /app

# Копируем только необходимые файлы из стадии сборки "build-stage"
COPY --from=build-stage /app/build /app/build
COPY --from=build-stage /app/package.json /app/package.json

# Настраиваем команду для запуска приложения по умолчанию
CMD ["node", "build/server.js"]

# Включаем точку монтирования для внешних данных
VOLUME ["/app/data"]

# Добавляем проверку здоровья контейнера
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000 || exit 1

# Указываем пользователя, от имени которого будет работать приложение
USER node

# Оптимизация для очистки временных файлов
RUN if [ "$CLEANUP" = "true" ]; then \
        rm -rf /tmp/* && echo "Cleanup complete"; \
    fi

# Устанавливаем сигнал для безопасной остановки контейнера
STOPSIGNAL SIGTERM

# Настройка shell для выполнения команд (sh для alpine)
SHELL ["/bin/sh", "-c"]


```

Пример с использованием nginx для запуска приложения

```dockerfile
# Первый этап — сборка приложения
# Используем образ Node.js для сборки статических файлов
FROM node:18 AS build-stage

# Устанавливаем рабочую директорию для сборки
WORKDIR /app

# Копируем файл package.json и package-lock.json для установки зависимостей
COPY package*.json ./

# Устанавливаем переменные окружения
ENV NODE_ENV=production

# Устанавливаем зависимости
RUN npm install --no-cache

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

```