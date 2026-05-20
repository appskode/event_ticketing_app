<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Support\Str;

class Purchase extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'purchase_code',
        'total_amount',
        'status',
        'purchase_details',
    ];

    protected $casts = [
        'total_amount' => 'decimal:2',
        'purchase_details' => 'array',
    ];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($purchase) {
            $purchase->purchase_code = 'PUR-' . strtoupper(Str::random(8));
        });
    }

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function tickets()
    {
        return $this->hasMany(Ticket::class);
    }
}
