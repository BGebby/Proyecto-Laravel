FROM php:8.2-fpm

# Actualizamos la lista de paquetes y instalamos dependencias
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

# Copiamos la configuración de Nginx
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Damos permisos a la carpeta de almacenamiento y bootstrap
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache
RUN chown -R www-data:www-data /var/www/public
RUN chmod -R 755 /var/www/public

# Instalamos dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader
RUN apt-get update && apt-get install -y iproute2
RUN ls -l /var/www/resources/views

# Expone el puerto 80
EXPOSE 80

# Inicia PHP-FPM y Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
