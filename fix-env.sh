#!/bin/bash

# Script para criar .env e corrigir problemas

echo "🔧 Corrigindo configuração do Laravel..."

# Criar .env se não existir
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env..."
    cat > .env << 'EOF'
APP_NAME="Interview Tracker"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC
APP_URL=http://localhost:8055

APP_LOCALE=pt_BR
APP_FALLBACK_LOCALE=pt_BR
APP_FAKER_LOCALE=pt_BR

APP_MAINTENANCE_DRIVER=file
APP_MAINTENANCE_STORE=database

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=interview_tracker
DB_USERNAME=root
DB_PASSWORD=root

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=database
CACHE_PREFIX=

MEMCACHED_HOST=127.0.0.1

REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
EOF
    echo "✅ Arquivo .env criado"
else
    echo "✅ Arquivo .env já existe"
fi

# Copiar para o container
echo "📦 Copiando .env para o container..."
docker cp .env interview-tracker-php:/var/www/html/.env

# Gerar chave da aplicação
echo "🔑 Gerando chave da aplicação..."
docker exec interview-tracker-php php artisan key:generate --force

# Reinstalar dependências do Composer
echo "📦 Reinstalando dependências do Composer..."
docker exec interview-tracker-php composer install --no-interaction

# Atualizar autoload
echo "🔄 Atualizando autoload..."
docker exec interview-tracker-php composer dump-autoload

# Limpar caches
echo "🧹 Limpando caches..."
docker exec interview-tracker-php php artisan config:clear
docker exec interview-tracker-php php artisan route:clear
docker exec interview-tracker-php php artisan view:clear
docker exec interview-tracker-php php artisan cache:clear

echo "✅ Configuração corrigida!"
echo ""
echo "💡 Agora execute: ./run-server.sh"

