#!/bin/bash

file="static.log"
host=$1
port=$2

# Проверка количества аргументов
if (( $# != 2 )); then
    echo "Usage: $0 <host> <port>"
    exit 1
fi

# Проверка наличия nc
if ! command -v nc &> /dev/null; then
    echo "Установка netcat..."
    sudo apt update
    sudo apt install -y netcat-openbsd
fi

# Создание файла лога с заголовком при первом запуске
if [ ! -f "$file" ]; then
    cat << HEADER > "$file"
=====================================================
Лог приложения для сбора статистики $(date +%Y-%m-%d)
Версия: 1.0
=====================================================
HEADER
fi

# Проверка доступности хоста по порту
if nc -z -w 3 "$host" "$port" 2>/dev/null; then
    # Хост доступен - выводим сообщение в консоль
    echo "Хост $host порт $port доступен"
else
    # Хост недоступен - записываем в лог
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] Хост $host порт $port недоступен" >> "$file"
fi