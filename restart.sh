#!/bin/bash

# Script para reiniciar os containers usando docker-compose

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

echo "🔄 Reiniciando containers..."

$COMPOSE_CMD restart

echo "✅ Containers reiniciados"
