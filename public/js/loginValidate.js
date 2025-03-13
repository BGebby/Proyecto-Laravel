document.querySelector("form").addEventListener("submit", function (event) {
    let email = document.getElementById("email").value.trim();
    let password = document.getElementById("password").value.trim();

    if (!email || !password) {
        event.preventDefault();
        Swal.fire({
            icon: 'warning',
            title: 'Campos requeridos',
            text: 'Por favor, completa todos los campos.',
        });
    }
});