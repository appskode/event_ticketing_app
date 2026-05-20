<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\EventController;
use App\Http\Controllers\API\TicketController;
use App\Http\Controllers\API\PurchaseController;
use App\Http\Middleware\IsAdminMiddleware;
use App\Http\Middleware\JwtMiddleware;

// Public routes
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
});

// Public event routes
Route::group(['prefix' => 'events'], function () {
    Route::get('/search-suggestions', [EventController::class, 'searchSuggestions']);
    Route::get('/search', [EventController::class, 'search']);
    Route::get('/categories', [EventController::class, 'categories']);
    Route::get('/', [EventController::class, 'index']);
    Route::get('/{id}', [EventController::class, 'show']);
});

// Protected routes
Route::middleware([JwtMiddleware::class])->group(function () {
    Route::prefix('auth')->group(function () {
        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me', action: [AuthController::class, 'me']);
        Route::post('refresh', [AuthController::class, 'refresh']);
    });

    Route::get('my-tickets', [TicketController::class, 'myTickets']);
    Route::get('tickets/{id}', [TicketController::class, 'show']);
    Route::post('tickets/{id}/cancel', [TicketController::class, 'cancel']);

    Route::post('purchase', [PurchaseController::class, 'purchase']);
    Route::get('purchases', [PurchaseController::class, 'index']);
    Route::get('purchases/{id}', [PurchaseController::class, 'show']);
});

// Admin event management routes
Route::middleware([JwtMiddleware::class, IsAdminMiddleware::class])->group(function () {
    Route::post('events', [EventController::class, 'store']);
    Route::post('events/{id}/ticket-types', [EventController::class, 'addTicketType']);
});
