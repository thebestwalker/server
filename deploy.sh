#!/bin/bash

# Цвета для вывода
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

# Docker
install_docker() {
  echo -e "${GREEN}Установка Docker...${NC}"
  sudo apt-get update
  sudo apt-get install ca-certificates curl git
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo -e "${GREEN}Docker успешно установлен.${NC}"
}

# Docker Compose
install_docker_compose() {
  echo -e "${GREEN}Установка Docker Compose...${NC}"
  sudo apt-get update
  sudo apt-get install docker-compose-plugin
  echo -e "${GREEN}Docker Compose успешно установлен.${NC}"
}

# Проверка Docker
if [ -x "$(command -v docker)" ]; then
    echo -e "${GREEN}Docker уже установлен.${NC}"
else
    install_docker
fi

# Проверка Docker Compose
if [ -x "$(command -v docker-compose)" ]; then
    echo -e "${GREEN}Docker Compose уже установлен.${NC}"
else
    install_docker_compose
fi

# Определяем переменные окружения
export ENVIRONMENT=production

echo -e "${GREEN}Начинаем развертывание для среды $ENVIRONMENT...${NC}"
sudo apt-get install git
git clone https://github.com/knaopel/docker-frontend-backend-db.git
# Переходим в каталог проекта
cd docker-frontend-backend-db
# Строим Docker образы
echo -e "${GREEN}Сборка Docker образов...${NC}"
docker compose build --no-cache

# Запускаем контейнеры
echo -e "${GREEN}Запуск контейнеров...${NC}"
docker compose up -d

# Ждем запуска контейнеров
echo -e "${GREEN}Ожидание старта контейнеров...${NC}"
sleep 10

# Проверяем здоровье сервисов
echo -e "${GREEN}Проверка здоровья сервисов...${NC}"
if curl -s http://localhost:3000 | grep -q 'Web site created using create-react-app'; then
  echo -e "${GREEN}Фронтенд отвечает корректно!${NC}"
else
  echo -e "${RED}Ошибка: Фронтенд не отвечает!${NC}"
  exit 1
fi

if curl -s http://localhost:3001/api | grep -q 'main page'; then
  echo -e "${GREEN}Бэкенд отвечает корректно!${NC}"
else
  echo -e "${RED}Ошибка: Бэкенд не отвечает!${NC}"
  exit 1
fi

echo -e "${GREEN}Все сервисы работают. Развертывание завершено успешно.${NC}"
