<?php

use App\Http\Controllers\EntrevistaController;
use App\Http\Controllers\EntrevistadoController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', [EntrevistaController::class, 'index'])->name('dashboard');
Route::resource('entrevistas', EntrevistaController::class);
Route::resource('entrevistados', EntrevistadoController::class);

