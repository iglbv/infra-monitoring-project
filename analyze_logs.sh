#!/bin/bash

LOG_FILE="access.log"

echo "Генерация тестового файла $LOG_FILE..."

ips=("192.168.1.10" "10.0.0.5" "172.16.0.1" "192.168.1.20" "8.8.8.8" "192.168.1.50")
methods=("GET" "POST" "PUT" "DELETE")
endpoints=("/api/users" "/api/login" "/index.html" "/api/products" "/dashboard" "/contacts")
statuses=("200" "201" "400" "401" "404" "500" "503")

> "$LOG_FILE"

for i in {1..350}; do
    if [ $((i % 3)) -eq 0 ]; then
        ip=${ips[0]}
    elif [ $((i % 5)) -eq 0 ]; then
        ip=${ips[1]}
    else
        ip=${ips[$((RANDOM % ${#ips[@]}))]}
    fi

    method=${methods[$((RANDOM % ${#methods[@]}))]}
    endpoint=${endpoints[$((RANDOM % ${#endpoints[@]}))]}
    status=${statuses[$((RANDOM % ${#statuses[@]}))]}
    
    echo "$ip - - [15/Aug/2026:10:15:$((10 + i % 50))] $method $endpoint HTTP/1.1 $status" >> "$LOG_FILE"
done

echo "Файл $LOG_FILE успешно создан."
echo "--------------------------------------------------"

if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: Файл $LOG_FILE не найден!"
    exit 1
fi

total_requests=$(wc -l < "$LOG_FILE")
top_ips=$(grep -E -o "^([0-9]{1,3}\.){3}[0-9]{1,3}" "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 3)
error_requests=$(awk '$NF ~ /^[45][0-9][0-9]$/ {count++} END {print count+0}' "$LOG_FILE")

echo "РЕЗУЛЬТАТЫ АНАЛИЗА ЛОГОВ:"
echo "**Общее количество запросов:** $total_requests"
echo ""
echo "**Топ-3 IP-адреса:**"
echo "$top_ips" | awk '{print "  - IP: " $2 " (Запросов: " $1 ")"}'
echo ""
echo "**Количество ошибок (4xx и 5xx):** $error_requests"
