<?php
namespace App\Exceptions;

use Illuminate\Auth\AuthenticationException;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Symfony\Component\HttpKernel\Exception\UnauthorizedHttpException;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenBlacklistedException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;

use Throwable;

class ApiExceptionHandler
{
    /**
     * Map of exception classes to their handler methods
     */
    public static array $handlers = [
        // JWT Exceptions
        TokenExpiredException::class => 'handleTokenExpiredException',
        TokenInvalidException::class => 'handleTokenInvalidException',
        TokenBlacklistedException::class => 'handleTokenBlacklistedException',
        JWTException::class => 'handleJWTException',
        UnauthorizedHttpException::class => 'handleUnauthorizedHttpException',

        // Laravel Auth Exceptions
        AuthenticationException::class => 'handleAuthenticationException',
        AccessDeniedHttpException::class => 'handleAuthenticationException',
        AuthorizationException::class => 'handleAuthorizationException',

        // Custom Application Exceptions
        \App\Exceptions\InsufficientStockException::class => 'handleInsufficientStockException',
        \App\Exceptions\EventExpiredException::class => 'handleEventExpiredException',
        \App\Exceptions\TicketCancellationException::class => 'handleTicketCancellationException',
        \App\Exceptions\PaymentProcessingException::class => 'handlePaymentProcessingException',

        // Validation & Data Exceptions
        ValidationException::class => 'handleValidationException',
        ModelNotFoundException::class => 'handleNotFoundException',
        NotFoundHttpException::class => 'handleNotFoundException',
        MethodNotAllowedHttpException::class => 'handleMethodNotAllowedException',

        // Database Exceptions
        QueryException::class => 'handleQueryException',

        // General HTTP Exceptions
        HttpException::class => 'handleHttpException',
    ];

    /**
     * Handle JWT token expired exceptions
     */
    public function handleTokenExpiredException(
        TokenExpiredException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'JWT token expired');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'TokenExpired',
                'status' => 401,
                'message' => 'Your session has expired. Please login again.',
                'code' => 'TOKEN_EXPIRED',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle JWT token invalid exceptions
     */
    public function handleTokenInvalidException(
        TokenInvalidException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'JWT token invalid');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'TokenInvalid',
                'status' => 401,
                'message' => 'Invalid authentication token. Please login again.',
                'code' => 'TOKEN_INVALID',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle JWT token blacklisted exceptions
     */
    public function handleTokenBlacklistedException(
        TokenBlacklistedException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'JWT token blacklisted');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'TokenBlacklisted',
                'status' => 401,
                'message' => 'This token has been invalidated. Please login again.',
                'code' => 'TOKEN_BLACKLISTED',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle general JWT exceptions
     */
    public function handleJWTException(
        JWTException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'JWT exception occurred');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'JWTError',
                'status' => 401,
                'message' => 'Authentication token not provided or malformed.',
                'code' => 'TOKEN_NOT_PROVIDED',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle unauthorized HTTP exceptions (often wraps JWT exceptions)
     */
    public function handleUnauthorizedHttpException(
        UnauthorizedHttpException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Unauthorized access attempt');

        // Check if this was caused by a JWT exception
        $previous = $e->getPrevious();
        if ($previous instanceof TokenExpiredException) {
            return $this->handleTokenExpiredException($previous, $request);
        }
        if ($previous instanceof TokenInvalidException) {
            return $this->handleTokenInvalidException($previous, $request);
        }
        if ($previous instanceof JWTException) {
            return $this->handleJWTException($previous, $request);
        }

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'Unauthorized',
                'status' => 401,
                'message' => 'Authentication required to access this resource.',
                'code' => 'UNAUTHORIZED',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle authentication exceptions
     */
    public function handleAuthenticationException(
        AuthenticationException|AccessDeniedHttpException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Authentication failed');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'AuthenticationRequired',
                'status' => 401,
                'message' => 'Authentication required. Please provide valid credentials.',
                'code' => 'AUTHENTICATION_REQUIRED',
                'timestamp' => now()->toISOString(),
            ]
        ], 401);
    }

    /**
     * Handle insufficient stock exceptions
     */
    public function handleInsufficientStockException(
        \App\Exceptions\InsufficientStockException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Insufficient ticket stock');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'InsufficientStock',
                'status' => 409,
                'message' => $e->getMessage(),
                'code' => 'INSUFFICIENT_STOCK',
                'timestamp' => now()->toISOString(),
            ]
        ], 409);
    }

    /**
     * Handle event expired exceptions
     */
    public function handleEventExpiredException(
        \App\Exceptions\EventExpiredException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Event sales expired');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'EventExpired',
                'status' => 410,
                'message' => $e->getMessage(),
                'code' => 'EVENT_SALES_ENDED',
                'timestamp' => now()->toISOString(),
            ]
        ], 410);
    }

    /**
     * Handle ticket cancellation exceptions
     */
    public function handleTicketCancellationException(
        \App\Exceptions\TicketCancellationException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Ticket cancellation failed');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'TicketCancellationFailed',
                'status' => 422,
                'message' => $e->getMessage(),
                'code' => 'CANCELLATION_NOT_ALLOWED',
                'timestamp' => now()->toISOString(),
            ]
        ], 422);
    }

    /**
     * Handle payment processing exceptions
     */
    public function handlePaymentProcessingException(
        \App\Exceptions\PaymentProcessingException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Payment processing failed');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'PaymentFailed',
                'status' => 402,
                'message' => $e->getMessage(),
                'code' => 'PAYMENT_PROCESSING_FAILED',
                'timestamp' => now()->toISOString(),
            ]
        ], 402);
    }

    /**
     * Handle validation exceptions
     */
    public function handleValidationException(
        ValidationException $e,
        Request $request
    ): JsonResponse {
        $errors = [];

        foreach ($e->errors() as $field => $messages) {
            foreach ($messages as $message) {
                $errors[] = [
                    'field' => $field,
                    'message' => $message,
                ];
            }
        }

        $this->logException($e, 'Validation failed', ['errors' => $errors]);

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'ValidationError',
                'status' => 422,
                'message' => 'The provided data is invalid.',
                'code' => 'VALIDATION_FAILED',
                'timestamp' => now()->toISOString(),
                'validation_errors' => $errors,
            ]
        ], 422);
    }

    /**
     * Handle not found exceptions
     */
    public function handleNotFoundException(
        ModelNotFoundException|NotFoundHttpException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Resource not found');

        if ($e instanceof ModelNotFoundException) {
            // Extract model name for better error message
            $model = class_basename($e->getModel());
            $message = "The requested {$model} was not found.";
            $code = 'RESOURCE_NOT_FOUND';
        } else {
            $message = "The requested endpoint '{$request->getRequestUri()}' was not found.";
            $code = 'ENDPOINT_NOT_FOUND';
        }

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'NotFound',
                'status' => 404,
                'message' => $message,
                'code' => $code,
                'timestamp' => now()->toISOString(),
            ]
        ], 404);
    }

    /**
     * Handle method not allowed exceptions
     */
    public function handleMethodNotAllowedException(
        MethodNotAllowedHttpException $e,
        Request $request
    ): JsonResponse {
        $this->logException($e, 'Method not allowed');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'MethodNotAllowed',
                'status' => 405,
                'message' => "The {$request->method()} method is not allowed for this endpoint.",
                'code' => 'METHOD_NOT_ALLOWED',
                'timestamp' => now()->toISOString(),
                'allowed_methods' => $e->getHeaders()['Allow'] ?? 'Unknown',
            ]
        ], 405);
    }

    /**
     * Handle general HTTP exceptions
     */
    public function handleHttpException(HttpException $e, Request $request): JsonResponse
    {
        $this->logException($e, 'HTTP exception occurred');

        return response()->json([
            'success' => false,
            'error' => [
                'type' => 'HttpError',
                'status' => $e->getStatusCode(),
                'message' => $e->getMessage() ?: 'An HTTP error occurred.',
                'code' => 'HTTP_ERROR',
                'timestamp' => now()->toISOString(),
            ]
        ], $e->getStatusCode());
    }

    /**
     * Handle database query exceptions
     */
    public function handleQueryException(QueryException $e, Request $request): JsonResponse
    {
        $this->logException($e, 'Database query failed', [
            'sql' => $e->getSql(),
            'bindings' => $e->getBindings()
        ]);

        // Handle specific database constraint violations
        $errorCode = $e->errorInfo[1] ?? null;

        switch ($errorCode) {
            case 1451: // Foreign key constraint violation
                return response()->json([
                    'success' => false,
                    'error' => [
                        'type' => 'DatabaseConstraintViolation',
                        'status' => 409,
                        'message' => 'Cannot delete this resource because it is referenced by other records.',
                        'code' => 'FOREIGN_KEY_CONSTRAINT',
                        'timestamp' => now()->toISOString(),
                    ]
                ], 409);

            case 1062: // Duplicate entry
                return response()->json([
                    'success' => false,
                    'error' => [
                        'type' => 'DuplicateEntry',
                        'status' => 409,
                        'message' => 'A record with this information already exists.',
                        'code' => 'DUPLICATE_ENTRY',
                        'timestamp' => now()->toISOString(),
                    ]
                ], 409);

            case 1054: // Unknown column
                return response()->json([
                    'success' => false,
                    'error' => [
                        'type' => 'DatabaseError',
                        'status' => 500,
                        'message' => 'Database structure error occurred.',
                        'code' => 'DATABASE_STRUCTURE_ERROR',
                        'timestamp' => now()->toISOString(),
                    ]
                ], 500);

            default:
                return response()->json([
                    'success' => false,
                    'error' => [
                        'type' => 'DatabaseError',
                        'status' => 500,
                        'message' => 'A database error occurred. Please try again later.',
                        'code' => 'DATABASE_ERROR',
                        'timestamp' => now()->toISOString(),
                    ]
                ], 500);
        }
    }

    /**
     * Extract a clean exception type name
     */
    private function getExceptionType(Throwable $e): string
    {
        $className = basename(str_replace('\\', '/', get_class($e)));
        return $className;
    }

    /**
     * Log exception with context
     */
    private function logException(Throwable $e, string $message, array $context = []): void
    {
        $logContext = array_merge([
            'exception' => get_class($e),
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'url' => request()->fullUrl(),
            'method' => request()->method(),
            'ip' => request()->ip(),
            'user_agent' => request()->userAgent(),
            'user_id' => auth('api')->id(),
        ], $context);

        // Log as error for 5xx status codes, warning for others
        $statusCode = $e instanceof HttpExceptionInterface ? $e->getStatusCode() : 500;

        if ($statusCode >= 500) {
            Log::error($message, $logContext);
        } else {
            Log::warning($message, $logContext);
        }
    }
}
