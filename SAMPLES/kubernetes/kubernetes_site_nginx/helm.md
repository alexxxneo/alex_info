


`curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash` Установка helm если нет еще  
`helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx` добавляем репозиторий
`helm repo update` обновляем кэш
`helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace`
` kubectl get pods -n ingress-nginx`  Проверка статуса развертывания. Смотрим запустились ли рабочие поды контроллера

`kubectl get services -o wide -n ingress-nginx` после развертывания получаем внешний ip. Должны получить примерно такой ответ:
nx
NAME                                               TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE   SELECTOR
nginx-ingress-ingress-nginx-controller             LoadBalancer   10.0.206.149   51.250.41.223   80:32560/TCP,443:31826/TCP   11h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=nginx-ingress,app.kubernetes.io/name=ingress-nginx
nginx-ingress-ingress-nginx-controller-admission   ClusterIP      10.0.153.72    <none>          443/TCP                      11h   app.kubernetes.io/component=controller,app.kubernetes.io/instance=nginx-ingress,app.kubernetes.io/name=ingress-nginx

