document.querySelector("form").addEventListener("submit", function (event) {
    let name = document.getElementById("name").value.trim();
    let email = document.getElementById("email").value.trim();
    let password = document.getElementById("password").value.trim();
    let confirmPassword = document.getElementById("password_confirmation").value.trim();

    if (!name || !email || !password || !confirmPassword) {
        event.preventDefault();
        Swal.fire({
            icon: 'warning',
            title: 'Campos obligatorios',
            text: 'Todos los campos son requeridos',
        });
    } else if (password.length < 8) {
        event.preventDefault();
        Swal.fire({
            icon: 'error',
            title: 'Contraseña débil',
            text: 'La contraseña debe tener al menos 8 caracteres',
        });
    } else if (password !== confirmPassword) {
        event.preventDefault();
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Las contraseñas no coinciden',
        });
    }
});