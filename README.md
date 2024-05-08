# Dockerized Web Application Deployment
![Демонстрация](https://github.com/thebestwalker/server/blob/main/a.gif)
## Описание проекта
Этот проект представляет собой полное решение для развертывания веб-приложения с использованием Docker и автоматизации с помощью Bash скриптов. В проект входят компоненты фронтенда, бэкенда и базы данных, каждый из которых запускается в отдельном Docker контейнере.

## Предварительные требования
Для работы с проектом необходимы следующие компоненты:
- Git
- Docker
- Docker Compose

## Скачивание
### Шаг 1: Клонирования репотизория
 
```bash
git clone https://github.com/thebestwalker/server.git
cd server
```

## Установка
### Шаг 1: Предоставление прав на выполнение
Перед запуском, необходимо предоставить скрипту `deploy.sh` права на выполнение. Это можно сделать с помощью следующей команды:

```bash
chmod +x deploy.sh
```

### Шаг 2: Установка Docker и Docker Compose
Скрипт `deploy.sh` автоматически проверяет наличие Docker и Docker Compose в системе и при необходимости устанавливает их. Для запуска скрипта используйте следующую команду:

```bash
sudo ./deploy.sh
```

# Документация deploy.sh
## Описание
Этот скрипт автоматизирует процесс развертывания веб-приложения, включая установку Docker и Docker Compose, сборку Docker образов, запуск контейнеров и проверку их работоспособности.

### Обновление системы и установка Docker
```bash
sudo apt-get update && sudo apt-get install -y ca-certificates curl
```
Этот блок кода выполняет обновление списка пакетов и устанавливает необходимые зависимости для работы с Docker и HTTPS запросами.

### Добавление GPG ключа Docker
```bash
Copy code
# Добавление GPG ключа Docker
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
Здесь скрипт создает директорию для ключей APT, загружает официальный GPG ключ Docker и устанавливает права для его чтения. Это необходимо для безопасной установки Docker из официального репозитория.

### Добавление репозитория Docker в APT
```bash
Copy code
# Добавление Docker репозитория в список источников APT
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $OS_VERSION_CODENAME stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
Эта команда добавляет новый репозиторий в систему APT, который позволяет установить последнюю версию Docker.

### Установка Docker CE, Docker CE CLI и Containerd.io
```bash
Copy code
# Установка Docker CE, Docker CE CLI и Containerd.io
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```
После добавления репозитория выполняется установка Docker CE (Community Edition), CLI и Containerd, что является основой для работы с контейнерами.

### Клонирование репозитория и сборка образов
```bash
# Клонирование и сборка
git clone https://github.com/knaopel/docker-frontend-backend-db.git
cd docker-frontend-backend-db
docker compose build --no-cache
```
Скрипт клонирует репозиторий с компонентами вашего веб-приложения и запускает сборку Docker образов с помощью Docker Compose без использования кэша.

### Запуск контейнеров
```bash
docker compose up -d
```
Эта команда запускает все контейнеры в фоновом режиме. Флаг -d означает detached mode.

Проверка состояния сервисов
```bash
# Проверка сервисов
if curl -s http://localhost:3000 | grep -q 'Web site created using create-react-app'; then
  echo "Фронтенд отвечает корректно!"
else
  echo "Ошибка: Фронтенд не отвечает!"
  exit 1
fi

if curl -s http://localhost:3001/api | grep -q 'main page'; then
  echo "Бэкенд отвечает корректно!"
else
  echo "Ошибка: Бэкенд не отвечает!"
  exit 1
fi
```
Этот раздел выполняет проверку доступности фронтенда и бэкенда вашего приложения через HTTP запросы, используя curl. Это помогает убедиться, что все компоненты функционируют правильно после запуска.

