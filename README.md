# infra-monitoring-project

# Процесс безопасной передачи файлов проекта на удалённый сервер:

1. Генерация SSH-ключей
Используем алгоритм ed25519:
Создаем пару ключей - приватный и публичный:
ssh-keygen -t ed25519 -C "ilyagolubev2021@gmail.com@

2. Копирование публичного ключа на сервер:
Копируем публичный ключ в файл ~/.ssh/authorized_keys
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@address.server.com
После этого можно подключаться без ввода пароля

3. Передача архива проекта через scp или tar + ssh
Сжимаем проект в поток данных и передаем по SSH
tar -czf - --exclude='.git' --exclude='node_modules' ./infra-monitoring | ssh golubev@address.server.com "tar -xzf - -C /home"

Примеры команд для деплоя:
tar -czf - docker-compose.yml nginx.conf | ssh golubev@server "mkdir -p /app/monitoring && tar -xzf - -C /app/monitoring"
ssh golubev@server "cd /app/monitoring && docker compose up -d"
