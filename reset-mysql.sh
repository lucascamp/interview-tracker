#!/bin/bash

# Script para resetar o MySQL (limpar volume e reiniciar)

echo "🔄 Resetando MySQL..."

# Verificar qual comando usar
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose não encontrado"
    exit 1
fi

# Parar containers
echo "🛑 Parando containers..."
$COMPOSE_CMD down

# Remover volume do MySQL
echo "🗑️  Removendo volume do MySQL..."
docker volume rm interview_mysql_data 2>/dev/null || echo "Volume não existe ou já foi removido"

# Rebuild da imagem MySQL
echo "🔨 Reconstruindo imagem MySQL..."
$COMPOSE_CMD build --no-cache mysql

# Iniciar MySQL
echo "🚀 Iniciando MySQL..."
$COMPOSE_CMD up -d mysql

echo "✅ MySQL resetado! Aguarde alguns segundos para inicializar..."
echo ""
echo "💡 Para verificar se está funcionando:"
echo "   ./check-mysql.sh"

