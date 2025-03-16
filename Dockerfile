FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN chmod -R 775 storage bootstrap/cache

COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN mkdir /etc/supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chown -R www-data:www-data /var/www
RUN chown www-data:www-data /etc/nginx/conf.d/default.conf
RUN chmod 644 /etc/nginx/conf.d/default.conf

USER www-data

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
