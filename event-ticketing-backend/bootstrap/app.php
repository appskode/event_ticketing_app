<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use App\Exceptions\Handler;
use App\Exceptions\ApiExceptionHandler;
use App\Http\Middleware\JwtMiddleware;
use App\Http\Middleware\ForceJsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;




return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->trustProxies(at: '*');

        $middleware->append([
            \Illuminate\Http\Middleware\HandleCors::class,
        ]);

        $middleware->alias([
            'force.json' => ForceJsonResponse::class,
        ]);

        $middleware->api(prepend: [
            'force.json',
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (Throwable $e, Request $request) {
            // Only handle API routes with our custom handler
            if ($request->is('api/*')) {
                // Get the exception class name
                $className = get_class($e);

                // Get our custom handlers
                $handlers = ApiExceptionHandler::$handlers;

                // Check if we have a specific handler for this exception
                if (array_key_exists($className, $handlers)) {
                    $method = $handlers[$className];
                    $apiHandler = new ApiExceptionHandler();
                    return $apiHandler->$method($e, $request);
                }

                // Fallback to default error response for API routes
                $statusCode = $e instanceof HttpExceptionInterface ? $e->getStatusCode() : 500;
                if ($statusCode < 400) $statusCode = 500; // Ensure valid HTTP error code

                return response()->json([
                    'success' => false,
                    'error' => [
                        'type' => basename(str_replace('\\', '/', get_class($e))),
                        'status' => $statusCode,
                        'message' => $e->getMessage() ?: 'An unexpected error occurred',
                        'code' => 'UNKNOWN_ERROR',
                        'timestamp' => now()->toISOString(),
                        // Include debug info only in non-production environments
                        'debug' => app()->environment('local', 'testing') ? [
                            'file' => $e->getFile(),
                            'line' => $e->getLine(),
                            'trace' => collect($e->getTrace())->take(5)->toArray() // Limit trace for readability
                        ] : null
                    ]
                ], $statusCode);
            }

            // For non-API routes, let Laravel handle it normally
            return null;
        });
    })->create();
