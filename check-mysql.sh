#!/bin/bash

# Script para verificar status do MySQL

echo "🔍 Verificando status do MySQL..."

# Verificar se container está rodando
if ! docker ps | grep -q interview-tracker-mysql; then
    echo "❌ Container MySQL não está rodando"
    echo ""
    echo "📋 Containers MySQL:"
    docker ps -a | grep mysql
    exit 1
fi

echo "✅ Container MySQL está rodando"
echo ""

# Verificar logs
echo "📋 Últimos logs do MySQL:"
docker logs interview-tracker-mysql 2>&1 | tail -20
echo ""

# Tentar conectar
echo "🔌 Tentando conectar ao MySQL..."
if docker exec interview-tracker-mysql mysqladmin ping -h localhost -uroot -proot --silent 2>/dev/null; then
    echo "✅ MySQL está respondendo!"
else
    echo "❌ MySQL não está respondendo"
    echo ""
    echo "💡 Verifique os logs completos:"
    echo "   docker logs interview-tracker-mysql"
fi

