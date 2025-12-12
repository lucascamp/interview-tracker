#!/bin/bash

# Script para executar containers em modo produção usando docker-compose

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

echo "Starting containers in production mode with Docker Compose..."
$COMPOSE_CMD --profile production up -d

echo "All containers are running!"
echo "MySQL: localhost:33063"
echo "Application: http://localhost (via Nginx)"
echo "Application (alt): http://localhost:8055"
