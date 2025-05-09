# Etapa 1: Imagem base
FROM php:8.2-fpm

# Etapa 2: Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Etapa 3: Instalar o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Etapa 4: Criar diretório da aplicação
WORKDIR /var/www

# Etapa 5: Copiar arquivos do projeto
COPY . .

# Etapa 6: Instalar dependências PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Etapa 7: Permissões
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www/storage

# Etapa 8: Expor porta
EXPOSE 9000

CMD ["php-fpm"]