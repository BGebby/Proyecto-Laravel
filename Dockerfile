FROM nginx:alpine

# Limpiar la caché de apk
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Instalar PHP y verificar la versión
RUN apk add --no-cache php82
RUN php82 -v

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
# Actualizar el PATH
RUN export PATH=$PATH:/usr/bin && which php82

# Crear el usuario www-data (el grupo ya existe)
RUN useradd -u 1000 -g www-data www-data

# Copiar archivos de configuración de Nginx
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf


# Copiar configuración de supervisor
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

# Copiar la aplicación
COPY . /var/www/

# Establecer el directorio de trabajo
WORKDIR /var/www/

# Instalar dependencias de Composer (usando php82)
RUN php82 /usr/local/bin/composer install --no-dev --optimize-autoloader

# Permisos
RUN chmod -R 775 storage bootstrap/cache
RUN chown -R www-data:www-data /var/www

# Permisos nginx
RUN mkdir -p /var/lib/nginx/logs && chown -R nginx:nginx /var/lib/nginx/logs && chmod -R 755 /var/lib/nginx/logs
RUN mkdir -p /var/lib/nginx/tmp/client_body && chown -R nginx:nginx /var/lib/nginx/tmp/client_body && chmod -R 755 /var/lib/nginx/tmp/client_body
RUN chown -R nginx:nginx /var/lib/nginx/

# Instalamos dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Exponer el puerto 9000
EXPOSE 9000

# Comando para iniciar Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
