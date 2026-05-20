<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class Ticket extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'event_id',
        'ticket_type_id',
        'purchase_id',
        'ticket_code',
        'status',
        'price_paid',
        'purchased_at',
        'cancelled_at',
    ];

    protected $casts = [
        'price_paid' => 'decimal:2',
        'purchased_at' => 'datetime',
        'cancelled_at' => 'datetime',
    ];

    // Boot method for auto-generating ticket code
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($ticket) {
            $ticket->ticket_code = 'TKT-' . strtoupper(Str::random(8));
            $ticket->purchased_at = now();
        });
    }

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function ticketType()
    {
        return $this->belongsTo(TicketType::class);
    }

    public function purchase()
    {
        return $this->belongsTo(Purchase::class);
    }

    // Methods
    public function canBeCancelled(): bool
    {
        return $this->status === 'active'
            && $this->event->can_be_cancelled;
    }

    public function cancel(): bool
    {
        if (!$this->canBeCancelled()) {
            return false;
        }

        $this->update([
            'status' => 'cancelled',
            'cancelled_at' => now(),
        ]);

        $this->ticketType->increment('available_quantity');

        return true;
    }
}
