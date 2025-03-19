# Usamos la imagen oficial de PHP con soporte para Laravel
FROM php:8.2-fpm

# Instalamos extensiones necesarias
RUN apt-get update && apt-get install -y \
    nginx \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instalamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuramos el directorio de trabajo
WORKDIR /var/www

# Copiamos los archivos de la aplicación
COPY . .

# Copiamos configuración de Nginx
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Damos permisos a la carpeta de almacenamiento y bootstrap
RUN chmod -R 777 storage bootstrap/cache

# Instalamos dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Expone el puerto 80 para Nginx
EXPOSE 80

# Inicia Nginx y PHP-FPM al mismo tiempo
CMD ["sh", "-c", "service nginx start && php-fpm -F"]
