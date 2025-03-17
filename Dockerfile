FROM php:8.2-fpm-alpine

RUN apk add --no-cache net-tools nginx supervisor

RUN docker-php-ext-install pdo pdo_mysql

COPY ./.docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /var/www

COPY . .

RUN chmod -R 775 storage bootstrap/cache

RUN chown -R www-data:www-data /var/www
RUN chown www-data:www-data /etc/nginx/conf.d/default.conf
RUN chown www-data:www-data /etc/nginx/nginx.conf # Corregido
RUN chmod 644 /etc/nginx/conf.d/default.conf
RUN chmod 644 /etc/nginx/nginx.conf # Corregido

RUN mkdir -p /var/lib/nginx/logs && chown -R www-data:www-data /var/lib/nginx/logs

USER www-data

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
