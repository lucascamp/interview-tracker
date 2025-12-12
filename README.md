# Interview Tracker

Sistema de acompanhamento de entrevistas de emprego desenvolvido com Laravel 12, Inertia.js, Vue 3 e TailwindCSS.

## 🚀 Tecnologias

- **Laravel 12** - Framework PHP
- **Inertia.js** - Bridge entre Laravel e Vue
- **Vue 3** - Framework JavaScript
- **TailwindCSS** - Framework CSS
- **MySQL** - Banco de dados
- **Docker** - Containerização

## 📋 Requisitos

- Docker
- Docker Compose (opcional, mas não usado neste projeto)

## 🐳 Instalação com Docker

### ⚡ Setup Automatizado (Recomendado)

Execute o script que faz tudo automaticamente:

```bash
chmod +x setup.sh
./setup.sh
```

Depois, inicie o servidor Laravel:

```bash
./run-server.sh
```

Acesse: `http://localhost:8055`

**Nota:** O projeto agora usa Docker Compose para gerenciar os containers.

Acesse: `http://localhost:8055`

## 🎯 Funcionalidades

### Dashboard
- Listagem de todas as entrevistas em formato de tabela
- Filtros por plataforma, status e entrevistado
- Paginação
- Botão para adicionar nova entrevista
- Link para editar entrevista

### Formulário de Entrevista
- Campos para todos os dados da entrevista
- Extração automática de plataforma a partir da URL
- Validação frontend e backend
- Suporte para criar e editar

## 📊 Entidade Entrevista

### Campos:
- `entrevistado` (enum: Lucas, Thais)
- `data_cadastro_vaga` (string)
- `link_vaga` (string - URL)
- `plataforma` (string - extraída automaticamente)
- `data_resposta` (date)
- `resposta` (text)
- `status` (enum: aplicado, entrevista_rh, entrevista_tecnica, entrevista_cultural, oferta, concluido)
- `dados_desafio_tecnico` (text nullable)
- `responsavel_processo` (string)
- `salario_combinado` (string)

## 🔧 Plataformas Suportadas

O sistema extrai automaticamente a plataforma das seguintes URLs:
- LinkedIn (`linkedin.com`)
- Indeed (`indeed.com`, `indeed.com.br`)
- Gupy (`gupy.io`, `gupy.com.br`)
- Kenoby (`kenoby.com`, `kenoby.com.br`)

## 📝 Comandos Úteis

```bash
# Executar migrations
php artisan migrate

# Executar seeders
php artisan db:seed

# Limpar cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Build dos assets para produção
npm run build
```

## 📄 Licença

MIT

