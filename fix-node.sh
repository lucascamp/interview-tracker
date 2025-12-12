#!/bin/bash

# Script para corrigir problemas do Node

echo "🔧 Corrigindo Node.js..."

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

# Parar container Node
echo "🛑 Parando container Node..."
$COMPOSE_CMD stop node

# Remover container
echo "🗑️  Removendo container Node..."
$COMPOSE_CMD rm -f node

# Limpar node_modules do volume
echo "🧹 Limpando node_modules..."
docker volume rm interview_node_modules 2>/dev/null || echo "Volume não existe"

# Reinstalar dependências no container
echo "📦 Reinstalando dependências..."
docker run --rm \
    -v "$(pwd)":/app \
    -w /app \
    node:20-alpine \
    sh -c "rm -rf node_modules && npm install"

# Reiniciar container Node
echo "🚀 Reiniciando container Node..."
$COMPOSE_CMD up -d node

echo "✅ Node.js corrigido!"
echo ""
echo "💡 Aguarde alguns segundos e verifique os logs:"
echo "   docker logs -f interview-tracker-node"

