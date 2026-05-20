<?php

namespace App\Services;

use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;


abstract class BaseService
{
    /**
     * Handle service exceptions consistently
     */
    protected function handleException(\Exception $e, string $context = '')
    {
        Log::error("Service Error in {$context}: " . $e->getMessage(), [
            'exception' => $e,
            'context' => $context
        ]);

        throw $e;
    }

    /**
     * Validate data using Laravel validator
     */
    protected function validate(array $data, array $rules, array $messages = [])
    {
        $validator = Validator::make($data, $rules, $messages);

        if ($validator->fails()) {
            throw new \Illuminate\Validation\ValidationException($validator);
        }

        return $validator->validated();
    }
}
