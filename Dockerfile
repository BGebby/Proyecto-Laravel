FROM nginx:alpine

# Limpiar la caché de apk
RUN apk update && apk upgrade && rm -rf /var/cache/apk/*

# Instalar PHP y verificar la versión
RUN apk add --no-cache php82
RUN php82 -v

# Instalar extensiones necesarias, incluyendo las requeridas por Composer, Laravel y SQLite
RUN apk add --no-cache php82-fpm php82-pdo_mysql php82-mysqli php82-curl php82-phar php82-iconv php82-mbstring php82-session php82-fileinfo php82-tokenizer php82-dom php82-pdo_sqlite shadow supervisor curl

# Instalar procps e iproute2
RUN apk add --no-cache procps iproute2

# Crear el usuario www-data (el grupo ya existe)
RUN useradd -u 1000 -g www-data www-data

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php82 -- --install-dir=/usr/local/bin --filename=composer

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
RUN php82 /usr/local/bin/composer install --no-dev --optimize-autoloader -vvv --memory-limit=-1

# Permisos (Ajuste de permisos y verificación)
RUN chmod -R 775 storage bootstrap/cache
RUN chown -R www-data:www-data /var/www
RUN ls -l /var/www/storage && ls -l /var/www/bootstrap/cache
RUN ls -ld /var/www /var/www/storage /var/www/bootstrap/cache
RUN ps aux | grep php-fpm

# Permisos nginx
RUN mkdir -p /var/lib/nginx/logs && chown -R nginx:nginx /var/lib/nginx/logs && chmod -R 755 /var/lib/nginx/logs
RUN mkdir -p /var/lib/nginx/tmp/client_body && chown -R nginx:nginx /var/lib/nginx/tmp/client_body && chmod -R 755 /var/lib/nginx/tmp/client_body
RUN chown -R nginx:nginx /var/lib/nginx/

# Verificar si php-fpm esta escuchando en el puerto 9000.
RUN ss -tuln | grep 9000 || true
RUN ls -l /usr/sbin/php82-fpm #Verificamos si existe el ejecutable.
RUN export PATH=$PATH:/usr/sbin && php82-fpm -t

# Exponer el puerto 9000
EXPOSE 9000

# Comando para iniciar Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
