

# KUBERNETES

# Архитектура

Разберем основные составляющие кластера Kubernetes:
 + Node — это узлы кластера. Их мы абстрагируем от пользователя. В каждой ноде может быть некоторое количество ядер, CPU и так далее. Но здесь важно, что на каждом из этих node запущен агент — Kubelet.
 + Kubelet общается с сервером, который называется API-сервер. Через него происходит всё общение с Kubernetes-кластером. Это обычный HTTP API.
Задача этого API-сервера — отвечать на запросы. Например, мы можем запросить задеплоить приложение или показать логи конкретного контейнера.
+ Scheduler — отвечает за планирование полезной нагрузки, которую мы собираемся задеплоить. Например, нужно задеплоить три реплики приложения. Задача scheduler — найти ноды, которые будут удовлетворять потребностям этого деплоя.
В деплое может быть указано нужное количества CPU и памяти. Так scheduler может понять, где более свободная и менее нагруженная нода, и задеплоить в нее приложение. То есть scheduler выбирает ноду и пишет это в базу данных + + etsd. А kubulet периодически спрашивает, не нужно ли нам что-то задеплоить на свои ноды. Если есть такая потребность, то он деплоит.
+ Controller-Manager (c-m) — следит, чтобы в кластере была та нагрузка, которая должна быть задеплоена.
Допустим, нужно задеплоить три реплики, но какой-то из узлов отказал. Например, Api-сервер перестал получать обновления с kubelet. В этом случае ноды считаются выбывшими из кластера и нужно передеплоить всю нагрузку оттуда по всему остальному кластеру. Controller-manager следит, чтобы в каждом деплойменте было нужное количество реплик.
+ Cloud-Controller-Manager (c-c-m) — обычно связан с облачными Kubernetes-кластерами. Задача этого компонента — связываться с облачным API.
Обычно у нас в облаке есть облачные ресурсы, например, Volume, дисковые пространства. Чтобы их создать, нужно создать ресурс Kubernetes. Он пойдет общаться с Cloud-Controller-Manager, выпишет этот ресурс в облаке и отдаст его нам. Подробнее об этом мы поговорим в других уроках данного курса.
etcd — это key-value базы данных. Она используется для хранения всего, что мы деплоим в Kubernetes.




## Типы узлов в Kubernetes
Обычно все перечисленные компоненты находятся на узлах, которые называются master-узлы. Кратко повторим их:
+ API-сервер — выполняет любые операции над кластером
+ Scheduler — выполняет планирование ресурсов по узлам кластера
+ Controller-Manager — следит за состоянием кластера
+ Cloud-Controller-Manager — управляет облачными ресурсами
+ etcd — хранит состояние всех объектов кластера
+ Coredns/kube-dns — это dns-сервер, с помощью которого мы можем использовать имена серверов для поиска нашей нагрузки. Подробнее об этом компоненте поговорим в 3 главе курса
Кастомную нагрузку вроде нашего приложения чаще всего деплоят на worker-узлы:
+ Kubelet – ожидает команд от controller-manager и запускает поды
+ Kube-proxy – формирует правила маршрутизации трафика между всеми ресурсами кластера. Подробнее об этом компоненте поговорим в третьей главе курса
Если мы выбираем некое облачное решение в Kubernetes, облачный провайдер даст выбрать тип master- и worker-узлов. Если у нас небольшой кластер, то нам и не понадобятся большие сложные узлы


# Объекты, сущности

Стандартные абстракции над Pod
ReplicaSet
Запускает несколько подов.
DaemonSet
Запускает строго один под на каждом узле кластера. Это нужно для деплоя системных компонентов, например, системный сбор логов. Еще для системы мониторинга узлов кластера. Нам их нужно запустить на каждом узле кластера.
Если поднять новую ноду и добавить ее в кластере, то kubernetes знает, что добавилась новая нода. В итоге поды DaemonSet запустятся автоматически. Это может быть удобно для деплоя собственных приложений.
StatefullSet
Запускает нумерованные поды для stateful-приложений. Отличается от обычного ReplicaSet тем, что поды именовались как угодно. В StatefullSet поды именуются по номерам, например — StatefullSet-0. Это позволяет создавать деплои приложения StatefullSet.
Можно представить базу данных, в которой должно быть запущено три реплики. Одна из них master, другие две — slave. И нельзя чтобы они перепутались. У каждого из этих подов есть volume. И у каждого из них есть данные, которые он хранит. Если pod перезапустится, нужно чтобы он подключился обратно к своему же volume. Нельзя, чтобы они перемещались, поэтому они нумеруются.
Подробнее об этом поговорим в шестой главе.
Job
Запускается под один раз, пока он не завершится успешно. Это возможность запустить какую-то эдхок-задачу, например, запуск миграции.
CronJob
Запускает Job по крону. Это конфигурация того, в какой момент выполнит ту или иную задачу. И CronJob запускает эти джобы по расписанию.
Пример использования DaemonSet
Мы вывели DaemonSet из нашего dev-кластера:

В этом dev-кластере десять нод, и на каждой из них запущен pod DaemonSet. Каждый раз, когда поднимается нода, поды всех DaemonSet автоматически поднимутся.
Команды kubectl
kubectl apply -f — применить манифесты
kubectl get <kind> — получить список объектов <kind>
kubectl get <kind><name> -o wide — чуть больше информации
kubectl get <kind><name> -o yaml — в виде yaml
kubectl describe <kind><name> -o yaml — человекочитаемое описание. Например, у нас есть kubectl get pods. Его можно его сделать describe, и оно выведет объекты в более человекочитаемом виде. Это относится не только к стандартным встроенным объектам, но и к кастомным
kubectl edit — редактирование прямо в терминале любого ресурса. При вводе kubectl edit deployment откроется редактор: редактируем, сохраняем и изменения применяются
kubectl logs <pod_name> — посмотреть логи пода
kubectl port-forward — пробросить порт из Kubernetes на локальный хост
kubectl exec — выполнить команду внутри запущенного контейнера. Если в контейнере есть баш, это равносильно команде docker exec. Команда позволяет это делать с удаленным кластером, с удаленным узлом и подом на нем



## Установка

minikube and kubectl:  
```bash

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb

sudo dpkg -i minikube_latest_amd64.deb


curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
## Переключение kubectl на другой кластер
Чтобы переключить `kubectl` на другой кластер, нужно изменить текущий контекст в конфигурационном файле kubeconfig, который обычно находится по пути `~/.kube/config`. Вот основные способы сделать это:

### 1. Переключение контекста
Если в конфигурации `kubectl` уже настроены несколько контекстов (кластеры):

```bash
kubectl config get-contexts
```

Вывод покажет все доступные контексты и укажет текущий. Чтобы переключиться на другой контекст, используйте команду:

```bash
kubectl config use-context <имя-контекста>
```

### 2. Добавление нового кластера в конфигурацию `kubectl`
Если у вас есть файл kubeconfig для нового кластера (например, `new-cluster-config.yaml`), можно объединить его с текущим конфигом:

```bash
kubectl config view --merge --flatten > ~/.kube/config && KUBECONFIG=~/.kube/config:new-cluster-config.yaml kubectl config view --merge --flatten > ~/.kube/config
```

### 3. Указание файла конфигурации напрямую
Вы также можете напрямую указать конфигурационный файл при запуске команд:

```bash
kubectl --kubeconfig=/path/to/new-cluster-config.yaml get nodes
```

### 4. Удаление старого или ненужного контекста
Если нужно удалить контекст для кластера, выполните:

```bash
kubectl config delete-context <имя-контекста>
```

Эти действия помогут вам переключить `kubectl` на другой кластер для управления.


## ИНСТРУКЦИИ KUBECTL
Основные команды

Общая информация о кластере:
kubectl cluster-info

Информация о компонентах кластера:
kubectl get componentstatuses

Список всех узлов (нод):
kubectl get nodes

Подробная информация о ноде:
kubectl describe node <node_name>

Работа с Namespaces

Список всех namespaces:
kubectl get namespaces

Создание namespace:
kubectl create namespace <namespace_name>

Удаление namespace:
kubectl delete namespace <namespace_name>

Работа с Pods

Список всех подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Работа с Deployments

Список всех deployments:
kubectl get deployments

Создание deployment из YAML файла:
kubectl apply -f <file.yaml>

Обновление deployment:
kubectl set image deployment/<deployment_name> <container_name>=<new_image>

Откат к предыдущей версии deployment:
kubectl rollout undo deployment/<deployment_name>

Работа с Services

Список всех сервисов:
kubectl get services

Подробная информация о сервисе:
kubectl describe service <service_name>

Работа с ConfigMaps и Secrets

Список всех ConfigMaps:
kubectl get configmaps

Создание ConfigMap из файла:
kubectl create configmap <configmap_name> --from-file=<file_path>

Список всех Secrets:
kubectl get secrets

Создание Secret из файла:
kubectl create secret generic <secret_name> --from-file=<file_path>

Работа с RBAC (Role-Based Access Control)

Список всех ролей:
kubectl get roles

Список всех rolebindings:
kubectl get rolebindings

Создание роли из YAML файла:
kubectl apply -f <role.yaml>

Создание привязки роли (rolebinding) из YAML файла:
kubectl apply -f <rolebinding.yaml>

Полезные опции

Переключение namespace:
kubectl config set-context --current --namespace=<namespace>

Фильтрация вывода по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода:
kubectl get pods --sort-by=.metadata.name

Вывод в формате YAML/JSON:
kubectl get pods -o yaml
kubectl get pods -o json



PODS

ИНСТРУКЦИИ. Создание и управление Pods

Создание пода из YAML файла:
kubectl apply -f <file.yaml>

Удаление пода:
kubectl delete pod <pod_name>

Перезапуск пода:
kubectl delete pod <pod_name> --grace-period=0 --force

Список подов:
kubectl get pods

Список подов в указанном namespace:
kubectl get pods -n <namespace>

Подробная информация о поде:
kubectl describe pod <pod_name>

Логи пода:
kubectl logs <pod_name>

Логи конкретного контейнера в поде:
kubectl logs <pod_name> -c <container_name>

Потоковые логи пода:
kubectl logs -f <pod_name>

Потоковые логи конкретного контейнера в поде:
kubectl logs -f <pod_name> -c <container_name>

Запуск шелла в контейнере пода:
kubectl exec -it <pod_name> -- /bin/bash

Выполнение команды в контейнере пода:
kubectl exec <pod_name> -- <command>

Проброс порта из пода на локальную машину:
kubectl port-forward <pod_name> <local_port>:<remote_port>

Копирование файлов из пода на локальную машину:
kubectl cp <pod_name>:<path/to/file> <local_path>

Копирование файлов с локальной машины в под:
kubectl cp <local_path> <pod_name>:<path/to/file>

Фильтрация подов по меткам (labels):
kubectl get pods -l <label_selector>

Сортировка вывода подов:
kubectl get pods --sort-by=.metadata.name

Вывод списка подов в формате YAML:
kubectl get pods -o yaml

Вывод списка подов в формате JSON:
kubectl get pods -o json
