<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <h2 class="text-2xl font-semibold text-center mb-6">Registro de Usuario</h2>

        <form method="POST" action="{{ route('register') }}" class="space-y-4">
            @csrf

            <div>
                <label for="name" class="block text-gray-700">Nombre</label>
                <input type="text" id="name" name="name" value="{{ old('name') }}" required
                    class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                @error('name') <span class="text-red-500 text-sm">{{ $message }}</span> @enderror
            </div>

            <div>
                <label for="email" class="block text-gray-700">Correo Electrónico</label>
                <input type="email" id="email" name="email" value="{{ old('email') }}" required
                    class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                @error('email') <span class="text-red-500 text-sm">{{ $message }}</span> @enderror
            </div>

            <div>
                <label for="password" class="block text-gray-700">Contraseña</label>
                <input type="password" id="password" name="password" required
                    class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
                @error('password') <span class="text-red-500 text-sm">{{ $message }}</span> @enderror
            </div>

            <div>
                <label for="password_confirmation" class="block text-gray-700">Confirmar Contraseña</label>
                <input type="password" id="password_confirmation" name="password_confirmation" required
                    class="w-full p-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <div>
                <button type="submit" class="w-full bg-blue-500 text-white p-2 rounded hover:bg-blue-600 transition">Registrar</button>
            </div>
        </form>

        <p class="text-center mt-4">¿Ya tienes una cuenta?
            <a href="{{ route('login') }}" class="text-blue-500 hover:underline">Iniciar sesión</a>
        </p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="{{ asset('js/registerValidate.js') }}"></script>



</body>

</html>