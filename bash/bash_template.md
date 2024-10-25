Вот те же шаблоны с построчными комментариями, как ты просил.

### 1. Пример с условием `if-else`

```bash
#!/bin/bash

FILE="/path/to/file"  # Указываем путь к файлу, который будем проверять

# Проверяем, существует ли файл
if [ -f "$FILE" ]; then
    echo "Файл $FILE существует."  # Если файл существует, выводим сообщение
    # Здесь можно добавить действия для случая, если файл существует
else
    echo "Файл $FILE не существует."  # Если файл не существует, выводим другое сообщение
    # Здесь можно добавить действия для случая, если файл не найден
fi
```

### 2. Пример с циклом `for`

```bash
#!/bin/bash

# Перебираем каждый файл в указанной директории
for file in /path/to/directory/*; do
    # Проверяем, является ли элемент файлом
    if [ -f "$file" ]; then
        echo "Обработка файла: $file"  # Выводим сообщение об обработке файла
        # Здесь можно добавить действия для каждого файла
    fi
done
```

### 3. Пример с циклом `while`

```bash
#!/bin/bash

counter=1  # Инициализируем счетчик

# Цикл будет выполняться, пока значение счетчика не станет больше 5
while [ $counter -le 5 ]; do
    echo "Итерация $counter"  # Выводим номер текущей итерации
    ((counter++))  # Увеличиваем значение счетчика на 1
    # Здесь можно добавить любые действия для каждой итерации
done
```

### 4. Пример с конструкцией `case`

```bash
#!/bin/bash

# Просим пользователя ввести число от 1 до 3
read -p "Введите число от 1 до 3: " number

# Проверяем, какое значение ввел пользователь
case $number in
    1)
        echo "Вы выбрали 1"  # Сообщение для варианта 1
        # Действие для выбора 1
        ;;
    2)
        echo "Вы выбрали 2"  # Сообщение для варианта 2
        # Действие для выбора 2
        ;;
    3)
        echo "Вы выбрали 3"  # Сообщение для варианта 3
        # Действие для выбора 3
        ;;
    *)
        echo "Неверный ввод. Введите число от 1 до 3."  # Сообщение для неверного ввода
        # Действие для неверного ввода
        ;;
esac
```

### 5. Пример с условием `if-elif-else`

```bash
#!/bin/bash

NUM=5  # Инициализируем переменную с числом

# Проверяем, меньше ли число 5
if [ $NUM -lt 5 ]; then
    echo "Число меньше 5"  # Выводим сообщение, если число меньше 5
# Проверяем, равно ли число 5
elif [ $NUM -eq 5 ]; then
    echo "Число равно 5"  # Выводим сообщение, если число равно 5
# Во всех остальных случаях
else
    echo "Число больше 5"  # Выводим сообщение, если число больше 5
fi
```

### 6. Пример с использованием команды `find` и цикла `for`

```bash
#!/bin/bash

# Используем команду `find`, чтобы найти все файлы с расширением .txt в указанной директории
for file in $(find /path/to/directory -name "*.txt"); do
    echo "Найден файл: $file"  # Выводим путь к найденному файлу
    # Добавьте действия с найденным файлом
done
```

### 7. Пример с функцией и циклом `while`

```bash
#!/bin/bash

# Определяем функцию countdown, которая принимает один аргумент (число)
function countdown {
    number=$1  # Присваиваем значение аргумента переменной number
    # Пока число больше 0
    while [ $number -gt 0 ]; do
        echo "Осталось: $number"  # Выводим оставшееся число
        ((number--))  # Уменьшаем значение числа на 1
        sleep 1  # Задержка в 1 секунду
    done
    echo "Время истекло!"  # Сообщаем, что время истекло
}

countdown 10  # Вызываем функцию с аргументом 10
```

### 8. Пример с использованием массива

```bash
#!/bin/bash

# Объявляем массив с тремя элементами
my_array=("элемент1" "элемент2" "элемент3")

# Перебираем массив
for item in "${my_array[@]}"; do
    echo "Текущий элемент: $item"  # Выводим текущий элемент массива
    # Можно добавить действия для каждого элемента массива
done
```

Эти комментарии помогут понять каждую строку кода и позволят легко адаптировать скрипты под конкретные задачи.