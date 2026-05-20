<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        \Illuminate\Support\Facades\Schema::disableForeignKeyConstraints();
        \App\Models\Ticket::truncate();
        \App\Models\Purchase::truncate();
        \App\Models\TicketType::truncate();
        \App\Models\Event::truncate();
        \Illuminate\Support\Facades\Schema::enableForeignKeyConstraints();

        $this->call([
            UserSeeder::class,
            EventSeeder::class,
            TicketTypeSeeder::class,
        ]);
    }
}
