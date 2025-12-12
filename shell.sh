#!/bin/bash

# Script para entrar no shell de um container

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

# Serviço padrão
SERVICE=${1:-php}

case $SERVICE in
    php)
        echo "🐘 Entrando no container PHP..."
        docker exec -it interview-tracker-php bash
        ;;
    node)
        echo "📦 Entrando no container Node..."
        docker exec -it interview-tracker-node sh
        ;;
    mysql)
        echo "🗄️  Entrando no container MySQL..."
        docker exec -it interview-tracker-mysql bash
        ;;
    *)
        echo "❌ Serviço não reconhecido: $SERVICE"
        echo "Uso: ./shell.sh [php|node|mysql]"
        exit 1
        ;;
esac

