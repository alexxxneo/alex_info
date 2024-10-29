Частые
`ansible all -m ping` пропинговать все хосты
`ansible-galaxy init myrole` создание роли
`ansible-playbook <playbook>.yml --check` – выполнить плейбук в режиме проверки.
`ansible-playbook site.yml -v` выполнение плейбука с отладочной информацией
`ansible <host_group> -m shell -a "<command>"` – использовать модуль `shell` для выполнения команд оболочки.
`ansible <host_group> -m debug -a "var=<variable>"` – вывести значение переменной.



### Основные команды
1. `ansible all -m ping` – проверить соединение с узлами инвентори.
2. `ansible-playbook <playbook>.yml` – выполнить плейбук.
3. `ansible-inventory --list -i <inventory>` – показать инвентарь в формате JSON.
4. `ansible <host_group> -m setup` – получить информацию о системе для всех узлов группы.
5. `ansible-doc -l` – показать список всех доступных модулей Ansible.
6. `ansible-doc -s <module_name>` – показать параметры модуля.
7. `ansible-galaxy install <role_name>` – установить роль из Ansible Galaxy.
8. `ansible-galaxy init <role_name>` – создать шаблон роли.
9. `ansible-vault create <file>` – создать зашифрованный файл.
10. `ansible-vault edit <file>` – редактировать зашифрованный файл.

### Команды для выполнения задач на узлах
11. `ansible <host_group> -a "<command>"` – выполнить команду на узлах.
12. `ansible <host_group> -m command -a "<command>"` – использовать модуль `command` для выполнения команды.
13. `ansible <host_group> -m shell -a "<command>"` – использовать модуль `shell` для выполнения команд оболочки.
14. `ansible <host_group> -m copy -a "src=<file> dest=<path>"` – скопировать файл на узлы.
15. `ansible <host_group> -m file -a "path=<path> state=absent"` – удалить файл или директорию на узлах.
16. `ansible <host_group> -m yum -a "name=<package> state=present"` – установить пакет на RedHat-базированных системах.
17. `ansible <host_group> -m apt -a "name=<package> state=present"` – установить пакет на Debian-базированных системах.
18. `ansible <host_group> -m service -a "name=<service> state=started"` – запустить сервис на узлах.
19. `ansible <host_group> -m user -a "name=<username> state=present"` – создать пользователя на узлах.
20. `ansible <host_group> -m cron -a "name=<job> minute=0 hour=1 job='<command>'"` – добавить задание в cron на узлах.

### Управление инвентарем и узлами
21. `ansible-inventory --graph -i <inventory>` – графически показать структуру инвентаря.
22. `ansible all -m ping -i <inventory>` – проверить доступность узлов по инвентарю.
23. `ansible all -m setup --tree out/` – сохранить данные фактов в виде дерева в папке `out`.
24. `ansible <host_group> -m debug -a "var=hostvars['<hostname>']"` – показать переменные для конкретного узла.
25. `ansible-inventory -i <inventory> --list | jq` – отформатировать вывод инвентаря с помощью `jq` (для удобного чтения JSON).

### Команды для работы с переменными и фактами
26. `ansible <host_group> -m debug -a "var=<variable>"` – вывести значение переменной.
27. `ansible <host_group> -m setup -a "filter=*memory*"` – получить информацию о памяти узлов.
28. `ansible <host_group> -m setup -a "filter=ansible_distribution*"` – показать информацию о дистрибутиве ОС.
29. `ansible <host_group> -m setup -a "gather_subset=!all,!min,network"` – собрать только сетевые факты.
30. `ansible-playbook <playbook>.yml --extra-vars "key=value"` – передать дополнительные переменные в плейбук.

### Запуск плейбуков
31. `ansible-playbook <playbook>.yml --limit <host_group>` – запустить плейбук для конкретной группы хостов.
32. `ansible-playbook <playbook>.yml --tags <tag>` – запустить только задачи с указанными тегами.
33. `ansible-playbook <playbook>.yml --skip-tags <tag>` – пропустить задачи с указанными тегами.
34. `ansible-playbook <playbook>.yml --check` – выполнить плейбук в режиме проверки.
35. `ansible-playbook <playbook>.yml --diff` – показать различия в файлах, которые будут изменены.
36. `ansible-playbook <playbook>.yml --step` – выполнять плейбук пошагово.
37. `ansible-playbook <playbook>.yml --start-at-task "<task_name>"` – начать выполнение с определенной задачи.
38. `ansible-playbook <playbook>.yml -e "key=value"` – передать переменные командной строкой.
39. `ansible-playbook <playbook>.yml -i <inventory>` – указать инвентарь для плейбука.
40. `ansible-playbook <playbook>.yml -K` – запросить пароль sudo для выполнения плейбука.

### Работа с Vault (зашифрованными данными)
41. `ansible-vault encrypt <file>` – зашифровать файл.
42. `ansible-vault decrypt <file>` – расшифровать файл.
43. `ansible-vault view <file>` – просмотреть зашифрованный файл.
44. `ansible-vault rekey <file>` – изменить пароль для зашифрованного файла.
45. `ansible-playbook <playbook>.yml --ask-vault-pass` – запросить пароль Vault при запуске плейбука.

### Отладка и диагностика
46. `ansible-playbook <playbook>.yml -vvv` – запустить плейбук в режиме подробной отладки.
47. `ansible <host_group> -m debug -a "msg='Hello World'"` – вывести отладочное сообщение на узлы.
48. `ansible <host_group> -m debug -a "var=<variable>"` – вывести значение переменной для отладки.
49. `ansible-playbook <playbook>.yml --list-hosts` – показать узлы, на которые будет направлен плейбук.
50. `ansible-playbook <playbook>.yml --syntax-check` – проверить синтаксис плейбука.

### Управление ролями
51. `ansible-galaxy search <role>` – найти роли в Ansible Galaxy.
52. `ansible-galaxy remove <role_name>` – удалить роль.
53. `ansible-galaxy list` – отобразить установленные роли.
54. `ansible-galaxy install -r requirements.yml` – установить роли из файла требований.
55. `ansible-galaxy collection install <collection>` – установить коллекцию Ansible.

### Управление коллекциями
56. `ansible-galaxy collection list` – показать установленные коллекции.
57. `ansible-galaxy collection search <name>` – найти коллекцию по названию.
58. `ansible-galaxy collection build <path>` – собрать коллекцию из указанного пути.
59. `ansible-galaxy collection publish <collection_name>` – опубликовать коллекцию.
60. `ansible-galaxy collection install -r requirements.yml` – установить коллекции из файла требований.

### Обработка ошибок и перезапуск задач
61. `ansible-playbook <playbook>.yml --force-handlers` – выполнить обработчики немедленно.
62. `ansible-playbook <playbook>.yml --flush-cache` – очистить кэш фактов.
63. `ansible-playbook <playbook>.yml --start-at-task "<task_name>"` – начать выполнение с определенной задачи.
64. `ansible <host_group> -m fail -a "msg='This is a test failure'"` – искусственно вызвать ошибку.

### Управление узлами (поиск, метки и фильтры)
65. `ansible all --list-hosts` – список всех узлов инвентаря.
66. `ansible <host_group> -m debug -a "msg='Running on node: {{ inventory_hostname }}'"` – вывести имя узла.
67. `ansible <host_group> -a "/sbin/reboot"` – перезагрузить узлы.
68. `ansible-playbook <playbook>.yml --limit <hostname>` – запуск плейбука только на определенном узле.
69. `ansible-playbook <playbook>.yml --limit '!<host_group>'` – исключить группу узлов.

### Использование фильтров и условий
70. `ansible <host_group> -m copy -a "src=<file> dest=<path>" --limit <host>` – копировать файл на узел с фильтрацией по имени.
71. `ansible <host_group>

 -m shell -a "hostname" --limit <ip_address>` – выполнить команду на узлах с конкретным IP.
72. `ansible <host_group> -m ping --forks 10` – выполнить команду параллельно на нескольких узлах.

Этот набор команд покрывает большинство задач и позволяет эффективно управлять инфраструктурой с помощью Ansible.