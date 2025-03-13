import api from "./axiosConfig.js";
console.log("cars.js cargado correctamente");

// Obtener todos los carros
export const getCars = async () => {
    console.log("Ejecutando getCars...");

    try {
        const response = await api.get("/api/cars");
        console.log({response});
        return response.data;
    } catch (error) {
        console.error("Error al obtener los carros:", error);
        return [];
    }
};

// Agregar un carro
export const addCar = async (car) => {
    console.log("Ejecutando addCars...");

    try {
        const response = await api.post("/api/cars", car);
        console.log({response2:response});

        return response.data;
    } catch (error) {
        console.error("Error al agregar el carro:", error);
        return null;
    }
};

// Editar un carro
export const updateCar = async (id, car) => {
    console.log("Ejecutando updateCars...");

    try {
        const response = await api.put(`/api/cars/${id}`, car);
        console.log({response3:response});

        return response.data;
    } catch (error) {
        console.error("Error al actualizar el carro:", error);
        return null;
    }
};

// Eliminar un carro
export const deleteCar = async (id) => {
    try {
        await api.delete(`/api/cars/${id}`);
        return true;
    } catch (error) {
        console.error("Error al eliminar el carro:", error);
        return false;
    }
};
