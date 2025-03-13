<?php

namespace App\Http\Controllers;

use App\Models\Car;
use Illuminate\Http\Request;
use App\Http\Resources\CarResource;

class CarController extends Controller
{

    public function index()
    {
        return response()->json(Car::all());
    }

   
    public function store(Request $request)
    {
        $data = $request->validate([
            'brand' => 'required|string|max:255',
            'model' => 'required|string|max:255',
            'year' => 'required|integer',
            'color' => 'required|string|max:255',
            'price' => 'required|numeric',
        ]);

        $car = Car::create($data);
        return response()->json($car, 201);
        // return new CarResource($car);
    }

   
   public function show($id)
    {
        return Car::findOrFail($id); // Devuelve el carro con el ID especificado
    }

   
    public function update(Request $request, Car $car)
    {
        $data = $request->validate([
            'brand' => 'sometimes|string|max:255',
            'model' => 'sometimes|string|max:255',
            'year' => 'sometimes|integer',
            'color' => 'sometimes|string|max:255',
            'price' => 'sometimes|numeric|min:0',
        ]);
        $car->update($data);
        return response()->json($car, 201);
    }

  
    public function destroy(Car $car)
    {
        $car->delete();
        return response()->json(['message' => 'Registro eliminado correctamente'], 204);
    }
}
