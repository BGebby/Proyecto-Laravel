#!/bin/sh

echo "Esperando a MySQL..."

# Espera a que MySQL esté listo antes de continuar
while ! nc -z $DB_HOST_ENTRY $DB_PORT; do
  sleep 2
done

echo "MySQL está listo. Ejecutando migraciones..."

# Ejecutar migraciones
php artisan migrate --force

# Iniciar PHP-FPM
php-fpm