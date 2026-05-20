<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description');
            $table->string('location');
            $table->string('image_url')->nullable();
            $table->dateTime('event_date');
            $table->dateTime('sale_start_date');
            $table->dateTime('sale_end_date');
            $table->boolean('is_active')->default(true);
            $table->boolean('allow_cancellation')->default(true);
            $table->integer('cancellation_hours_before')->default(24);
            $table->timestamps();

            $table->index(['is_active', 'event_date']);
            $table->index('sale_start_date');
            $table->index('sale_end_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('events');
    }
};
