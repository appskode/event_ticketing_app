<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Facades\JWTAuth;
use Illuminate\Support\Facades\Log;
class JwtMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Debug: Log that middleware is being called
        Log::info('JWT Middleware called for URL: ' . $request->url());

        try {
            $user = JWTAuth::parseToken()->authenticate();

            Log::info('JWT Token parsed successfully, user: ' . ($user ? $user->id : 'null'));

            if (!$user) {
                Log::warning('JWT: User not found after token parsing');
                return response()->json([
                    'success' => false,
                    'message' => 'User not found'
                ], 401);
            }

            // Set the authenticated user for this request
            Auth::setUser($user);

        } catch (TokenExpiredException $e) {
            Log::warning('JWT: Token expired');
            return response()->json([
                'success' => false,
                'message' => 'Token expired'
            ], 401);

        } catch (TokenInvalidException $e) {
            Log::warning('JWT: Token invalid');
            return response()->json([
                'success' => false,
                'message' => 'Token invalid'
            ], 401);

        } catch (JWTException $e) {
            Log::warning('JWT: Token not provided - ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Token not provided'
            ], 401);
        }

        return $next($request);
    }
}
