import './bootstrap';
import { getCars, addCar, updateCar, deleteCar } from './api/cars.js';


document.addEventListener("DOMContentLoaded", async () => {
    console.log("DOMContentLoaded ejecutado");

            const tablaCarros = document.getElementById("tablaCarros");

            // Cargar carros al inicio
            const cargarCarros = async () => {
                const data = await getCars();
                let filas = "";
                data.forEach(car => {
                    filas += `
                    <tr>
                        <td>${car.id}</td>
                        <td>${car.brand}</td>
                        <td>${car.model}</td>
                        <td>${car.year}</td>
                        <td>
                            <button class="btn btn-warning btnEditar" 
                                data-id="${car.id}" 
                                data-brand="${car.brand}" 
                                data-model="${car.model}" 
                                data-year="${car.year}" 
                                data-bs-toggle="modal" 
                                data-bs-target="#modalEditar">
                                Editar
                            </button>
                            <button class="btn btn-danger btnEliminar" data-id="${car.id}">Eliminar</button>
                        </td>
                    </tr>
                `;
                });
                tablaCarros.innerHTML = filas;
            };

            // Agregar carro
            document.getElementById("formAgregar").addEventListener("submit", async (e) => {
                e.preventDefault();
                const nuevoCarro = {
                    brand: document.getElementById("marca").value,
                    model: document.getElementById("modelo").value,
                    year: document.getElementById("anio").value,
                };
                await addCar(nuevoCarro);
                cargarCarros();
            });

            // Editar carro
            document.getElementById("formEditar").addEventListener("submit", async (e) => {
                e.preventDefault();
                const id = document.getElementById("editId").value;
                const carroEditado = {
                    brand: document.getElementById("editMarca").value,
                    model: document.getElementById("editModelo").value,
                    year: document.getElementById("editAnio").value,
                };
                await updateCar(id, carroEditado);
                cargarCarros();
            });

            // Eliminar carro
            tablaCarros.addEventListener("click", async (e) => {
                console.log("DOMContentLoaded ejecutado");

                if (e.target.classList.contains("btnEliminar")) {
                    const id = e.target.getAttribute("data-id");
                    if (confirm("¿Estás seguro de eliminar este carro?")) {
                        await deleteCar(id);
                        cargarCarros();
                    }
                }
            });

            cargarCarros();
        });