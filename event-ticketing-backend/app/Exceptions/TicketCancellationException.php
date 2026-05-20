<?php

namespace App\Exceptions;

use Exception;

class TicketCancellationException extends Exception
{
    protected $message = 'Ticket cannot be cancelled';
    protected $code = 422;

    public function __construct(string $reason)
    {
        $this->message = "Ticket cannot be cancelled: {$reason}";
        parent::__construct($this->message, $this->code);
    }
}
