FROM alpine:edge

# Cambiar espejo de repositorio
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Limpiar cache y forzar actualización
RUN rm -rf /var/cache/apk/* && apk update --no-cache --allow-untrusted

# Verificar la version de apk.
RUN apk --version

# Actualizar cache
RUN apk update --no-cache
RUN apk upgrade --no-cache

# Instalar php fpm
RUN apk add --no-cache php82-fpm

# Verificaciones
RUN apk info php82-fpm
RUN apk list -v php82-fpm
RUN apk verify php82-fpm
RUN find / -name php82-fpm 2>/dev/null
RUN ls -l /usr/sbin/php82-fpm
RUN cat /etc/apk/repositories
RUN df -h

# Pausa
RUN sleep 30

CMD ["tail", "-f", "/dev/null"]
