
### Основные команды
`kubectl port-forward myapp-67dc94db54-7tp2q 8000:8000` достучаться до нашего приложения, до нашего пода из  локального окружения
`minikube start --nodes 3 --driver=docker` запуск миникуба с несколькими нодами
`kubectl  apply -f deployment.yml`
`kubectl get po -o wide` инфа о подах с ip
`kubectl config set-context --current --namespace=<namespace>` – установить нужный неймспейс.
`yc managed-kubernetes cluster get-credentials <cluster-name> --external` подключение к кластеру кубернетес в яндексе  
`kubectl delete --all all` удалить все ресурсы в кластере



Сервисы  
`kubectl get svc`       посмотреть созданные сервисы
`kubectl describe nodes | grep ExternalIP`посмотреть внешние ip у нод кластера 
`kubectl describe nodes --namespace default | grep ExternalIP`     посмотреть внешние ip у нод кластера для определенного namespace


Создание сервисов
`kubectl expose deployment lite-deployment --name=lite-service --port=80 --type=ClusterIP` создаем для деплоймента lite-service-clusterip сервис с типом ClusterIp, с портами 80 и типом ClusterIP

`kubectl expose deployment lite-deployment --name=lite-service-nodeport --port=80 --target-port=80 --type=NodePort` создаем для деплоймента lite-service сервис с типом ClusterIp, с портами 80 и типом NodePort. port — порт сервиса внутри кластера, targetPort — порт контейнера в поде, к которому будет направляться трафик.




`
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `
`kubectl  `


1. `kubectl get nodes` – показать все узлы (ноды) в кластере.
2. `kubectl get pods` – отобразить все поды в текущем неймспейсе.
3. `kubectl get pods --all-namespaces` – показать все поды во всех неймспейсах.
4. `kubectl get services` – отобразить все сервисы в текущем неймспейсе.
5. `kubectl get namespaces` – отобразить все неймспейсы.
6. `kubectl get deployments` – показать все деплойменты в текущем неймспейсе.
7. `kubectl get configmap` – показать все конфигурационные файлы (ConfigMap).
8. `kubectl get secrets` – отобразить все секреты.
9. `kubectl get ingress` – отобразить все Ingress в текущем неймспейсе.
10. `kubectl get pvc` – отобразить все запросы на постоянные тома (PersistentVolumeClaim).

### Команды для детализированной информации
11. `kubectl describe pod <pod_name>` – получить подробную информацию о поде.
12. `kubectl describe service <service_name>` – получить информацию о сервисе.
13. `kubectl describe deployment <deployment_name>` – получить детализированную информацию о деплойменте.
14. `kubectl describe node <node_name>` – получить информацию об узле.
15. `kubectl describe namespace <namespace_name>` – детализированная информация о неймспейсе.
16. `kubectl describe ingress <ingress_name>` – информация о правилах Ingress.
17. `kubectl describe pvc <pvc_name>` – информация о PVC.
18. `kubectl describe configmap <configmap_name>` – информация о конфигурации.
19. `kubectl describe secret <secret_name>` – информация о секрете.
20. `kubectl describe pv <pv_name>` – информация о постоянном томе (PersistentVolume).

### Создание и удаление ресурсов
21. `kubectl create namespace <name>` – создать новый неймспейс.
22. `kubectl create configmap <name> --from-file=<path>` – создать ConfigMap из файла.
23. `kubectl create secret generic <name> --from-literal=<key>=<value>` – создать секрет.
24. `kubectl delete pod <pod_name>` – удалить под.
25. `kubectl delete service <service_name>` – удалить сервис.
26. `kubectl delete deployment <deployment_name>` – удалить деплоймент.
27. `kubectl delete namespace <namespace_name>` – удалить неймспейс.
28. `kubectl delete pvc <pvc_name>` – удалить PVC.
29. `kubectl delete configmap <configmap_name>` – удалить ConfigMap.
30. `kubectl delete secret <secret_name>` – удалить секрет.

### Запуск и обновление приложений
31. `kubectl apply -f <filename>.yaml` – применить конфигурацию из файла.
32. `kubectl edit deployment <deployment_name>` – редактировать деплоймент.
33. `kubectl set image deployment/<deployment_name> <container_name>=<image>:<tag>` – обновить образ в деплойменте.
34. `kubectl rollout restart deployment <deployment_name>` – перезапустить деплоймент.
35. `kubectl rollout status deployment <deployment_name>` – проверить статус раскатки деплоймента.
36. `kubectl scale deployment <deployment_name> --replicas=<count>` – масштабировать количество реплик.
37. `kubectl autoscale deployment <deployment_name> --min=<min_replicas> --max=<max_replicas> --cpu-percent=<target_cpu>` – настроить авто-масштабирование.

### Команды для логов и отладки
38. `kubectl logs <pod_name>` – посмотреть логи пода.
39. `kubectl logs -f <pod_name>` – смотреть поток логов пода.
40. `kubectl logs <pod_name> -c <container_name>` – посмотреть логи конкретного контейнера.
41. `kubectl exec -it <pod_name> -- /bin/bash` – войти внутрь пода.
42. `kubectl exec <pod_name> -- <command>` – выполнить команду в поде.
43. `kubectl top nodes` – показать использование ресурсов узлов.
44. `kubectl top pods` – показать использование ресурсов подов.
45. `kubectl top pod <pod_name>` – ресурсы конкретного пода.

### Управление неймспейсами
46. `kubectl config set-context --current --namespace=<namespace>` – установить текущий неймспейс.
47. `kubectl config view --minify | grep namespace:` – посмотреть текущий неймспейс.
48. `kubectl get all -n <namespace>` – отобразить все ресурсы в неймспейсе.
49. `kubectl delete namespace <namespace>` – удалить неймспейс и все его ресурсы.

### Управление доступом и ролями
50. `kubectl create role <role_name> --verb=get --verb=list --resource=pods` – создать роль.
51. `kubectl create rolebinding <binding_name> --role=<role_name> --user=<username> -n <namespace>` – привязать роль к пользователю.
52. `kubectl get roles -n <namespace>` – отобразить роли в неймспейсе.
53. `kubectl describe role <role_name> -n <namespace>` – детализированная информация о роли.
54. `kubectl get rolebindings -n <namespace>` – отобразить все привязки ролей.
55. `kubectl delete role <role_name> -n <namespace>` – удалить роль.

### Информация о кластере
56. `kubectl cluster-info` – информация о кластере.
57. `kubectl get componentstatus` – статус компонентов кластера.
58. `kubectl get events` – получить события кластера.
59. `kubectl get events --sort-by='.metadata.creationTimestamp'` – события кластера в порядке времени.

### Команды для Helm (если используется Helm)
60. `helm list` – список релизов Helm.
61. `helm install <release_name> <chart_name>` – установить чарт.
62. `helm upgrade <release_name> <chart_name>` – обновить чарт.
63. `helm rollback <release_name> <revision>` – откатить до указанной версии.
64. `helm delete <release_name>` – удалить релиз.

### Сетевые команды
65. `kubectl expose pod <pod_name> --port=<port> --target-port=<target_port>` – создать сервис для пода.
66. `kubectl port-forward pod/<pod_name> <local_port>:<pod_port>` – перенаправление порта для локального доступа.
67. `kubectl apply -f ingress.yaml` – создать Ingress.
68. `kubectl delete ingress <ingress_name>` – удалить Ingress.

### Работа с Volumes
69. `kubectl get pv` – отобразить все постоянные тома.
70. `kubectl get pvc` – отобразить все запросы на постоянные тома.
71. `kubectl describe pv <pv_name>` – детализированная информация о постоянном томе.
72. `kubectl delete pv <pv_name>` – удалить постоянный том.

### Управление конфигурациями
73. `kubectl create configmap <name> --from-literal=<key>=<value>` – создать ConfigMap с ключами.
74. `kubectl delete configmap <name>` – удалить ConfigMap.
75. `kubectl edit configmap <name>` – редактировать ConfigMap.
76. `kubectl get configmap <name> -o yaml` – получить ConfigMap в формате YAML.

### Секреты
77. `kubectl create secret generic <name> --from-literal=<key>=<value>` – создать секрет.
78. `kubectl describe secret <name>` – информация о секрете.
79. `kubectl delete secret <name>` – удалить секрет.
80. `kubectl edit secret <name>` – редактировать секрет.

### Дополнительные команды
81. `kubectl run <name> --image=<image_name>` – запустить одноразовый под.
82. `kubectl scale --replicas=<count> deployment/<deployment_name>` – изменить количество реплик.
83. `kubectl patch deployment <deployment_name> -p '{"spec":{"replicas":<count>}}'` – изменить количество реплик.
84. `kubectl apply -f <url>` – применить конфигурацию из URL.
85. `kubectl rollout undo deployment <deployment_name>` – откатить изменения деплоймента.
86. `kubectl apply -k <directory>` – применить все конфигурации в каталоге.

### Разное
87. `kubectl cp <pod_name>:<path> <local_path>` – скопировать файл из пода.
88. `kubectl get po -l <label>=<value>` – отобразить поды с определенной меткой.
89. `kubectl taint nodes <node_name> key=value:NoSchedule` – добавить метку на узел.
90. `kubectl label pod <pod_name> <label_key>=<label_value>` – добавить метку поду.
91. `kubectl annotate pod <pod_name> <annotation_key>=<annotation_value>` – добавить аннотацию поду.
92. `kubectl replace -f <filename>.yaml` – заменить ресурс.
93. `kubectl apply --record -f <filename>.yaml` – записать историю изменений.
94. `kubectl get ep` – показать все эндпоинты.
95. `kubectl cordon <node_name>` – запретить планирование на узле.
96. `kubectl uncordon <node_name>` – разрешить планирование на узле.
97. `kubectl drain <node_name>` – удалить поды перед остановкой узла.
98. `kubectl get daemonsets` – показать демоны в текущем неймспейсе.
99. `kubectl get replicasets` – показать репликасеты в текущем неймспейсе.
100. `kubectl version` – показать версию клиента и сервера Kubernetes.
