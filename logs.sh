#!/bin/bash

# Script para ver logs dos containers

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

# Verificar se foi passado um serviço específico
if [ -n "$1" ]; then
    echo "📋 Logs do serviço: $1"
    $COMPOSE_CMD logs -f "$1"
else
    echo "📋 Logs de todos os serviços (Ctrl+C para sair)"
    $COMPOSE_CMD logs -f
fi

