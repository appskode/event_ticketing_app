<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;

class AuthService extends BaseService
{
    /**
     * Register a new user
     */
    public function register(array $data): array
    {
        try {
            $validatedData = $this->validate($data, [
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'password' => 'required|string|min:6|confirmed',
                'role' => 'prohibited',
            ]);

            $user = User::create([
                'name' => $validatedData['name'],
                'email' => $validatedData['email'],
                'password' => Hash::make($validatedData['password']),
                'role' => 'user',
            ]);

            $token = JWTAuth::fromUser($user);

            return [
                'user' => $user,
                'token' => $token,
            ];
        } catch (\Exception $e) {
            $this->handleException($e, 'User Registration');
            throw $e;
        }
    }

    /**
     * Login user
     */
    public function login(array $credentials): array
    {
        try {
            if (!$token = JWTAuth::attempt($credentials)) {
                throw new \Illuminate\Auth\AuthenticationException('Invalid credentials');
            }

            $user = JWTAuth::user();

            return [
                'user' => $user,
                'token' => $token,
            ];
        } catch (\Exception $e) {
            $this->handleException($e, 'User Login');
            throw $e;
        }
    }

    /**
     * Logout user
     */
    public function logout(): bool
    {
        try {
            JWTAuth::invalidate(JWTAuth::getToken());
            return true;
        } catch (JWTException $e) {
            $this->handleException($e, 'User Logout');
            throw $e;
        }
    }

    /**
     * Refresh token
     */
    public function refreshToken(): string
    {
        try {
            return JWTAuth::parseToken()->refresh();
        } catch (JWTException $e) {
            $this->handleException($e, 'Token Refresh');
            throw $e;
        }
    }

    /**
     * Get current user
     */
    public function getCurrentUser(): ?User
    {
        return auth('api')->user();
    }
}
