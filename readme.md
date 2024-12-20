
# Сеть

Вот список основных команд для работы с сетью в Ubuntu, полезных для DevOps:

### Команды для работы с сетью в Ubuntu

| Команда                                     | Описание                                                |
|---------------------------------------------|---------------------------------------------------------|
| `ifconfig`                                  | Отображает настройки сетевых интерфейсов.              |
| `ip addr`                                   | Выводит информацию о сетевых интерфейсах и их IP-адресах.|
| `ip link`                                   | Показывает состояние сетевых интерфейсов.               |
| `ip route`                                  | Отображает таблицу маршрутизации.                       |
пример того что трафик идет не по основному маршруту
root@anderson:~# ip route get 8.8.8.8
8.8.8.8 dev wg0 table 51820 src 10.0.0.2 uid 0 
    cache 
после починки трафик стали идти по дефолтному рабочему маршруту:
root@anderson:~# ip route get 8.8.8.8
8.8.8.8 via 192.168.88.1 dev vmbr0 src 192.168.88.217 uid 0 
    cache 
| `ping <адрес>`                              | Проверяет доступность хоста по его IP-адресу или домену.|
| `traceroute <адрес>`                        | Отображает маршрут до указанного хоста.                 |
| `nslookup <домен>`                          | Запрашивает информацию о DNS для указанного домена.  nslookup google.com проверить насколько хорошо работает резолв dns   |
| `dig <домен>`                               | Более продвинутая команда для DNS-запросов.            |
| `curl <url>`                                | Выполняет HTTP-запрос и выводит ответ от сервера.       |
| `wget <url>`                                | Загружает файл с указанного URL.                        |
| `netstat -tuln`                             | Показывает открытые порты и службы, слушающие подключения.|
| `ss -tuln`                                  | Аналог команды netstat, показывает открытые порты.      |
| `iptables -L`                               | Показывает текущие правила брандмауэра.                 |
| `ufw status`                                | Показывает статус и правила брандмауэра UFW (Uncomplicated Firewall). |
| `ufw allow <порт>`                          | Разрешает входящие соединения на указанный порт.        |
| `ufw deny <порт>`                           | Запрещает входящие соединения на указанный порт.        |
| `route -n`                                  | Показывает таблицу маршрутизации.                       |
| `nmcli`                                     | Командный интерфейс для управления сетевыми соединениями (NetworkManager). |
| `systemctl restart networking`              | Перезапускает сетевой интерфейс.                        |
| `systemctl status networking`               | Показывает статус сетевого интерфейса.                  |
| `ip addr add <IP>/<маска> dev <интерфейс>` | Добавляет IP-адрес к указанному сетевому интерфейсу.     |
| `ip addr del <IP>/<маска> dev <интерфейс>` | Удаляет IP-адрес с указанного сетевого интерфейса.      |
| `ethtool <интерфейс>`                       | Показывает и настраивает параметры сетевого интерфейса. |
| `mtr <адрес>`                               | Комбинирует функциональность `ping` и `traceroute`, показывает маршрут и задержку. |
| `hostname`                                   | Показывает или устанавливает имя хоста системы.         |
| `hostname -I`                               | Показывает все IP-адреса хоста.                         |
| `tcpdump`                                   | Захватывает и анализирует пакеты, проходящие через интерфейс. |
| `iwconfig`                                  | Конфигурирует параметры беспроводных интерфейсов (если применимо). |
| `iwlist <интерфейс> scan`                   | Сканирует доступные беспроводные сети.                  |
| `nmcli device status`                       | Показывает состояние всех сетевых устройств.            |

## iptables

Вот 20 популярных примеров использования `iptables`, которые могут быть полезны для DevOps-практиков:

### Примеры использования `iptables` для DevOps

1. **Разрешить SSH доступ**:
   ```bash
   sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
   ```
   Разрешает входящие соединения на порт 22 (SSH).

2. **Разрешить HTTP и HTTPS доступ**:
   ```bash
   sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
   sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
   ```
   Разрешает входящие соединения на порты 80 (HTTP) и 443 (HTTPS).

3. **Блокировать доступ с определенного IP-адреса**:
   ```bash
   sudo iptables -A INPUT -s 192.168.1.100 -j DROP
   ```
   Блокирует входящие соединения от IP-адреса 192.168.1.100.

4. **Разрешить доступ только с определенного подсети**:
   ```bash
   sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
   ```
   Разрешает входящие соединения только с подсети 192.168.1.0/24.

5. **Блокировать все входящие соединения по умолчанию**:
   ```bash
   sudo iptables -P INPUT DROP
   ```
   Устанавливает политику по умолчанию для входящих соединений на DROP.

6. **Разрешить все исходящие соединения**:
   ```bash
   sudo iptables -P OUTPUT ACCEPT
   ```
   Устанавливает политику по умолчанию для исходящих соединений на ACCEPT.

7. **Разрешить пинг (ICMP)**:
   ```bash
   sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
   ```
   Разрешает входящие ICMP-пакеты (пинги).

8. **Лимитировать количество соединений**:
   ```bash
   sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 10 -j REJECT
   ```
   Ограничивает количество одновременных соединений на порт 80 до 10.

9. **Перенаправление портов**:
   ```bash
   sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
   ```
   Перенаправляет входящие соединения на порт 80 на порт 8080.

10. **Разрешить доступ только для определенного интерфейса**:
    ```bash
    sudo iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
    ```
    Разрешает доступ по SSH только на интерфейсе `eth0`.

11. **Разрешить доступ к определенному серверу DNS**:
    ```bash
    sudo iptables -A INPUT -p udp --dport 53 -s 8.8.8.8 -j ACCEPT
    ```
    Разрешает входящие UDP-запросы на порт 53 только от DNS-сервера Google (8.8.8.8).

12. **Запретить доступ к FTP-серверу**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 21 -j DROP
    ```
    Блокирует входящие соединения на порт 21 (FTP).

13. **Логирование заблокированных пакетов**:
    ```bash
    sudo iptables -A INPUT -j LOG --log-prefix "iptables blocked: "
    ```
    Логирует все пакеты, которые были заблокированы.

14. **Сохранение текущих правил**:
    ```bash
    sudo iptables-save > /etc/iptables/rules.v4
    ```
    Сохраняет текущие правила в файл для восстановления.

15. **Восстановление правил из файла**:
    ```bash
    sudo iptables-restore < /etc/iptables/rules.v4
    ```
    Восстанавливает правила из файла.

16. **Разрешить доступ к MySQL**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
    ```
    Разрешает входящие соединения на порт 3306 (MySQL).

17. **Разрешить доступ к Redis**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 6379 -j ACCEPT
    ```
    Разрешает входящие соединения на порт 6379 (Redis).

18. **Блокировка DDoS-атак**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -m limit --limit 1/s -j ACCEPT
    ```
    Ограничивает количество входящих соединений на порт 80 до 1 в секунду.

19. **Настройка режима `state`**:
    ```bash
    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    ```
    Разрешает входящие пакеты, относящиеся к уже установленным соединениям.

20. **Блокировка всех входящих соединений, кроме определенных**:
    ```bash
    sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -P INPUT DROP
    ```
    Разрешает только SSH и HTTP, блокируя все остальные входящие соединения.

21. **Разрешить доступ только для конкретного IP-адреса**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -s 203.0.113.5 -j ACCEPT
    ```

22. **Блокировка всех ICMP-запросов**:
    ```bash
    sudo iptables -A INPUT -p icmp -j DROP
    ```

23. **Разрешение только локальных соединений**:
    ```bash
    sudo iptables -A INPUT -i lo -j ACCEPT
    ```

24. **Запретить доступ по протоколу telnet**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 23 -j DROP
    ```

25. **Разрешить только IPv4 соединения**:
    ```bash
    sudo iptables -A INPUT -p ipv4 -j ACCEPT
    ```

26. **Разрешить доступ к веб-серверу только с определенного IP**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -s 192.168.1.10 -j ACCEPT
    ```

27. **Блокировка входящих соединений на все порты**:
    ```bash
    sudo iptables -A INPUT -j REJECT
    ```

28. **Разрешить только определенный диапазон IP-адресов**:
    ```bash
    sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT
    ```

29. **Блокировать все входящие соединения, кроме тех, что имеют определенный MAC-адрес**:
    ```bash
    sudo iptables -A INPUT -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT
    ```

30. **Запретить доступ к определенному ресурсу на сайте**:
    ```bash
    sudo iptables -A OUTPUT -p tcp --dport 443 -d example.com -j REJECT
    ```

31. **Блокировка всех входящих соединений из определенного региона**:
    ```bash
    sudo iptables -A INPUT -s <IP_диапазон_региона> -j DROP
    ```

32. **Разрешить только определенные службы (например, только HTTP и HTTPS)**:
    ```bash
    sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
    ```

33. **Разрешить SSH доступ только из локальной сети**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 22 -s 192.168.0.0/16 -j ACCEPT
    ```

34. **Разрешить исходящий трафик на определенные порты**:
    ```bash
    sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
    ```

35. **Логировать трафик на порт 80**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -j LOG --log-prefix "HTTP traffic: "
    ```

36. **Ограничить соединения по времени**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -m time --timestart 08:00 --timestop 18:00 -j ACCEPT
    ```

37. **Блокировка доступа к определенному домену**:
    ```bash
    sudo iptables -A OUTPUT -p tcp -d example.com -j REJECT
    ```

38. **Ограничение исходящих соединений**:
    ```bash
    sudo iptables -A OUTPUT -m connlimit --connlimit-above 5 -j REJECT
    ```

39. **Разрешить DNS-запросы только для локального сервера**:
    ```bash
    sudo iptables -A OUTPUT -p udp --dport 53 -d 192.168.1.1 -j ACCEPT
    ```

40. **Настройка протоколов для доступа к VPN**:
    ```bash
    sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT  # OpenVPN
    ```

41. **Блокировка порта RDP (Remote Desktop Protocol)**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 3389 -j DROP
    ```

42. **Разрешение исходящих запросов только на определенные хосты**:
    ```bash
    sudo iptables -A OUTPUT -d 8.8.8.8 -j ACCEPT
    ```

43. **Разрешить FTP доступ только для определенной подсети**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 21 -s 192.168.0.0/24 -j ACCEPT
    ```

44. **Запретить доступ к интернету для определенного хоста**:
    ```bash
    sudo iptables -A OUTPUT -s 192.168.1.50 -j DROP
    ```

45. **Логирование всех входящих соединений**:
    ```bash
    sudo iptables -A INPUT -j LOG --log-prefix "INCOMING: "
    ```

46. **Блокировка всего трафика на определенный интерфейс**:
    ```bash
    sudo iptables -A INPUT -i eth1 -j DROP
    ```

47. **Разрешить доступ только для HTTPS и HTTP**:
    ```bash
    sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
    ```

48. **Запретить доступ к определенной базе данных**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 3306 -j DROP
    ```

49. **Создание правила для блокировки трафика на основе времени**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 22 -m time --timestart 00:00 --timestop 06:00 -j REJECT
    ```

50. **Блокировка всех входящих соединений, кроме SSH**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -j DROP
    ```

51. **Разрешить ping (ICMP) только из локальной сети**:
    ```bash
    sudo iptables -A INPUT -p icmp -s 192.168.0.0/24 -j ACCEPT
    ```

52. **Разрешить доступ по порту 8080 для всех**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
    ```

53. **Блокировать доступ к порту MySQL для всех, кроме локальной сети**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 3306 -s 192.168.0.0/24 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 3306 -j DROP
    ```

54. **Разрешить доступ только для определенного порта для указанного IP**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 443 -s 203.0.113.1 -j ACCEPT
    ```

55. **Настройка правил для OpenVPN**:
    ```bash
    sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
    ```

56. **Блокировка трафика по конкретному порту (например, 25 для SMTP)**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 25 -j DROP
    ```

57. **Разрешить доступ к базам данных только с локального хоста**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 5432 -s 127.0.0.1 -j ACCEPT
    ```

58. **Блокировать все соединения, кроме тех, что уже установлены**:
    ```bash
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
    ```

59. **Разрешить доступ к NTP-серверу**:
    ```bash
    sudo iptables -A INPUT -p udp --dport 123 -j ACCEPT
    ```

60. **Запретить соединения с конкретным хостом**:
    ```bash
    sudo iptables -A OUTPUT -d 192.0.2.1 -j REJECT
    ```

61. **Создание правила для логирования и блокировки**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix "SSH DROP: "
    sudo iptables -A INPUT -p tcp --dport 22 -j DROP
    ```

62. **Разрешение только для определенных MAC-адресов**:
    ```bash
    sudo iptables -A INPUT -m mac --mac-source 00:11

:22:33:44:55 -j ACCEPT
    ```

63. **Блокировать доступ к облачному сервису**:
    ```bash
    sudo iptables -A OUTPUT -d <IP_облачного_сервиса> -j DROP
    ```

64. **Разрешить доступ к серверу Redis только из локальной сети**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 6379 -s 192.168.1.0/24 -j ACCEPT
    ```

65. **Блокировка соединений с определенными диапазонами IP**:
    ```bash
    sudo iptables -A INPUT -m iprange --src-range 192.168.1.0-192.168.1.255 -j DROP
    ```

66. **Блокировать все входящие соединения на определенном интерфейсе**:
    ```bash
    sudo iptables -A INPUT -i eth1 -j DROP
    ```

67. **Разрешение соединений только с определенного интерфейса**:
    ```bash
    sudo iptables -A INPUT -i eth0 -j ACCEPT
    ```

68. **Запретить доступ к FTP**:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 21 -j DROP
    ```

69. **Логирование всех исходящих соединений**:
    ```bash
    sudo iptables -A OUTPUT -j LOG --log-prefix "OUTGOING: "
    ```

70. **Блокировка трафика, используя регулярные выражения**:
    ```bash
    sudo iptables -A INPUT -p tcp -m string --string "baduser" --algo bm -j DROP
    ```

# SSH
ssh-keygen На локальной машине генерируем ssh ключи находясь в домашней директории, везде enter  
cat id_rsa.pub Выводим публичный ключ и копируем его на любую машину или сервис куда хотим подключиться по ssh  
Для облаков часто нужно чтобы права на частный ключ были выданы 400, т.е. права только на чтение 
  
для пользователя владельца и все. Файл принимает такой вид:  
-r--------  1 alex alex 2590 авг 16 13:11 id_rsa  

## перенос приватного ключа 

После копирования ключа его нужно добавить в агент  
ssh-add ~/.ssh/id_ed25519
Приватный ключ для ED25519 должен начинаться с:  
-----BEGIN OPENSSH PRIVATE KEY-----  
И заканчиваться на:  
-----END OPENSSH PRIVATE KEY-----  

## Чистим или удаляем known_hosts  
Очистка отпечатка ключа известного хоста - удаляем запись о нужном хосте к которому не можем подключиться. Т.е когда возникает ошибка вида
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @  
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
выполняем тогда команду:  
ssh-keygen -f "/home/alex/.ssh/known_hosts" -R "91.219.227.102"  

если хотим выйти то пишем exit  
если хотим выключить удаленную машину то sudo poweroff  

/etc/ssh/sshd_config        расположение ssh конфига
PubkeyAuthentication yes       должен быть параметр разрешающий аутентификацию по публичному ключу

в случае для образа cloud init необходимо для доступа к нему по ssh на хосте выдать правильные права для ключей
```bash
chmod 600 ~/.ssh/id_ed25519  # Для приватного ключа
chmod 644 ~/.ssh/id_ed25519.pub  # Для публичного ключа
```
Для terraform proxmox достаточно изменить ssh ключ в tf файле и применить на горячую на запущенные сервера и новый ключ будет сразу рабочим без перезагрузки всего и вся

``` bash
# Добавляем пользователя с именем 'user' и назначаем пароль 'password'
useradd -rm -d /home/user -s /bin/bash -G sudo -u 1001 user
echo 'user:mypass123' | chpasswd
# Создает нового пользователя с именем user.
# Назначает UID (идентификатор пользователя) 1001 этому пользователю.
# Создает домашний каталог /home/user для нового пользователя.
# Устанавливает Bash (/bin/bash) как оболочку по умолчанию.
# Добавляет пользователя в группу sudo, предоставляя ему права суперпользователя.

# Настраиваем SSH для входа под пользователем root
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config
echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config
echo 'UsePAM yes' >> /etc/ssh/sshd_config
```
или с помощью команды adduser  
Команда `adduser` — это более высокоуровневая утилита, чем `useradd`, и она предоставляет удобный интерфейс для создания нового пользователя с настройками по умолчанию. Команда `adduser` является более интерактивной и автоматически создает домашний каталог, копирует нужные файлы в этот каталог и выполняет другие действия по настройке.

Для выполнения тех же действий, что и в вашей команде `useradd`, с помощью команды `adduser`, команда будет выглядеть так:

```bash
sudo adduser --uid 1001 --home /home/user --shell /bin/bash --ingroup sudo user
```

1. **`sudo`**: Используем `sudo` для выполнения команды с правами суперпользователя, так как создание новых пользователей требует административных привилегий.

2. **`adduser`**: Команда для добавления нового пользователя.

3. **`--uid 1001`**: Указывает, что создаваемому пользователю нужно задать идентификатор пользователя (UID) 1001.

4. **`--home /home/user`**: Устанавливает домашний каталог для нового пользователя в `/home/user`.

5. **`--shell /bin/bash`**: Указывает оболочку по умолчанию для нового пользователя, в данном случае Bash.

6. **`--ingroup sudo`**: Задает основную группу для нового пользователя. Здесь это группа `sudo`, что дает пользователю права выполнять команды с повышенными привилегиями с помощью `sudo`.

7. **`user`**: Имя пользователя, которое будет создано.

### Описание команды

Эта команда `adduser` выполняет все те же действия, что и ваша команда `useradd`:

- Создает нового пользователя с именем `user`.
- Назначает пользователю UID 1001.
- Создает домашний каталог `/home/user`.
- Устанавливает оболочку Bash (`/bin/bash`).
- Добавляет пользователя в основную группу `sudo`.

Команда `adduser` автоматически создает домашний каталог, копирует необходимые файлы, такие как `.bashrc`, и правильно настраивает их. Она также выполняет дополнительные проверки, такие как проверка на существование UID и группы, что делает ее более безопасной и удобной для использования.

## Копирование по ssh

Чтобы скопировать файлы и папки на удаленный сервер через SSH, можно использовать команду `scp`. Вот основные примеры её использования:

1. **Копирование одного файла на удалённый сервер:**

   ```bash
   scp /путь/к/локальному/файлу username@remote_host:/путь/к/удаленному/каталогу/
   ```

   - `/путь/к/локальному/файлу` — путь к файлу на вашем локальном компьютере.
   - `username` — ваш логин на удаленном сервере.
   - `remote_host` — IP-адрес или доменное имя удаленного сервера.
   - `/путь/к/удаленному/каталогу/` — путь на удаленном сервере, куда вы хотите скопировать файл.

2. **Копирование директории на удалённый сервер (с использованием флага `-r` для рекурсивного копирования):**

   ```bash
   scp -r /путь/к/локальной/директории username@remote_host:/путь/к/удаленному/каталогу/
   ```
к примеру scp -r /home/alex/octobercms/storage alex@192.168.0.162:/home/alex/sambia

3. **Копирование файла с удаленного сервера на локальный компьютер:**

   ```bash
   scp username@remote_host:/путь/к/удаленному/файлу /путь/к/локальному/каталогу/
   ```

4. **Копирование директории с удаленного сервера на локальный компьютер (с использованием флага `-r`):**

   ```bash
   scp -r username@remote_host:/путь/к/удаленному/каталогу /путь/к/локальному/каталогу/
   ```

Для выполнения этих команд вам понадобится пароль для удаленного сервера или настроенный SSH-ключ для аутентификации без пароля.


# Пути, логи, конфигурации

Добавление репозитория вручную. Например, когда не получается добавить gpg ключ  
sudo nano /etc/apt/sources.list

## Nginx
 /var/www/html/index.html


# Установки приложений

https://hashicorp-releases.mcs.mail.ru/ релизы программ


## Установка Minikube и Terraform и packer, а так же бинарных версий

### Minikube  
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube  
sudo mkdir -p /usr/local/bin/  
sudo install minikube /usr/local/bin/  

### Terraform  

sudo snap install terraform --classic

или через бинарник
Берем с зеркала вк https://hashicorp-releases.mcs.mail.ru/
Копируем бинарник домашнюю директорию /home/alex  
Даем права на выполнение chmod +x terraform  
Устанавливаем sudo install terraform /usr/local/bin/  


обязательно меняем пути к провайдеру иначе terraform init не будет работать
Обход блокировки registry.terraform.io
В случае Terraform, обход блокировки осуществляется через конфигурацию стандартного зеркала для реестра провайдеров. Для этого нужно создать файл .terraformrc в домашнем каталоге 

В самом файле нужно сконфигурировать зеркало следующим образом:
``` conf
provider_installation {
  network_mirror {
    url     = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
После этого terraform init снова будет выполняться без проблем.


### Packer Установка
+ скачиваем packer
 https://developer.hashicorp.com/packer/install?product_intent=packer
 https://hashicorp-releases.mcs.mail.ru/packer/

```bash
sudo chmod +x packer
sudo mv packer /usr/local/bin/

#устанавливаем автокомплит
packer -autocomplete-install 

# установка плагина для  packer proxmox 
packer plugin install github.com/hashicorp/proxmox
```
  
  
# Разное

## Замена раскладки на alt shift
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"  
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"  
  
## переименовать хост  
sudo vim /etc/hostname 	задаем в этом файле имя, например alexcomp  

# Alias алиасы
Добавляем в файл .bashrc в домашней директории
```bash
alias pro="cd D/YANDEXDISK/1DEVOPS/alex-info"
alias lsa="ls -la"
alias t="terraform"
alias k="kubectl"
alias duh="du -h --max-depth=1"
```

# Файлы 
## Переименование и перемещение файлов и папок
Переместить или переименовать файл  
```bash
$ mv опции файл-источник файл-приемник  
mv file1 directory1 	скопировать file1 в директорию directory1  
mv file1 ./directory1 	тоже самое  
```


```bash
du -ah --max-depth=1
```
- `-a` (all) — показывает размеры всех файлов и директорий.
- `-h` (human-readable) — выводит в удобочитаемом формате.
- `--max-depth=1` — ограничивает глубину просмотра, показывая только объекты текущего уровня.

с обратной сортировкой

```bash
du -ah --max-depth=1 | sort -hr
```

Эта команда покажет размеры как папок, так и отдельных файлов в текущей директории.


## Копирование
Копирование файла в другой файл с указанным именем:  

cp опции /путь/к/файлу/источнику /путь/к/файлу/назначения  

Полное копирование, пример
```bash
sudo cp -a /tmp/wordpress/. /var/www/wordpress
```

## УДАЛЕНИЕ
Для удаления директорий, вместе с файлами и поддиректориями используется опция -R, например:
 rm -Rf /home/user/dir
 sudo rm -Rf *
 

# РАБОТА С ДИСКОМ

sudo fdisk -l 	список всех дисков

## МОНТИРОВАНИЕ ПРИ ЗАГРУЗКЕ ОС
 vi /etc/fstab
 Пример: /dev/sda1     /db     xfs     defaults     0 0
+ /dev/sda1 — диск, который мы монтируем
+ /db — каталог, в который монтируем диск
+ xfs — файловая система
+ defaults — стандартные опции. Полный их перечень можно посмотреть на Википеции.
+ 0 0 — первый отключает создание резервных копий при помощи утилиты dump, второй отключает проверку диска.

Монтируем свой диск D - добавляем строку в файл и потом создаем папку для монтирования
/dev/nvme0n1p5  /home/alex/D ntfs3 defaults 0 0 


## Создаем таблицу и раздел

sudo fdisk /dev/sda выбираем для интерактивного взаимодействия нужный диск
	g создаем таблицу GPT
	n создаем новый разделам
	w записываем изменения на диск

## Форматируем
sudo mkfs.ntfs -f  -L AlexDisk /dev/sda1 форматируем раздел в ntfs в быстром режиме

sudo mkfs -t ext4  -f -L AlexDisk /dev/sda1 	или форматируем в ext4 в быстром режиме

## Монтируем
mkdir /home/alex/flash
sudo mount /dev/sda1 /home/alex/flash/


# ПАКЕТЫ
dpkg -l 						просмотреть все пакеты установленные в системе  
dpkg -s имяпакета 				инфа о пакете, зависимостях  
dpkg -L имяпакета 				файлы пакета  

apt remove –purge имяпакета удаление пакета со всеми настройками  
sudo apt remove --purge virtualbox virtualbox-*  
После удаления можно также очистить ненужные зависимости и остаточные конфигурационные файлы:
sudo apt autoremove --purge

apt remove имяпакета 		удаление пакетов без удаления настроек  
apt policy имяпакета 		посмотреть какие версии пакета есть в репозитории  
apt install имяпакета=2.0 	установка пакета нужной версии  
apt search 	подстрока_пакета	поиск совпадений среди пакетов	


# ПОИСК

find ~/Downloads -type f -mtime +35 -delete		поиск файлов старше 35 дней и удаление
find / -name “myhelp.txt”
find гдеищем -name “чтоищем”
поиск файлов по имени
find /var/log -type d такая команда даст нам все поддиректории директории /var/log 
find /var/log -type f покажет нам все файлы

# CRON
crontab -l		просмотреть задачи текущего пользователя
crontab -e  	редактирование задач текущего пользователя
минута час день месяц день_недели /путь/к/исполняемому/файлу
 обязательно enter

# АРХИВАЦИЯ

## 7z
7z или zip
7z x файл.zip -o /tmp/ или .7z  распаковать в папку
7z x файл.zip или .7z 			распаковать в текущую папку
7z l файл.7z или .zip 			просмотр архива 
7z a Tutorial.7z tutorial/ 		Добавить в архив

## zip
unzip file1.zip					распаковать архив в текущую директорию
unzip -l zipped_file.zip 		просмотреть файлы архива без распаковки
zip output_file.zip input_file	зархивировать 1 файл
zip -r output.zip input_folder	запаковать папку

## tar

Запаковать
tar -czvf site_backup.tar.gz public_html
+ -c — создание архива.
+ -z — сжатие архива с помощью gzip.
+ -v — вывод информации о процессе архивирования.
+ -f — имя создаваемого файла.
+ . — указывает, что нужно архивировать все файлы из текущей директории.

распаковать
tar -xzvf site_backup.tar.gz -C /path/to/destination/
+ -x — извлечь файлы из архива.
+ -z — использовать gzip для распаковки (так как файл сжат с использованием gzip).
+ -v — выводить информацию о процессе распаковки (опционально).
+ -f — указывает файл архива.


# ПРОЦЕССЫ
ps -auxf

ВЫВОД
cat file1 file2  			выведет содержимое 2ух файлов 
cat file1 file2 > file3 	перезапишет file3 объединенным содержимым file1 file2
cat file1 file2 >> file3 	дополнит file3 объединенным содержимым file1 file2

heredocument
```bash
cat <<EOF > ~.terraformrc
provider_installation {
  network_mirror {
    url     = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF
```

sleep 10 &                  Символ & в конце команды в Linux (и других Unix-подобных операционных системах) используется для запуска команды в фоновом режиме.

Символ **`&&`** в Shell используется для выполнения команд с условием: следующая команда выполняется только в том случае, если предыдущая команда завершилась успешно (то есть, с кодом возврата 0). Вот основные варианты использования **`&&`**:

1. **Последовательное выполнение команд**:
   - Если первая команда завершилась успешно, выполняется вторая команда. 

   command1 && command2  

   В этом примере, `command2` будет выполнена только в случае успешного завершения `command1`.

2. **Комбинирование с другими логическими операторами**:
   - Вы можете комбинировать **`&&`** с другими операторами, такими как **`||`**, для создания сложной логики выполнения.

   command1 && command2 || command3  

   В этом случае:
   - Если `command1` выполнится успешно, будет выполнена `command2`.
   - Если `command1` завершится с ошибкой, будет выполнена `command3`.

3. **Состояние выполнения нескольких команд**:
   - Вы можете использовать **`&&`** для проверки последовательности выполнения нескольких команд.

   command1 && command2 && command3  


   Все три команды будут выполняться последовательно, при этом каждая следующая команда будет выполняться только если предыдущая завершилась успешно.

4. **Использование в скриптах**:
   - **`&&`** часто используется в скриптах для управления потоком выполнения.

   ```bash
   #!/bin/bash
   mkdir new_directory && cd new_directory && touch file.txt
   ```

   В этом примере:
   - Директория `new_directory` создается, и если она создана успешно, выполняется переход в нее и создание файла `file.txt`.

5. **Проверка нескольких условий**:
   - Можно использовать **`&&`** для проверки нескольких условий в одном выражении.

   ```bash
   [ -f file.txt ] && echo "File exists"
   ```

   Здесь сообщение будет выведено только в том случае, если файл `file.txt` существует.

6. **Использование с командами, которые возвращают код ошибки**:
   - Вы можете использовать **`&&`** с командами, которые возвращают ненулевой код ошибки, чтобы избежать выполнения последующих команд.

   ```bash
   rm important_file && echo "File deleted successfully"
   ```

   Если команда `rm` завершится с ошибкой (например, если файл не существует), сообщение не будет выведено.

## разное
du -sh * 	размеры файлов и папок в текущей директории
free -h 	свободная  оперативная память
df -h 		занятое место на дисках
sudo lsblk	инфа о разделах на диске

## ПРОВЕРКА BASH СКРИПТОВ

bash -n: Проверяет синтаксис скрипта без его выполнения.
shellcheck: Анализирует скрипт и предоставляет рекомендации по улучшению, а также находит потенциальные ошибки.
set -n: Встроенная команда для проверки синтаксиса внутри самого скрипта.
bash -x: Для отладки скрипта и пошагового выполнения.


# ПРАВА ГРУППЫ ПОЛЬЗОВАТЕЛИ

## chmod
groups			список групп в которых состоит текущий пользователь  
chmod +x myfile  						добавляет права на выполнение для пользователя, группы и остальных  
chmod u=rwx,g=rx,o=r /home/user/dir1	присваивает определенные права  
chmod u=rwx,g=rx,o=r dir1 				тут присваиваем нужные права для пользователя, группы и остальных
  
### Права 777
В Linux права доступа к файлам и каталогам управляются с помощью трёхзначного числа, где каждая цифра соответствует определённой группе пользователей и определяет их права:

### Группы пользователей:
1. **Первая цифра**: права для владельца файла (owner).
2. **Вторая цифра**: права для группы, которой принадлежит файл (group).
3. **Третья цифра**: права для всех остальных (others).

### Каждая цифра — сумма следующих прав:
- **4 (r)** — право чтения (read).
- **2 (w)** — право записи (write).
- **1 (x)** — право выполнения (execute).

### Как складываются права?
Чтобы задать определённое право, цифры складываются. Например:
- 7 = 4 (чтение) + 2 (запись) + 1 (выполнение) — полный доступ.
- 6 = 4 (чтение) + 2 (запись) — чтение и запись.
- 5 = 4 (чтение) + 1 (выполнение) — чтение и выполнение.


## chown
chown пользователь опции /путь/к/файлу  
sudo chown alex:alex terraform			сменить пользователя и группу для файла или папки  
sudo chown -R alex:alex terraform			сменить пользователя и группу для файла или папки рекурсивно
sudo chown -R alex:alex \!DEVOPS\ VIDEO/ 	где значек \  это экранирование символа

## adduser
Команда `adduser` — это более высокоуровневая утилита, чем `useradd`, и она предоставляет удобный интерфейс для создания нового пользователя с настройками по умолчанию. Команда `adduser` является более интерактивной и автоматически создает домашний каталог, копирует нужные файлы в этот каталог и выполняет другие действия по настройке.

Для выполнения тех же действий, что и в вашей команде `useradd`, с помощью команды `adduser`, команда будет выглядеть так:

```bash
sudo adduser --uid 1001 --home /home/user --shell /bin/bash --ingroup sudo user
```

### Разбор параметров команды `adduser`

1. **`sudo`**: Используем `sudo` для выполнения команды с правами суперпользователя, так как создание новых пользователей требует административных привилегий.

2. **`adduser`**: Команда для добавления нового пользователя.

3. **`--uid 1001`**: Указывает, что создаваемому пользователю нужно задать идентификатор пользователя (UID) 1001.

4. **`--home /home/user`**: Устанавливает домашний каталог для нового пользователя в `/home/user`.

5. **`--shell /bin/bash`**: Указывает оболочку по умолчанию для нового пользователя, в данном случае Bash.

6. **`--ingroup sudo`**: Задает основную группу для нового пользователя. Здесь это группа `sudo`, что дает пользователю права выполнять команды с повышенными привилегиями с помощью `sudo`.

7. **`user`**: Имя пользователя, которое будет создано.


### Описание команды

Эта команда `adduser` выполняет все те же действия, что и ваша команда `useradd`:

- Создает нового пользователя с именем `user`.
- Назначает пользователю UID 1001.
- Создает домашний каталог `/home/user`.
- Устанавливает оболочку Bash (`/bin/bash`).
- Добавляет пользователя в основную группу `sudo`.

Команда `adduser` автоматически создает домашний каталог, копирует необходимые файлы, такие как `.bashrc`, и правильно настраивает их. Она также выполняет дополнительные проверки, такие как проверка на существование UID и группы, что делает ее более безопасной и удобной для использования.



# TERRAFORM

terraform validate && terraform plan 	проверка все конфигурационных файлов tf
terraform apply 						применение всех файлов и создание ресурсов в облаке
terraform destroy						удаление всех ресурсов из облака

