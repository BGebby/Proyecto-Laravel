# Usamos la imagen oficial de PHP con soporte para Laravel
FROM php:8.2-fpm

# Instalamos extensiones necesarias
RUN apt-get update && apt-get install -y \
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

# Damos permisos a la carpeta de almacenamiento y bootstrap
RUN chmod -R 777 storage bootstrap/cache

# Instalamos dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Exponemos el puerto de Laravel
EXPOSE 9000

# Definimos el comando de arranque
CMD ["php-fpm"]
