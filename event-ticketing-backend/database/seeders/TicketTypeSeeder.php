<?php

namespace Database\Seeders;

use App\Models\Event;
use App\Models\TicketType;
use Illuminate\Database\Seeder;

class TicketTypeSeeder extends Seeder
{
    public function run(): void
    {
        $templates = [
            'music' => [
                ['name' => 'Early Bird', 'description' => 'Limited early pricing', 'price' => 79.99, 'qty' => 400],
                ['name' => 'General Admission', 'description' => 'Standard festival access', 'price' => 119.99, 'qty' => 2500],
                ['name' => 'VIP', 'description' => 'Premium viewing and lounge access', 'price' => 249.99, 'qty' => 250],
            ],
            'tech' => [
                ['name' => 'Student', 'description' => 'Valid student ID required at entry', 'price' => 89.00, 'qty' => 150],
                ['name' => 'Standard', 'description' => 'Full conference access', 'price' => 279.00, 'qty' => 600],
                ['name' => 'Premium', 'description' => 'Workshops + networking reception', 'price' => 499.00, 'qty' => 120],
            ],
            'food_drink' => [
                ['name' => 'Tasting Pass', 'description' => 'Entry plus 5 tasting tokens', 'price' => 65.00, 'qty' => 800],
                ['name' => 'VIP Chef Table', 'description' => 'Reserved seating and chef pairing', 'price' => 185.00, 'qty' => 80],
            ],
            'sports' => [
                ['name' => 'Participant', 'description' => 'Race bib and finisher medal', 'price' => 55.00, 'qty' => 2000],
                ['name' => 'Spectator', 'description' => 'Course-side viewing areas', 'price' => 25.00, 'qty' => 500],
            ],
            'arts' => [
                ['name' => 'Day Pass', 'description' => 'Access to all exhibits for one day', 'price' => 45.00, 'qty' => 400],
                ['name' => 'Weekend Pass', 'description' => 'Full weekend gallery access', 'price' => 75.00, 'qty' => 300],
            ],
            'comedy' => [
                ['name' => 'Standard', 'description' => 'General seating', 'price' => 35.00, 'qty' => 350],
                ['name' => 'Front Row', 'description' => 'Reserved front section', 'price' => 65.00, 'qty' => 60],
            ],
            'business' => [
                ['name' => 'Professional', 'description' => 'Sessions and lunch included', 'price' => 149.00, 'qty' => 250],
                ['name' => 'Executive', 'description' => 'VIP seating and speaker meet & greet', 'price' => 299.00, 'qty' => 75],
            ],
            'wellness' => [
                ['name' => 'Half Day', 'description' => 'Morning or afternoon sessions', 'price' => 89.00, 'qty' => 120],
                ['name' => 'Full Retreat', 'description' => 'All workshops and meals included', 'price' => 199.00, 'qty' => 80],
            ],
            'general' => [
                ['name' => 'Standard', 'description' => 'General event access', 'price' => 50.00, 'qty' => 200],
                ['name' => 'Premium', 'description' => 'Enhanced experience package', 'price' => 120.00, 'qty' => 50],
            ],
        ];

        foreach (Event::all() as $event) {
            $tiers = $templates[$event->category] ?? $templates['general'];

            foreach ($tiers as $tier) {
                TicketType::create([
                    'event_id' => $event->id,
                    'name' => $tier['name'],
                    'description' => $tier['description'],
                    'price' => $tier['price'],
                    'total_quantity' => $tier['qty'],
                    'available_quantity' => $tier['qty'],
                ]);
            }
        }
    }
}
