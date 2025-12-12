<?php

use App\Http\Controllers\EntrevistaController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', [EntrevistaController::class, 'index'])->name('dashboard');
Route::resource('entrevistas', EntrevistaController::class);

