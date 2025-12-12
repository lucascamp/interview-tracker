#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Iniciando setup do Interview Tracker...${NC}\n"

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar se Docker está instalado
if ! command_exists docker; then
    echo -e "${RED}❌ Docker não está instalado. Por favor, instale o Docker primeiro.${NC}"
    exit 1
fi

# Verificar se Docker Compose está instalado
if ! command_exists docker-compose && ! docker compose version >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro.${NC}"
    exit 1
fi

# Verificar qual comando usar (docker-compose ou docker compose)
if command_exists docker-compose; then
    COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo -e "${RED}❌ Docker Compose não encontrado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker encontrado${NC}"
echo -e "${GREEN}✅ Docker Compose encontrado (usando: ${COMPOSE_CMD})${NC}\n"

# 1. Parar containers existentes
echo -e "${YELLOW}🛑 Passo 1/6: Limpando containers antigos...${NC}"
$COMPOSE_CMD down 2>/dev/null || true
echo -e "${GREEN}✅ Containers antigos removidos${NC}\n"

# 2. Build das imagens
echo -e "${YELLOW}📦 Passo 2/6: Construindo imagens Docker...${NC}"
$COMPOSE_CMD build --no-cache

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao construir imagens Docker${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Imagens construídas com sucesso${NC}\n"

# 3. Iniciar serviços (MySQL primeiro)
echo -e "${YELLOW}🗄️  Passo 3/6: Iniciando MySQL...${NC}"
$COMPOSE_CMD up -d mysql

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao iniciar MySQL${NC}"
    exit 1
fi

# Aguardar MySQL estar pronto
echo -e "${YELLOW}⏳ Aguardando MySQL estar pronto (isso pode levar até 60 segundos)...${NC}"
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
    # Verificar se o container está rodando
    if ! docker ps | grep -q interview-tracker-mysql; then
        echo -e "\n${RED}❌ Container MySQL não está rodando${NC}"
        echo -e "${YELLOW}📋 Verificando logs do MySQL...${NC}"
        docker logs interview-tracker-mysql 2>&1 | tail -20
        exit 1
    fi
    
    # Tentar conectar ao MySQL
    if docker exec interview-tracker-mysql mysqladmin ping -h localhost -uroot -proot --silent 2>/dev/null; then
        echo ""
        echo -e "${GREEN}✅ MySQL está pronto${NC}\n"
        break
    fi
    
    attempt=$((attempt + 1))
    if [ $((attempt % 5)) -eq 0 ]; then
        echo -n " [${attempt}s]"
    else
        echo -n "."
    fi
    sleep 1
done
echo ""

if [ $attempt -eq $max_attempts ]; then
    echo -e "\n${RED}❌ MySQL não respondeu a tempo${NC}"
    echo -e "${YELLOW}📋 Últimos logs do MySQL:${NC}"
    docker logs interview-tracker-mysql 2>&1 | tail -30
    echo -e "\n${YELLOW}💡 Tente verificar os logs manualmente:${NC}"
    echo -e "   ${GREEN}docker logs interview-tracker-mysql${NC}"
    exit 1
fi

# 4. Iniciar PHP e Node
echo -e "${YELLOW}🐘 Passo 4/6: Iniciando PHP e Node.js...${NC}"
$COMPOSE_CMD up -d php node

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao iniciar serviços${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Serviços iniciados${NC}\n"

# 5. Configurar Laravel
echo -e "${YELLOW}⚙️  Passo 5/6: Configurando Laravel...${NC}"

# Criar .env se não existir
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Criando arquivo .env...${NC}"
    cat > .env << 'ENVEOF'
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
ENVEOF
    echo -e "${GREEN}✅ Arquivo .env criado${NC}"
fi

# Copiar .env para o container se necessário
echo -e "${YELLOW}📦 Copiando .env para o container...${NC}"
docker cp .env interview-tracker-php:/var/www/html/.env 2>/dev/null || \
docker exec interview-tracker-php bash -c "cat > /var/www/html/.env" < .env

# Instalar dependências do Composer
echo -e "${YELLOW}📦 Instalando dependências do Composer...${NC}"
docker exec interview-tracker-php composer install --no-interaction

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao instalar dependências do Composer${NC}"
    exit 1
fi

# Gerar chave da aplicação
echo -e "${YELLOW}🔑 Gerando chave da aplicação...${NC}"
docker exec interview-tracker-php php artisan key:generate --force

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  Tentando criar .env diretamente no container...${NC}"
    docker exec interview-tracker-php bash -c 'cat > /var/www/html/.env << "EOF"
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
EOF'
    docker exec interview-tracker-php php artisan key:generate --force
fi

# Configurar permissões
echo -e "${YELLOW}🔐 Configurando permissões...${NC}"
docker exec interview-tracker-php chmod -R 755 storage bootstrap/cache
docker exec interview-tracker-php chown -R www-data:www-data storage bootstrap/cache

# Criar migrations de sessões e cache se não existirem
echo -e "${YELLOW}📋 Criando migrations de sessões e cache...${NC}"
docker exec interview-tracker-php php artisan session:table 2>/dev/null || echo "Migration de sessões já existe"
docker exec interview-tracker-php php artisan cache:table 2>/dev/null || echo "Migration de cache já existe"

# Executar migrations
echo -e "${YELLOW}🗄️  Executando migrations...${NC}"
docker exec interview-tracker-php php artisan migrate --force

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao executar migrations${NC}"
    exit 1
fi

# Executar seeders
echo -e "${YELLOW}🌱 Populando banco de dados com dados de exemplo...${NC}"
docker exec interview-tracker-php php artisan db:seed --force

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro ao executar seeders${NC}"
    exit 1
fi

# Atualizar autoload do Composer
echo -e "${YELLOW}🔄 Atualizando autoload do Composer...${NC}"
docker exec interview-tracker-php composer dump-autoload

# Limpar caches do Laravel
echo -e "${YELLOW}🧹 Limpando caches do Laravel...${NC}"
docker exec interview-tracker-php php artisan config:clear
docker exec interview-tracker-php php artisan route:clear
docker exec interview-tracker-php php artisan view:clear
docker exec interview-tracker-php php artisan cache:clear

# 6. Aguardar Node/Vite iniciar
echo -e "${YELLOW}⏳ Passo 6/6: Aguardando Vite iniciar...${NC}"
sleep 10

# Verificar status dos containers
echo -e "\n${YELLOW}🔍 Verificando status dos containers...${NC}"
$COMPOSE_CMD ps

echo -e "\n${GREEN}✅ Setup concluído com sucesso!${NC}\n"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 Projeto pronto para uso!${NC}\n"
echo -e "${YELLOW}📍 Serviços disponíveis:${NC}"
echo -e "   • MySQL: ${GREEN}localhost:33063${NC}"
echo -e "   • Vite Dev Server (Inertia): ${GREEN}http://localhost:5173${NC} ${GREEN}✅ Rodando${NC}"
echo -e "   • Laravel: ${GREEN}http://localhost:8055${NC} (execute ./run-server.sh)\n"
echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo -e "   1. Execute: ${GREEN}./run-server.sh${NC} para iniciar o servidor Laravel"
echo -e "   2. Acesse: ${GREEN}http://localhost:8055${NC}\n"
echo -e "${YELLOW}📝 Comandos úteis:${NC}"
echo -e "   • Ver logs: ${GREEN}docker-compose logs -f${NC}"
echo -e "   • Parar containers: ${GREEN}./stop.sh${NC} ou ${GREEN}docker-compose down${NC}"
echo -e "   • Reiniciar containers: ${GREEN}./restart.sh${NC} ou ${GREEN}docker-compose restart${NC}"
echo -e "   • Ver status: ${GREEN}docker-compose ps${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
