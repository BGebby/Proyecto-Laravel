# Imagen base de PHP con FPM
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
    nginx \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Instalamos Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Instalamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configuramos el directorio de trabajo
WORKDIR /var/www

# Copiamos los archivos de la aplicación
COPY . .

# Instalamos dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Instalamos dependencias de npm y construimos los assets
RUN npm install && npm run build

# Damos permisos a la carpeta de almacenamiento y bootstrap
RUN chmod -R 777 storage bootstrap/cache

# Configuración de Nginx
COPY .docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# Copiamos la configuración de supervisor
COPY .docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exponemos el puerto 80
EXPOSE 9000

# Comando para ejecutar Supervisor (manejar Nginx y PHP-FPM)
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
