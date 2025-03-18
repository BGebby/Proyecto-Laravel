# Usar una imagen base con PHP y Composer
FROM php:8.2-fpm-alpine AS builder

# Instalar dependencias de Composer
RUN apk add --no-cache git unzip curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar archivos del proyecto
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Copiar el código fuente
COPY . .

# Imagen final con Nginx
FROM nginx:alpine

# Instalar PHP y extensiones
RUN apk add --no-cache php82-fpm php82-pdo_mysql php82-mysqli supervisor

# Copiar código desde la imagen de construcción
COPY --from=builder /app /var/www

# Configuración de permisos
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache && \
    chown -R www-data:www-data /var/www

# Copiar configuraciones de Nginx y Supervisor
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /var/www

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
