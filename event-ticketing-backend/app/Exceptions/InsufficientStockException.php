<?php
// app/Exceptions/InsufficientStockException.php

namespace App\Exceptions;

use Exception;

class InsufficientStockException extends Exception
{
    protected $message = 'Insufficient ticket stock available';
    protected $code = 409;

    public function __construct(string $ticketTypeName, int $available, int $requested)
    {
        $this->message = "Insufficient stock for '{$ticketTypeName}'. Available: {$available}, Requested: {$requested}";
        parent::__construct($this->message, $this->code);
    }
}
