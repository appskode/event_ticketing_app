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
        Schema::create('ticket_types', function (Blueprint $table) {
            $table->id();
            $table->foreignId('event_id')->constrained()->cascadeOnDelete();
            $table->string('name'); // VIP, Early Bird, General Admission
            $table->text('description')->nullable();
            $table->decimal('price', 10, 2);
            $table->integer('total_quantity');
            $table->integer('available_quantity');
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['event_id', 'is_active']);
            $table->index('available_quantity');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ticket_types');
    }
};
