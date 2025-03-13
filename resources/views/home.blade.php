<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Lista de Carros</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</head>

<body class="bg-gray-100 p-6">
    <div class="max-w-7xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <h2 class="text-2xl font-semibold mb-4">Lista de Carros</h2>


        <div x-data="carList" x-init="fetchCars()">
            <div class="flex flex-wrap items-center justify-between gap-2 mb-4">
                <input type="text" placeholder="Buscar por marca o modelo" class="border p-2 rounded w-full sm:w-1/3" x-model="search">
                <div class="flex items-center gap-4">
                    <button class="bg-blue-500 text-white px-4 py-2 rounded" @click="addCar()">Agregar Carro</button>

                    <form action="{{ route('logout') }}" method="POST">
                        @csrf
                        <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded">Cerrar sesión</button>
                    </form>
                </div>
            </div>
            <table class="w-full table-auto border-collapse border border-gray-300">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 hidden">ID</th>
                        <th class="border p-2">Marca</th>
                        <th class="border p-2">Modelo</th>
                        <th class="border p-2">Año</th>
                        <th class="border p-2">Color</th>
                        <th class="border p-2">Precio</th>
                        <th class="border p-2">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <template x-for="(car, index) in paginatedCars" :key="car.id">
                        <tr class="border">
                            <td class="border p-2 text-center hidden" x-text="car.id"></td>
                            <td class="border p-2 text-center" x-text="car.brand"></td>
                            <td class="border p-2 text-center" x-text="car.model"></td>
                            <td class="border p-2 text-center" x-text="car.year"></td>
                            <td class="border p-2 text-center" x-text="car.color"></td>
                            <td class="border p-2 text-center" x-text="car.price"></td>
                            <td class="border p-2 text-center">
                                <button class="bg-yellow-500 text-white px-2 py-1 rounded" @click="editCar(car)">Editar</button>
                                <button class="bg-red-500 text-white px-2 py-1 rounded" @click="confirmDelete(car.id)">Eliminar</button>
                            </td>
                        </tr>
                    </template>
                </tbody>
            </table>

            <div class="flex justify-between items-center mt-4">
                <button @click="page = Math.max(page - 1, 1)" class="px-4 py-2 bg-gray-300 rounded">Anterior</button>
                <span x-text="'Página ' + page + ' de ' + Math.ceil(filteredCars.length / perPage)"></span>
                <button @click="page = Math.min(page + 1, Math.ceil(filteredCars.length / perPage))" class="px-4 py-2 bg-gray-300 rounded">Siguiente</button>
            </div>
        </div>
        <script src="{{ asset('js/botones.js') }}"></script>
</body>

</html>