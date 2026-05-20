<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Services\AuthService;
use App\Services\EventService;
use App\Services\PurchaseService;
use App\Services\TicketService;

class ServiceServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->bind(AuthService::class, function ($app) {
            return new AuthService();
        });

        $this->app->bind(EventService::class, function ($app) {
            return new EventService();
        });

        $this->app->bind(PurchaseService::class, function ($app) {
            return new PurchaseService();
        });

        $this->app->bind(TicketService::class, function ($app) {
            return new TicketService();
        });
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
