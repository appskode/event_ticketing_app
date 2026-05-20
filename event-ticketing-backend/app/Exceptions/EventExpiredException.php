<?php

namespace App\Exceptions;

use Exception;

class EventExpiredException extends Exception
{
    protected $message = 'Event sales have ended';
    protected $code = 410;

    public function __construct(string $eventName)
    {
        $this->message = "Ticket sales for '{$eventName}' have ended";
        parent::__construct($this->message, $this->code);
    }
}
