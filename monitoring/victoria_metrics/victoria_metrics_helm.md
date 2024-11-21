Вот развертывание VictoriaMetrics в Kubernetes с построчными комментариями в манифестах. Мы будем использовать подход с манифестами вместо Helm-чарта.

---

### **Шаг 1: Создайте namespace**

Манифест для создания namespace `monitoring`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring # Имя namespace для изоляции ресурсов VictoriaMetrics.
```

Примените манифест:
```bash
kubectl apply -f namespace.yaml
```

---

### **Шаг 2: Создайте Deployment для VictoriaMetrics**

Манифест для VictoriaMetrics (используем standalone-версию):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: victoria-metrics # Имя деплоймента.
  namespace: monitoring # Указываем, что деплоймент находится в namespace monitoring.
  labels:
    app: victoria-metrics # Метка для идентификации приложения.
spec:
  replicas: 1 # Количество реплик (в тестовой среде достаточно одной).
  selector:
    matchLabels:
      app: victoria-metrics # Селектор для сопоставления с подами.
  template:
    metadata:
      labels:
        app: victoria-metrics # Метка для подов.
    spec:
      containers:
        - name: victoria-metrics # Имя контейнера.
          image: victoriametrics/victoria-metrics:latest # Образ VictoriaMetrics с последней версией.
          ports:
            - containerPort: 8428 # Порт для доступа к VictoriaMetrics UI и API.
          args:
            - '--retentionPeriod=1' # Настройка периода хранения данных (в днях).
```

Примените манифест:
```bash
kubectl apply -f deployment-vm.yaml
```

---

### **Шаг 3: Создайте Service для VictoriaMetrics**

Манифест для сервиса, который предоставляет доступ к VictoriaMetrics внутри кластера:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: victoria-metrics # Имя сервиса.
  namespace: monitoring # Namespace, где создаётся сервис.
spec:
  type: ClusterIP # Тип сервиса. ClusterIP предоставляет доступ только внутри кластера.
  ports:
    - port: 8428 # Порт, доступный снаружи сервиса.
      targetPort: 8428 # Порт, на который перенаправляется трафик внутри пода.
      protocol: TCP # Протокол связи.
  selector:
    app: victoria-metrics # Связываем сервис с подами, имеющими эту метку.
```

Примените манифест:
```bash
kubectl apply -f service-vm.yaml
```

---

### **Шаг 4: Настройте Ingress для доступа**

Манифест для Ingress-контроллера, чтобы обеспечить внешний доступ к VictoriaMetrics через домен:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: victoria-metrics-ui # Имя Ingress ресурса.
  namespace: monitoring # Namespace, в котором он создаётся.
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: / # Перенаправление всех запросов к корню приложения.
spec:
  rules:
    - host: vm.example.com # Доменное имя для доступа к VictoriaMetrics.
      http:
        paths:
          - path: / # Путь для доступа.
            pathType: Prefix # Тип пути (подходит для большинства сценариев).
            backend:
              service:
                name: victoria-metrics # Имя сервиса, который мы настраивали выше.
                port:
                  number: 8428 # Порт сервиса для подключения.
```

Примените манифест:
```bash
kubectl apply -f ingress-vm.yaml
```

---

### **Шаг 5: Настройте scrape-цели**

Если вы хотите собирать данные с источников (например, с `node-exporter`), создайте ConfigMap с настройками:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: vm-scrape-config # Имя ConfigMap.
  namespace: monitoring # Namespace, где она создаётся.
data:
  scrape.yaml: | # Файл конфигурации для scrape-целей.
    global:
      scrape_interval: 15s # Интервал сбора метрик.
    scrape_configs:
      - job_name: 'node-exporter' # Имя задания для сбора данных.
        static_configs:
          - targets: ['node-exporter.monitoring.svc.cluster.local:9100'] # Цель (адрес node-exporter).
```

Примените манифест:
```bash
kubectl apply -f configmap-vm.yaml
```

Обновите Deployment, чтобы VictoriaMetrics использовала этот ConfigMap. Добавьте в секцию `args` ссылку на конфигурацию:

```yaml
          args:
            - '--retentionPeriod=1' # Настройка периода хранения данных (в днях).
            - '--promscrape.config=/config/scrape.yaml' # Указываем путь к конфигурации scrape-целей.
          volumeMounts:
            - name: config-volume
              mountPath: /config # Монтируем ConfigMap в контейнер.
      volumes:
        - name: config-volume
          configMap:
            name: vm-scrape-config # Указываем, какой ConfigMap использовать.
```

---

### **Шаг 6: Подключение VictoriaMetrics к Grafana: Подробная инструкция

VictoriaMetrics предоставляет интерфейс, совместимый с Prometheus API, что позволяет легко интегрировать её с Grafana для визуализации метрик. Вот пошаговая инструкция:

---

#### **Шаг 1: Подготовка URL для доступа к VictoriaMetrics**
1. **Внутрикластерный доступ**:
   - Если вы используете Service типа `ClusterIP`, подключение к VictoriaMetrics возможно только изнутри кластера.
   - URL для подключения будет вида:
     ```
     http://victoria-metrics.monitoring.svc.cluster.local:8428
     ```

2. **Внешний доступ**:
   - Если вы настроили Ingress, используйте ваш домен, например:
     ```
     http://vm.example.com
     ```

3. **Проверка доступа**:
   - Убедитесь, что VictoriaMetrics доступна по указанному адресу, выполнив запрос через `curl`:
     ```bash
     curl http://victoria-metrics.monitoring.svc.cluster.local:8428/metrics
     ```
   - Вы должны увидеть список метрик.

---

#### **Шаг 2: Добавьте Data Source в Grafana**
1. **Откройте Grafana**:
   - Перейдите в интерфейс Grafana по адресу, например, `http://grafana.example.com`.

2. **Создайте новый источник данных**:
   - В меню Grafana выберите **Configuration > Data Sources**.
   - Нажмите кнопку **Add data source**.

3. **Выберите тип источника**:
   - Выберите **Prometheus** как тип источника данных.

4. **Настройте подключение**:
   - В поле **URL** введите адрес VictoriaMetrics:
     - Если внутри кластера:
       ```
       http://victoria-metrics.monitoring.svc.cluster.local:8428
       ```
     - Если внешний доступ через Ingress:
       ```
       http://vm.example.com
       ```
   - Оставьте остальные настройки по умолчанию.

5. **Протестируйте соединение**:
   - Нажмите кнопку **Save & Test**.
   - Если подключение успешно, появится сообщение о том, что Grafana смогла подключиться к VictoriaMetrics.

---

#### **Шаг 3: Импортируйте готовый дашборд**
VictoriaMetrics имеет готовые дашборды, доступные на [официальной странице Grafana Dashboards](https://grafana.com/grafana/dashboards). Вот как их импортировать:

1. **Перейдите в раздел Import**:
   - В меню Grafana выберите **Create > Import**.

2. **Найдите дашборд для VictoriaMetrics**:
   - Откройте [официальные дашборды VictoriaMetrics](https://grafana.com/grafana/dashboards).
   - Выберите интересующий вас дашборд (например, ID: `11829`).

3. **Импортируйте дашборд**:
   - В поле **Import via grafana.com** введите ID дашборда, например: `11829`.
   - Нажмите **Load**.

4. **Выберите источник данных**:
   - В выпадающем списке выберите источник данных, который вы настроили ранее (VictoriaMetrics).

5. **Сохраните настройки**:
   - Нажмите **Import**.

---

#### **Шаг 4: Настройте свои дашборды**
1. **Добавьте панели с кастомными запросами**:
   - Перейдите в любой дашборд или создайте новый.
   - Нажмите **Add panel**, чтобы создать новую панель.

2. **Составьте PromQL-запросы**:
   - В панели используйте PromQL-запросы для получения нужных метрик. Примеры запросов:
     - Загрузка процессора:
       ```promql
       avg(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)
       ```
     - Использование памяти:
       ```promql
       node_memory_Active_bytes / node_memory_MemTotal_bytes
       ```

3. **Сохраните изменения**:
   - Настройте визуализацию (графики, таблицы, гистограммы и т. д.) и сохраните дашборд.

---

Теперь Grafana визуализирует метрики из VictoriaMetrics, и вы можете адаптировать дашборды под свои нужды. Если что-то останется непонятным, напишите — помогу!