

document.addEventListener("alpine:init", () => {
    Alpine.data("carList", () => ({
        page: 1,
        perPage: 5,
        cars: [],
        search: '',

        fetchCars() {
            fetch('/api/cars')
                .then(res => res.json())
                .then(data => {
                    this.cars = data;
                });
        },

        get filteredCars() {
            return this.cars.filter(car => {
                console.log(car); // Muestra cada objeto car en la consola
                return (
                    car.brand.toLowerCase().includes(this.search.toLowerCase()) ||
                    String(car.model).toLowerCase().includes(this.search.toLowerCase()) // Convertir a string
                );
            });
        },

        get paginatedCars() {
            const start = (this.page - 1) * this.perPage;
            return this.filteredCars.slice(start, start + this.perPage);
        },
        addCar() {
            Swal.fire({
                title: 'Agregar Carro',
                html: `
<input id="new-brand" class="swal2-input" placeholder="Marca">
<input id="new-model" class="swal2-input" placeholder="Modelo">
<input id="new-year" class="swal2-input" placeholder="Año" type="number">
<input id="new-color" class="swal2-input" placeholder="Color">
<input id="new-price" class="swal2-input" placeholder="Precio" type="number">
`,
                focusConfirm: false,
                showCancelButton: true,
                confirmButtonText: 'Agregar',
                preConfirm: () => {
                    let brand = document.getElementById('new-brand').value.trim();
                    let model = document.getElementById('new-model').value.trim();
                    let year = document.getElementById('new-year').value.trim();
                    let color = document.getElementById('new-color').value.trim();
                    let price = document.getElementById('new-price').value.trim();

                    if (!brand || !model || !year || !color || !price) {
                        Swal.showValidationMessage('Todos los campos son obligatorios');
                        return false;
                    }

                    if (isNaN(year) || year < 1886 || year > new Date().getFullYear()) {
                        Swal.showValidationMessage('El año debe ser un número válido');
                        return false;
                    }

                    if (isNaN(price) || price <= 0) {
                        Swal.showValidationMessage('El precio debe ser un número positivo');
                        return false;
                    }

                    return {
                        brand,
                        model,
                        year,
                        color,
                        price
                    };
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('/api/cars', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-CSRF-TOKEN': document.querySelector("meta[name='csrf-token']").content
                            },
                            body: JSON.stringify(result.value)
                        })
                        .then(res => res.json())
                        .then(() => {
                            Swal.fire('Agregado!', 'El carro ha sido agregado.', 'success');
                            this.fetchCars(); // Actualizar la lista de carros
                        });
                }
            });
        },
        editCar(car) {
            Swal.fire({
                title: 'Editar Carro',
                html: `
<input id="edit-brand" class="swal2-input" placeholder="Marca" value="${car.brand}">
<input id="edit-model" class="swal2-input" placeholder="Modelo" value="${car.model}">
<input id="edit-year" class="swal2-input" placeholder="Año" value="${car.year}">
<input id="edit-color" class="swal2-input" placeholder="Color" value="${car.color}">
<input id="edit-price" class="swal2-input" placeholder="Precio" value="${car.price}">
`,
                focusConfirm: false,
                showCancelButton: true,
                preConfirm: () => {
                    return {
                        brand: document.getElementById('edit-brand').value,
                        model: document.getElementById('edit-model').value,
                        year: document.getElementById('edit-year').value,
                        color: document.getElementById('edit-color').value,
                        price: document.getElementById('edit-price').value
                    };
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/api/cars/${car.id}`, {
                            method: 'PUT',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-CSRF-TOKEN': document.querySelector("meta[name='csrf-token']").content
                            },
                            body: JSON.stringify(result.value)
                        })
                        .then(res => res.json())
                        .then(() => {
                            Swal.fire('Actualizado!', 'El carro ha sido actualizado.', 'success');
                            this.fetchCars(); // Recargar la lista de carros
                        });
                }
            });
        },


        confirmDelete(id) {
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'No podrás revertir esta acción!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Sí, eliminar!'
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch(`/api/cars/${id}`, {
                        method: 'DELETE',
                        headers: {
                            'X-CSRF-TOKEN': document.querySelector("meta[name='csrf-token']").content
                        }
                    }).then(() => {
                        Swal.fire('Eliminado!', 'El carro ha sido eliminado.', 'success');
                        this.fetchCars();
                    });
                }
            });
        }
    }));
});
