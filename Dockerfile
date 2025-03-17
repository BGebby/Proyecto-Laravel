FROM php:8.2-fpm

RUN apt-get update && apt-get install -y net-tools \
    && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev

RUN apt-get update && apt-get install -y nginx

RUN apt-get update && apt-get install -y supervisor

RUN apt-get update && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN chmod -R 775 storage bootstrap/cache

COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chown -R www-data:www-data /var/www
RUN chown www-data:www-data /etc/nginx/conf.d/default.conf
RUN chmod 644 /etc/nginx/conf.d/default.conf

RUN ls -l /usr/sbin/nginx
RUN which php-fpm
RUN ls -l /usr/local/sbin/php-fpm

RUN chmod +x /usr/sbin/nginx

RUN ls -l /etc/php/8.2/fpm/pool.d/

RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf

RUN ss -tuln | grep 9000
RUN curl 127.0.0.1:9000
RUN cat /var/log/php8.2-fpm.log

USER www-data

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
