#
Aplicación en Laravel que permite gestionar una entidad Carro con funcionalidades de Crear, Leer, Actualizar y Eliminar (CRUD).

####
Documentación para Configurar el Proyecto Laravel con Docker

Requisitos Previos

Antes de comenzar, asegúrese de tener instalado lo siguiente en su sistema:

-Docker

-Docker Compose

###
Instalación del Proyecto

Clonar el Repositorio

-git clone https://github.com/...

Copiar el Archivo de Entorno
Copie el archivo de ejemplo:

.env.example .env

Generar la Clave de Aplicación

docker-compose run --rm app php artisan key:generate

Levantar los Contenedores con Docker

docker-compose up -d

Configuración de la Base de Datos

Verificar si las Migraciones Existen

Antes de ejecutar las migraciones, verificamos si la tabla de migraciones ya está creada:
nombre del contenedor (laravel_app)
docker exec -it nombre_del_contenedor php artisan migrate:status 



Si obtenemos el siguiente error:

ERROR  Migration table not found.

Significa que las migraciones no se han ejecutado. Para instalarlas, ejecutamos:
nombre del contenedor (laravel_app)
docker exec -it nombre_del_contenedor php artisan migrate



## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
