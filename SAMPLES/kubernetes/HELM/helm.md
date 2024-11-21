Установка helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

helm pull ingress-nginx/ingress-nginx --version 4.0.6 --untar


Вот шпаргалка по Helm в удобном и структурированном виде с необходимыми комментариями:  

---

### Основные команды Helm

#### 1. **Создание секрета для GitLab Runner**
```bash
kubectl create secret generic gitlab-runner-certs \
    --namespace runner \
    --from-file=172.16.215.147.cr
```
- Создает секрет `gitlab-runner-certs` в namespace `runner` из файла `172.16.215.147.cr`.

---

#### 2. **Шаблон именования Helm ресурсов**
```yaml
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
```
- Используется для обработки имени ресурса: ограничивает длину до 63 символов и удаляет лишние дефисы в конце.

---

#### 3. **Выгрузка значений из Helm Chart**
```bash
helm show values gitlab/gitlab-runner > runner.yml
```
- Сохраняет стандартные значения (values) чарта `gitlab/gitlab-runner` в файл `runner.yml`.

---

#### 4. **Режим Dry-Run и Debug**
```bash
helm install test test --dry-run --debug
```
- Проверяет чарт без установки: показывает полный манифест, который будет применен, с подробным логом.

---

#### 5. **Получение манифеста с кастомными значениями**
```bash
helm template --namespace runner gitlab-runner -f runner.yml gitlab/gitlab-runner > runner-manifest.yaml
```
- Генерирует YAML-манифест на основе чарта `gitlab/gitlab-runner` с использованием значений из файла `runner.yml`.

---

#### 6. **Установка GitLab Runner с кастомными значениями**
```bash
helm install --namespace runner gitlab-runner -f runner.yml gitlab/gitlab-runner
```
- Устанавливает чарт `gitlab/gitlab-runner` в namespace `runner` с кастомными значениями из файла `runner.yml`.

---

#### 7. **Удаление Helm Chart**
```bash
helm uninstall --namespace runner gitlab-runner
```
- Удаляет релиз `gitlab-runner` из namespace `runner`.

---

#### 8. **Добавление репозитория Helm**
```bash
helm repo add gitlab https://charts.gitlab.io
```
- Добавляет репозиторий `gitlab` по указанному URL.

---

#### 9. **Создание нового Helm Chart**
```bash
helm create my-chart
```
- Создает базовую структуру чарта в папке `my-chart`.

---

#### 10. **Загрузка Helm Chart**
```bash
helm pull gitlab/gitlab-runner
```
- Скачивает чарт `gitlab/gitlab-runner` в текущую директорию.

---

#### 11. **Список установленных чартов**
```bash
helm list --all-namespaces
```
- Показывает все установленные чарты во всех namespace.

---

#### 12. **Обновление Helm Chart**
```bash
helm upgrade --namespace runner gitlab-runner -f runner.yml gitlab/gitlab-runner
```
- Обновляет установленный чарт `gitlab-runner` с новыми значениями из файла `runner.yml`.

---

### Полезные команды

#### Проверка установленных репозиториев:
```bash
helm repo list
```

#### Обновление всех репозиториев:
```bash
helm repo update
```

#### Проверка версии Helm:
```bash
helm version
```

#### Проверка доступных версий чарта:
```bash
helm search repo <chart_name>
```

#### Удаление всех установленных чартов в namespace:
```bash
helm uninstall $(helm list -q -n <namespace>) --namespace <namespace>
```

#### Установка чарта в определенный namespace без манифеста:
```bash
helm install <release_name> <chart> --namespace <namespace> --create-namespace
```

---

### **1. Управление зависимостями**

#### Добавление зависимостей в `Chart.yaml`:
```yaml
dependencies:
  - name: common
    version: 1.10.0
    repository: https://charts.gitlab.io
```

#### Установка зависимостей:
```bash
helm dependency update
```
- Загружает зависимости, указанные в `Chart.yaml`.

#### Проверка зависимостей:
```bash
helm dependency list
```
- Показывает список зависимостей и их статус.

---

### **2. Обновление и тестирование**

#### Обновление всех репозиториев:
```bash
helm repo update
```
- Гарантирует, что используется самая актуальная версия чарта.

#### Тестирование установленного чарта:
```bash
helm test <release_name> --namespace <namespace>
```
- Запускает тесты, определенные в чарте.

---

### **3. Работа с пользовательскими значениями**

#### Сравнение стандартных и пользовательских значений:
```bash
helm get values <release_name> --namespace <namespace>
```
- Показывает текущие значения релиза.

```bash
helm get values <release_name> --all --namespace <namespace>
```
- Показывает все значения, включая установленные по умолчанию.

#### Переопределение значений из CLI:
```bash
helm install <release_name> <chart_name> \
    --set image.tag=1.2.3 \
    --set replicaCount=2
```
- Удобно для быстрого тестирования изменений.

---

### **4. Управление версиями**

#### Поиск доступных версий чарта:
```bash
helm search repo <chart_name> --versions
```

#### Установка конкретной версии чарта:
```bash
helm install <release_name> <chart_name> --version 1.0.0
```

---

### **5. Логи и отладка**

#### Просмотр логов Helm:
```bash
helm history <release_name> --namespace <namespace>
```
- Показывает историю изменений релиза.

#### Откат релиза на предыдущую версию:
```bash
helm rollback <release_name> <revision> --namespace <namespace>
```
- Возвращает релиз к указанной ревизии.

---

### **6. CI/CD и Helm**

#### Рендеринг чарта для CI/CD:
```bash
helm template <release_name> <chart_name> -f values.yaml
```
- Удобно для проверки манифестов перед деплоем в CI/CD.

#### Установка чарта с использованием Kubeconfig:
```bash
KUBECONFIG=/path/to/kubeconfig helm install <release_name> <chart_name>
```
- Использует конкретный файл kubeconfig, что важно при работе с несколькими кластерами.

---

### **7. Настройка Helm для пользователей**

#### Указание пользовательского Namespace:
```bash
export HELM_NAMESPACE=runner
```
- Устанавливает Namespace по умолчанию для всех команд Helm.

#### Указание кастомного файла конфигурации:
```bash
helm install <release_name> <chart_name> --values /custom/path/values.yaml
```

---

### **8. Управление Helm Plugins**

#### Установка плагина:
```bash
helm plugin install <plugin_url>
```

#### Проверка установленных плагинов:
```bash
helm plugin list
```

#### Пример полезного плагина:
- **Helm Diff**: Показывает разницу между установленным релизом и новым.
  ```bash
  helm plugin install https://github.com/databus23/helm-diff
  helm diff upgrade <release_name> <chart_name> -f values.yaml
  ```

---

### **9. Сценарии для production**

#### Установка с несколькими файлами значений:
```bash
helm install <release_name> <chart_name> \
    -f base-values.yaml \
    -f override-values.yaml
```

#### Проверка наличия обновлений для чарта:
```bash
helm repo update && helm search repo <chart_name>
```

#### Установка Helm с минимальными привилегиями:
1. Создайте ServiceAccount для Helm:
   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: helm-sa
     namespace: kube-system
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: helm-sa-binding
   subjects:
   - kind: ServiceAccount
     name: helm-sa
     namespace: kube-system
   roleRef:
     kind: ClusterRole
     name: cluster-admin
     apiGroup: rbac.authorization.k8s.io
   ```
2. Укажите ServiceAccount при работе:
   ```bash
   helm install <release_name> <chart_name> --service-account helm-sa
   ```

---

Если нужно ещё больше деталей или примеров, например, интеграция Helm с GitOps, работа с Helmfile или кастомизация чарта, дай знать! 😊

