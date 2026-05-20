<?php

namespace App\Exceptions;

use Exception;

class PaymentProcessingException extends Exception
{
    protected $message = 'Payment processing failed';
    protected $code = 402;

    public function __construct(string $reason = '')
    {
        $this->message = $reason ? "Payment processing failed: {$reason}" : $this->message;
        parent::__construct($this->message, $this->code);
    }
}
