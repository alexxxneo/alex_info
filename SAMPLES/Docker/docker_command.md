
Добавление зеркала для docker hub

cat << EOF | sudo tee -a /etc/docker/daemon.json
{ "registry-mirrors" : [ "https://cr.yandex/mirror", "https://c.163.com" ] }
EOF

# частые

+ docker build -t sambia-app -f _docker/app/gitlab/Dockerfile .  
+ docker run --name=smb-container -d --rm sambia-app 
+ docker exec -it smb-container bash
+ docker stop smb-container

+ docker compose -f docker-compose.dev.test.yml up -d  
+ docker exec -it sambia_app bash
+ docker compose -f docker-compose.dev.test.yml down --volumes --rmi all
+ docker run --name=smb -d --rm sambia-app 
+ 
+ docker compose build                       перебилдить  образ снова в docker compose
+ docker compose logs -f                     просмотр логов
+ docker-compose down --volumes --rmi all    Остановка и удаление всех контейнеров, сетей, томов и образов, созданных в docker-compose
+ docker-compose down --volumes              Удаление томов при остановке контейнеров (если тома создавались через compose)

+ docker-compose rm                          Удаление только контейнеров (не трогая сети, тома и образы)



# Prune

# Основные команды `prune`
1. `docker system prune` – удалить неиспользуемые контейнеры, образы, сети и кеши (спросит подтверждение).
2. `docker system prune -f` – принудительно удалить неиспользуемые ресурсы без запроса подтверждения.
3. `docker system prune --volumes` – удалить неиспользуемые ресурсы и тома.
4. `docker container prune` – удалить все остановленные контейнеры.
5. `docker container prune -f` – принудительно удалить все остановленные контейнеры.
6. `docker image prune` – удалить неиспользуемые образы.
7. `docker image prune -a` – удалить все образы, не используемые ни одним контейнером.
8. `docker image prune -f` – принудительно удалить неиспользуемые образы.
9. `docker volume prune` – удалить неиспользуемые тома.
10. `docker volume prune -f` – принудительно удалить неиспользуемые тома.
11. `docker network prune` – удалить неиспользуемые сети.
12. `docker network prune -f` – принудительно удалить неиспользуемые сети.
13. ` docker system prune -a -f` очистка всех НЕИСПОЛЬЗУЕМЫХ ресурсов, включая образы, сети, тома 


# Команды `prune` с фильтрами
13. `docker system prune --filter "until=24h"` – удалить ресурсы, не используемые более 24 часов.
14. `docker system prune --filter "label!=keep"` – удалить ресурсы, не помеченные меткой `keep`.
15. `docker container prune --filter "until=1h"` – удалить контейнеры, не используемые более 1 часа.
16. `docker container prune --filter "label=temporary"` – удалить контейнеры с меткой `temporary`.
17. `docker image prune --filter "dangling=true"` – удалить только "висячие" (dangling) образы.
18. `docker image prune --filter "until=48h"` – удалить образы, не используемые более 48 часов.
19. `docker image prune --filter "label!=essential"` – удалить образы, не имеющие метки `essential`.
20. `docker volume prune --filter "label=temp_volume"` – удалить тома с меткой `temp_volume`.
21. `docker volume prune --filter "until=12h"` – удалить тома, не использовавшиеся более 12 часов.
22. `docker network prune --filter "until=24h"` – удалить сети, не использовавшиеся более 24 часов.
23. `docker network prune --filter "label!=persistent"` – удалить сети, не помеченные меткой `persistent`.

# Комбинированные команды `prune`
24. `docker system prune -a` – удалить неиспользуемые ресурсы, включая все неиспользуемые образы.
25. `docker system prune --filter "label!=keep" --volumes` – удалить ресурсы и тома, не помеченные меткой `keep`.
26. `docker image prune -a --filter "label=stale"` – удалить все образы с меткой `stale`.
27. `docker container prune --filter "status=exited"` – удалить только остановленные контейнеры со статусом `exited`.
28. `docker network prune --filter "driver=bridge"` – удалить все неиспользуемые сети, использующие драйвер `bridge`.
29. `docker volume prune --filter "label!=backup"` – удалить неиспользуемые тома, не имеющие метки `backup`.
30. `docker system prune -a --filter "until=72h" --volumes` – удалить ресурсы, неиспользуемые более 72 часов, включая тома.

# Основные команды Docker
1. `docker version` – показать версию Docker.
2. `docker info` – отобразить информацию о Docker.
3. `docker --help` – вывести список всех команд и их описание.
4. `docker login` – войти в Docker Registry.
5. `docker logout` – выйти из Docker Registry.
6. `docker search <image>` – поиск образа в Docker Hub.
7. `docker pull <image>` – загрузить образ из Docker Hub.
8. `docker push <image>` – отправить образ в Docker Registry.
9. `docker build -t <image_name>:<tag> <path>` – собрать образ из Dockerfile.
10. `docker images` – отобразить список всех образов.

# Работа с контейнерами
11. `docker ps` – показать запущенные контейнеры.
12. `docker ps -a` – показать все контейнеры.
13. `docker run <image>` – запустить контейнер из образа.
14. `docker run -d <image>` – запустить контейнер в фоновом режиме.
15. `docker run -it <image>` – запустить контейнер в интерактивном режиме.
16. `docker run --name <container_name> <image>` – запустить контейнер с определённым именем.
17. `docker start <container_name>` – запустить остановленный контейнер.
18. `docker stop <container_name>` – остановить контейнер.
19. `docker restart <container_name>` – перезапустить контейнер.
20. `docker kill <container_name>` – принудительно остановить контейнер.

# Управление контейнерами
21. `docker rm <container_name>` – удалить контейнер.
22. `docker rm -f <container_name>` – принудительно удалить контейнер.
23. `docker rename <old_name> <new_name>` – переименовать контейнер.
24. `docker inspect <container_name>` – показать полную информацию о контейнере.
25. `docker top <container_name>` – отобразить процессы в контейнере.
26. `docker logs <container_name>` – показать логи контейнера.
27. `docker logs -f <container_name>` – следить за логами контейнера.
28. `docker exec -it <container_name> <command>` – выполнить команду в запущенном контейнере.
29. `docker attach <container_name>` – подключиться к запущенному контейнеру.
30. `docker cp <container_name>:/path /local_path` – скопировать файл из контейнера на хост.

# Управление образами
31. `docker rmi <image>` – удалить образ.
32. `docker rmi -f <image>` – принудительно удалить образ.
33. `docker tag <source_image> <target_image>` – создать новый тег для образа.
34. `docker history <image>` – показать историю слоев образа.
35. `docker inspect <image>` – отобразить метаданные образа.
36. `docker save -o <filename.tar> <image>` – сохранить образ в файл.
37. `docker load -i <filename.tar>` – загрузить образ из файла.
38. `docker image prune` – удалить неиспользуемые образы.
39. `docker image ls` – показать все образы.
40. `docker image inspect <image>` – вывести подробную информацию об образе.

# Работа с Docker Volumes
41. `docker volume create <volume_name>` – создать volume.
42. `docker volume rm <volume_name>` – удалить volume.
43. `docker volume inspect <volume_name>` – показать информацию о volume.
44. `docker volume ls` – показать все volumes.
45. `docker volume prune` – удалить неиспользуемые volumes.
46. `docker run -v <volume_name>:/path <image>` – подключить volume к контейнеру.
47. `docker volume create --name <volume_name> --driver <driver>` – создать volume с указанием драйвера.
48. `docker volume create --label <label>=<value> <volume_name>` – создать volume с меткой.
49. `docker volume create --opt <option>=<value> <volume_name>` – создать volume с опциями.
50. `docker run --mount source=<volume_name>,target=<path> <image>` – монтировать volume через `--mount`.

# Работа с сетями
51. `docker network create <network_name>` – создать сеть.
52. `docker network rm <network_name>` – удалить сеть.
53. `docker network inspect <network_name>` – отобразить информацию о сети.
54. `docker network ls` – показать все сети.
55. `docker network connect <network_name> <container_name>` – подключить контейнер к сети.
56. `docker network disconnect <network_name> <container_name>` – отключить контейнер от сети.
57. `docker run --network <network_name> <image>` – запустить контейнер в определённой сети.
58. `docker network prune` – удалить неиспользуемые сети.
59. `docker network create --driver bridge <network_name>` – создать сеть с драйвером bridge.
60. `docker network create --subnet <subnet> <network_name>` – создать сеть с определённым подсетью.

# Контейнеры и сети
61. `docker inspect -f '{{.NetworkSettings.IPAddress}}' <container_name>` – узнать IP контейнера.
62. `docker exec -it <container_name> ifconfig` – узнать сетевую конфигурацию контейнера.
63. `docker network connect <network_name> <container_name>` – присоединить контейнер к сети.
64. `docker run --link <container_name>:alias <image>` – связать контейнеры с помощью alias.
65. `docker run --net host <image>` – запустить контейнер с сетью хоста.
66. `docker run --net none <image>` – запустить контейнер без сетевого интерфейса.
67. `docker network inspect bridge` – показать информацию о bridge-сети.
68. `docker run --dns <dns_server> <image>` – задать DNS-сервер для контейнера.
69. `docker-compose up` – поднять все сервисы, определённые в `docker-compose.yml`.
70. `docker-compose down` – остановить и удалить контейнеры, сети и тома, определённые в `docker-compose.yml`.

# Docker Compose
71. `docker-compose up -d` – запустить все сервисы в фоновом режиме.
72. `docker-compose ps` – показать статус всех контейнеров.
73. `docker-compose logs` – показать логи всех сервисов.
74. `docker-compose logs -f` – следить за логами всех сервисов.
75. `docker-compose exec <service_name> <command>` – выполнить команду в сервисе.
76. `docker-compose build` – собрать образы, определённые в `docker-compose.yml`.
77. `docker-compose stop` – остановить сервисы.
78. `docker-compose start` – запустить остановленные сервисы.
79. `docker-compose restart` – перезапустить сервисы.
80. `docker-compose pull` – загрузить образы, определённые в `docker-compose.yml`.

# Docker Swarm
81. `docker swarm init` – инициализировать Docker Swarm.
82. `docker swarm join` – присоединить узел к Docker Swarm.
83. `docker swarm leave` – выйти из Docker Swarm.
84. `docker node ls` – показать все узлы Swarm.
85. `docker node rm <node>` – удалить узел из Swarm.
86. `docker service create --name <service_name> <image>` – создать сервис.
87. `docker service ls` – показать все сервисы.
88. `docker service scale <service_name>=<replicas>` – задать количество реплик для сервиса.
89. `docker service update <service_name>` – обновить настройки сервиса.
90. `docker stack deploy -c <file>.yml <stack_name>` – запустить стек Docker.

# Обновление и управление сервисами
91. `docker service logs <service_name>` – отобразить логи сервиса.
92. `docker service ps <service_name>` – показать задачи, связанные с сервисом.
93. `docker service rm <service_name>` – удалить сервис.
94. `docker stack services <stack_name>` – показать сервисы в стеке.
95. `docker stack rm <stack_name>` – удалить стек.
96. `docker service inspect <service_name>` – отобразить информацию о сервисе.
97. `docker node promote <node>` – повысить узел до менеджера.
98. `docker node demote <node>` – понизить узел до рабочего.
99. `docker node inspect <node>` – отобразить информацию о узле.
100. `docker node update --availability active <node>` – обновить доступность узла.

---
