<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

// Ruta para mostrar el formulario de login
Route::get('login', [AuthController::class, 'showLoginForm'])->name('login');

// Ruta para procesar el login
Route::post('login', [AuthController::class, 'login']);

// Ruta para mostrar el formulario de registro
Route::get('register', [AuthController::class, 'showRegistrationForm'])->name('register');

// Ruta para procesar el registro
Route::post('register', [AuthController::class, 'register']);

//ruta para deslogearse
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

//ruta principal despues de loggearse
Route::get('/', function () {
    return view('home');
})->name('home')->middleware('auth');


