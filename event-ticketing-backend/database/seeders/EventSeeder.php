<?php

namespace Database\Seeders;

use App\Models\Event;
use Carbon\Carbon;
use Illuminate\Database\Seeder;

class EventSeeder extends Seeder
{
    private Carbon $today;

    public function run(): void
    {
        $this->today = Carbon::now()->startOfDay();

        foreach ($this->events() as $event) {
            Event::create($event);
        }
    }

    private function events(): array
    {
        return [
            // Music
            $this->row('Brooklyn Summer Music Festival 2026', 'music', 'Brooklyn Mirage, New York', 'Three stages, 40+ artists, and sunset sets across Memorial Day weekend.', $this->unsplash('1470229722913-7c0e2dbbafd3'), 25),
            $this->row('Indie Nights at The Fillmore', 'music', 'The Fillmore, San Francisco', 'An intimate weeknight series spotlighting rising indie bands.', $this->unsplash('1493225457124-a3eb161ffa5f'), 28),
            $this->row('Jazz on the Hudson', 'music', 'Pier 84, New York', 'Open-air jazz with skyline views and local food vendors.', $this->unsplash('1511671782779-c97d3d27a1d4'), 8),
            $this->row('EDM Glow Night', 'music', 'Warehouse District, Austin', 'Late-night electronic showcase with immersive light installations.', $this->unsplash('1501281668745-f7f57925c3b4'), 14),

            // Tech
            $this->row('FutureStack Dev Summit 2026', 'tech', 'Moscone Center, San Francisco', 'Keynotes on AI, platform engineering, and cloud-native architecture.', $this->unsplash('1540575467063-178a50c2df87'), 3),
            $this->row('Mobile Builders Workshop', 'tech', 'WeWork Midtown, Atlanta', 'Hands-on Flutter, SwiftUI, and CI/CD labs for product teams.', $this->unsplash('1522071820081-009f0129c71c'), 10),
            $this->row('Cybersecurity Briefing', 'tech', 'Convention Center, Washington DC', 'Threat modeling, zero trust, and incident response for enterprise IT.', $this->unsplash('1556761175-b413da4baf72'), 17),
            $this->row('Startup Pitch Night', 'tech', 'TechHub, Seattle', 'Ten early-stage founders pitch to angels and VCs.', $this->unsplash('1559136555-9303baea8ebd'), 22),

            // Food & drink
            $this->row('Napa Spring Wine & Food Festival', 'food_drink', 'Napa Valley, California', 'Winery pairings, chef demos, and vineyard tours.', $this->unsplash('1504674900247-0877df9cc836'), 30, allowCancellation: false),
            $this->row('Portland Street Food Fair', 'food_drink', 'Waterfront Park, Portland', '50+ food trucks, craft beer, and live acoustic sets.', $this->unsplash('1555939594-58d7cb561ad1'), 12),
            $this->row('BBQ Masters Championship', 'food_drink', 'Fair Park, Dallas', 'Pitmasters compete across Texas-style, Kansas City, and Carolina categories.', $this->unsplash('1529193591184-b1d58069ecdd'), 19),
            $this->row('Artisan Coffee Expo', 'food_drink', 'River North, Chicago', 'Roasters, latte art battles, and brewing masterclasses.', $this->unsplash('1509042239860-f550ce710b93'), 5),

            // Sports
            $this->row('City Half Marathon 2026', 'sports', 'Downtown, Boston', 'USATF-certified 13.1-mile course through historic neighborhoods.', $this->unsplash('1552674605-db6ffd4facb5'), 31),
            $this->row('Community Soccer Cup', 'sports', 'Riverside Fields, Denver', 'Adult 7-a-side tournament with youth clinics.', $this->unsplash('1574629810360-7efbbe195018'), 7),
            $this->row('Outdoor Yoga & Wellness 5K', 'sports', 'Griffith Park, Los Angeles', 'Morning flow session followed by a scenic trail run.', $this->unsplash('1544367567-0f2fcb009e0b'), 15),

            // Arts
            $this->row('Modern Art Weekender', 'arts', 'Museum District, Houston', 'Gallery hops, curator talks, and interactive installations.', $this->unsplash('1460661419201-fd4cecdf8a8b'), 21),
            $this->row('Broadway Under the Stars', 'arts', 'Central Park, New York', 'Outdoor performances of classic and contemporary musical theatre.', $this->unsplash('1501281668745-f7f57925c3b4'), 27),

            // Comedy
            $this->row('Laugh Factory Live Tour', 'comedy', 'Comedy Cellar, New York', 'National headliners and surprise guest sets.', $this->unsplash('1514933651103-005eec06c04b'), 9),
            $this->row('Improv Jam Night', 'comedy', 'Second City, Chicago', 'Audience-driven improv with rotating house teams.', $this->unsplash('1511379938547-c1f69419868d'), 16),

            // Business
            $this->row('Product Leaders Forum', 'business', 'Marriott Marquis, New York', 'Roadmapping, metrics, and stakeholder alignment for PMs.', $this->unsplash('1511578314322-379afb476865'), 4),
            $this->row('Women in Tech Networking Brunch', 'business', 'The LINE Hotel, Austin', 'Panels, mentorship roundtables, and recruiter meetups.', $this->unsplash('1517245386807-bb43f82c33c4'), 11),

            // Wellness
            $this->row('Mindful Living Retreat', 'wellness', 'Sedona Red Rocks, Arizona', 'Meditation, breathwork, and guided canyon hikes.', $this->unsplash('1506905925346-21bda4d32df4'), 29),
            $this->row('Urban Wellness Fair', 'wellness', 'Piedmont Park, Atlanta', 'Fitness demos, nutrition talks, and holistic health vendors.', $this->unsplash('1534438327276-14e5300c3a48'), 18),

            // Past event (sales closed, for testing past filter)
            $this->rowPast('Spring Gala 2026 (Ended)', 'general', 'Grand Ballroom, Miami', 'Annual charity gala — event has concluded.', $this->unsplash('1519167758481-83f550bb49b3')),
        ];
    }

    private function unsplash(string $photoId): string
    {
        return "https://images.unsplash.com/photo-{$photoId}?w=800&q=80&auto=format&fit=crop";
    }

    /**
     * Upcoming event with sales open now through the day before the event.
     */
    private function row(
        string $name,
        string $category,
        string $location,
        string $description,
        string $imageUrl,
        int $eventDaysFromToday,
        int $cancellationHours = 48,
        bool $allowCancellation = true,
    ): array {
        $eventDate = $this->today->copy()->addDays($eventDaysFromToday)->setTime(18, 0);
        $saleStart = $this->today->copy()->subDays(14)->setTime(9, 0);
        $saleEnd = $eventDate->copy()->subDay()->setTime(23, 59, 59);

        return [
            'name' => $name,
            'category' => $category,
            'description' => $description,
            'location' => $location,
            'image_url' => $imageUrl,
            'event_date' => $eventDate,
            'sale_start_date' => $saleStart,
            'sale_end_date' => $saleEnd,
            'is_active' => true,
            'allow_cancellation' => $allowCancellation,
            'cancellation_hours_before' => $cancellationHours,
        ];
    }

    private function rowPast(
        string $name,
        string $category,
        string $location,
        string $description,
        string $imageUrl,
    ): array {
        $eventDate = $this->today->copy()->subDays(5)->setTime(18, 0);

        return [
            'name' => $name,
            'category' => $category,
            'description' => $description,
            'location' => $location,
            'image_url' => $imageUrl,
            'event_date' => $eventDate,
            'sale_start_date' => $eventDate->copy()->subDays(30)->setTime(9, 0),
            'sale_end_date' => $eventDate->copy()->subDay()->setTime(23, 59, 59),
            'is_active' => true,
            'allow_cancellation' => true,
            'cancellation_hours_before' => 48,
        ];
    }
}
