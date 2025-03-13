<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body class="flex items-center justify-center min-h-screen bg-gray-100">

    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
        <h2 class="text-2xl font-bold text-center text-gray-800">Iniciar sesión</h2>

        <form method="POST" action="{{ route('login') }}" class="space-y-4">
            @csrf

            <div>
                <label for="email" class="block text-sm font-medium text-gray-700">Correo electrónico</label>
                <input type="email" id="email" name="email" required class="w-full p-2 mt-1 border rounded-md focus:ring focus:ring-blue-300">
            </div>

            <div>
                <label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
                <input type="password" id="password" name="password" required class="w-full p-2 mt-1 border rounded-md focus:ring focus:ring-blue-300">
            </div>

            <button type="submit" class="w-full px-4 py-2 text-white bg-blue-500 rounded-md hover:bg-blue-600">Iniciar sesión</button>
        </form>

        <p class="text-center text-sm text-gray-600">¿Aún no tienes una cuenta? <a href="{{ route('register') }}" class="text-blue-500 hover:underline">Regístrate aquí</a></p>
    </div>

    <!-- SweetAlert para errores de validación -->
    @if ($errors->any())
    <script>
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            html: `{!! implode('<br>', $errors->all()) !!}`,
        });
    </script>
    @endif

  
    @if(session('success'))
    <script>
        Swal.fire({
            icon: 'success',
            title: '¡Bienvenido!',
            text: '{{ session("success") }}',
        });
    </script>
    @endif


    <script src="{{ asset('js/loginValidate.js') }}"></script>


</body>

</html>