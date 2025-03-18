FROM alpine:edge

# Cambiar espejo de repositorio
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Actualizar apk y repositorios, limpiar cache
RUN apk update --no-cache --allow-untrusted && apk upgrade --no-cache && rm -rf /var/cache/apk/*

# Verificar la versión de Alpine Linux
RUN cat /etc/os-release

# Verificar la version de apk.
RUN apk --version

# Reparar instalación de paquetes
RUN apk fix

# Actualizar cache
RUN apk update --no-cache

# Verificar GIDs usados.
RUN cat /etc/group

# Crear usuario y grupo nginx
RUN addgroup -g 102 nginx && adduser -u 102 -G nginx -s /bin/sh -D nginx

# Instalar PHP y verificar la versión
RUN apk add --no-cache php82
RUN php82 -v

# Instalar extensiones necesarias, incluyendo las requeridas por Composer, Laravel y SQLite, zip, xml, xmlwriter
RUN apk add --no-cache php82-fpm php82-pdo_mysql php82-mysqli php82-curl php82-phar php82-iconv php82-mbstring php82-session php82-fileinfo php82-tokenizer php82-dom php82-pdo_sqlite shadow supervisor curl php82-zip php82-xml php82-xmlwriter

# Instalar procps e iproute2
RUN apk add --no-cache procps iproute2

# Crear el usuario www-data (el grupo ya existe)
RUN useradd -u 1000 -g www-data www-data

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php82 -- --install-dir=/usr/local/bin --filename=composer

# Copiar archivos de configuración de Nginx
COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Copiar archivos de configuración de PHP-FPM
# (Asumiendo que tienes archivos de configuración de PHP-FPM en ./docker/php-fpm/)
#COPY ./docker/php-fpm/php-fpm.conf /etc/php82/php-fpm.conf
#COPY ./docker/php-fpm/www.conf /etc/php82/php-fpm.d/www.conf

# Copiar configuración de supervisor
COPY ./supervisord.conf /etc/supervisor/supervisord.conf

# Copiar la aplicación
COPY . /var/www/

# Establecer el directorio de trabajo
WORKDIR /var/www/

# Diagnóstico de Red
RUN curl -sSL google.com && curl -sSL https://getcomposer.org/versions

# Diagnóstico de PHP y Composer
RUN php82 -m && php82 /usr/local/bin/composer diagnose

# Limpiar la caché de Composer
RUN rm -rf /root/.composer/cache

# Instalar dependencias de Composer (usando php82)
RUN php82 /usr/local/bin/composer install --no-cache --no-dev --optimize-autoloader -vvv

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
RUN apk info php82-fpm
RUN apk list -v php82-fpm
RUN which php82-fpm
RUN ls -l $(which php82-fpm)
RUN php82-fpm -v
RUN export PATH=$PATH:/usr/sbin && php82-fpm -t

# Exponer el puerto 9000
EXPOSE 9000

# Comando para iniciar Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
