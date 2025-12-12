#!/bin/bash

# Script para executar containers usando docker-compose

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

echo "Starting containers with Docker Compose..."
$COMPOSE_CMD up -d

echo "All containers are running!"
echo "MySQL: localhost:33063"
echo "Laravel: localhost:8055 (execute ./run-server.sh)"
echo "Vite: localhost:5173"
