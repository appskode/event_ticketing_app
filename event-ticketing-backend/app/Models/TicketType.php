<?php

namespace App\Models;


use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Builder;

class TicketType extends Model
{
    use HasFactory;

    protected $fillable = [
        'event_id',
        'name',
        'description',
        'price',
        'total_quantity',
        'available_quantity',
        'is_active',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_active' => 'boolean',
    ];
    public function toArray()
    {
        $array = parent::toArray();
        $array['price'] = (float) $this->price;
        return $array;
    }
    public function getPriceAttribute($value)
{
    return (float) $value;
} 
    // Relationships
    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function tickets()
    {
        return $this->hasMany(Ticket::class);
    }

    // Scopes
    public function scopeActive(Builder $query)
    {
        return $query->where('is_active', true);
    }

    public function scopeAvailable(Builder $query)
    {
        return $query->where('is_active', true)
                    ->where('available_quantity', '>', 0);
    }

    // Methods
    public function reserveTickets(int $quantity): bool
    {
        if ($this->available_quantity < $quantity) {
            return false;
        }

        $this->decrement('available_quantity', $quantity);
        return true;
    }

    public function releaseTickets(int $quantity): void
    {
        $this->increment('available_quantity', $quantity);
    }
}
