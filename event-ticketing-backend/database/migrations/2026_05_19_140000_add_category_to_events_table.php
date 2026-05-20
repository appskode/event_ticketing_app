<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('events', function (Blueprint $table) {
            $table->string('category', 50)->default('general')->after('location');
            $table->index('category');
            $table->index(['category', 'event_date']);
        });
    }

    public function down(): void
    {
        Schema::table('events', function (Blueprint $table) {
            $table->dropIndex(['category', 'event_date']);
            $table->dropIndex(['category']);
            $table->dropColumn('category');
        });
    }
};
