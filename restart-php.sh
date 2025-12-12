#!/bin/bash

# Script para reiniciar o container PHP com as novas configurações de porta

echo "🔄 Reiniciando container PHP..."

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

# Parar e remover container PHP
echo "🛑 Parando container PHP..."
$COMPOSE_CMD stop php
$COMPOSE_CMD rm -f php

# Recriar container PHP
echo "🚀 Recriando container PHP com nova configuração..."
$COMPOSE_CMD up -d php

echo "✅ Container PHP reiniciado!"
echo ""
echo "💡 Agora execute: ./run-server.sh"
echo "   E acesse: http://localhost:8055"

