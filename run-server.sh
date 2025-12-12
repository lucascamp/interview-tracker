#!/bin/bash

# Script para iniciar o servidor Laravel dentro do container

echo "🚀 Iniciando servidor Laravel..."
echo "📍 Acesse: http://localhost:8055"
echo ""
echo "Pressione Ctrl+C para parar o servidor"
echo ""

docker exec -it interview-tracker-php php artisan serve --host=0.0.0.0 --port=8055

