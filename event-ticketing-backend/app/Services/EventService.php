<?php

namespace App\Services;

use App\Models\Event;
use App\Models\TicketType;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;

class EventService extends BaseService
{
    /**
     * Get paginated events with optional filters.
     *
     * Query params: page, per_page, category, location, date_from, date_to,
     * on_sale, upcoming, past, q, sort, sort_dir, include_inactive
     */
    public function getEvents(array $params = []): LengthAwarePaginator
    {
        try {
            $filters = $this->validateEventFilters($params);
            $query = $this->buildFilteredEventsQuery($filters);

            $perPage = min($filters['per_page'] ?? 10, 50);

            return $query->paginate($perPage);
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Events');
            throw $e;
        }
    }

    /**
     * List event categories with active upcoming event counts.
     */
    public function getCategories(): array
    {
        try {
            $labels = config('event_categories', []);
            $counts = Event::query()
                ->active()
                ->upcoming()
                ->selectRaw('category, COUNT(*) as count')
                ->groupBy('category')
                ->pluck('count', 'category');

            return collect(Event::CATEGORIES)->map(function (string $key) use ($labels, $counts) {
                return [
                    'key' => $key,
                    'label' => $labels[$key] ?? ucfirst(str_replace('_', ' ', $key)),
                    'event_count' => (int) ($counts[$key] ?? 0),
                ];
            })->values()->all();
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Categories');
            throw $e;
        }
    }

    protected function validateEventFilters(array $params): array
    {
        return $this->validate($params, [
            'page' => 'sometimes|integer|min:1',
            'per_page' => 'sometimes|integer|min:1|max:50',
            'category' => 'sometimes|string|max:255',
            'location' => 'sometimes|string|max:255',
            'date_from' => 'sometimes|date|date_format:Y-m-d',
            'date_to' => 'sometimes|date|date_format:Y-m-d|after_or_equal:date_from',
            'on_sale' => 'sometimes|boolean',
            'upcoming' => 'sometimes|boolean',
            'past' => 'sometimes|boolean',
            'q' => 'sometimes|string|max:255',
            'sort' => 'sometimes|string|in:event_date,name,created_at,category',
            'sort_dir' => 'sometimes|string|in:asc,desc',
            'include_inactive' => 'sometimes|boolean',
        ]);
    }

    protected function buildFilteredEventsQuery(array $filters)
    {
        $query = Event::query()->with(['ticketTypes' => function ($q) {
            $q->active()->available();
        }]);

        if (! ($filters['include_inactive'] ?? false)) {
            $query->active();
        }

        if ($filters['past'] ?? false) {
            $query->past();
        } elseif ($filters['upcoming'] ?? true) {
            $query->upcoming();
        }

        if ($filters['on_sale'] ?? false) {
            $query->availableForSale();
        }

        if (! empty($filters['category'])) {
            $categories = array_intersect(
                array_map('trim', explode(',', $filters['category'])),
                Event::CATEGORIES
            );
            if ($categories !== []) {
                $query->inCategory($categories);
            }
        }

        if (! empty($filters['location'])) {
            $query->where('location', 'LIKE', '%'.$filters['location'].'%');
        }

        if (! empty($filters['date_from'])) {
            $query->whereDate('event_date', '>=', $filters['date_from']);
        }

        if (! empty($filters['date_to'])) {
            $query->whereDate('event_date', '<=', $filters['date_to']);
        }

        if (! empty($filters['q'])) {
            $term = $filters['q'];
            $query->where(function ($q) use ($term) {
                $q->where('name', 'LIKE', "%{$term}%")
                    ->orWhere('description', 'LIKE', "%{$term}%")
                    ->orWhere('location', 'LIKE', "%{$term}%");
            });
        }

        $sort = $filters['sort'] ?? 'event_date';
        $sortDir = $filters['sort_dir'] ?? 'asc';
        $query->orderBy($sort, $sortDir);

        return $query;
    }

    /**
     * Get single event
     */
    public function getEvent(int $id): Event
    {
        try {
            $event = Event::with(['ticketTypes' => function ($query) {
                $query->active();
            }])->find($id);

            if (!$event) {
                throw new \Illuminate\Database\Eloquent\ModelNotFoundException('Event not found');
            }

            return $event;
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Event');
            throw $e;
        }
    }

    /**
     * Create new event
     */
    public function createEvent(array $data): Event
    {
        try {
            $validatedData = $this->validate($data, [
                'name' => 'required|string|max:255',
                'description' => 'required|string',
                'location' => 'required|string|max:255',
                'category' => 'required|string|in:'.implode(',', Event::CATEGORIES),
                'image_url' => 'nullable|url',
                'event_date' => 'required|date|after:now',
                'sale_start_date' => 'required|date|before:event_date',
                'sale_end_date' => 'required|date|after:sale_start_date|before:event_date',
                'allow_cancellation' => 'boolean',
                'cancellation_hours_before' => 'integer|min:1|max:168',
            ]);

            return Event::create($validatedData);
        } catch (\Exception $e) {
            $this->handleException($e, 'Create Event');
            throw $e;
        }
    }

    /**
     * Add ticket type to event
     */
    public function addTicketType(int $eventId, array $data): TicketType
    {
        try {
            $event = $this->getEvent($eventId);

            $validatedData = $this->validate($data, [
                'name' => 'required|string|max:255',
                'description' => 'nullable|string',
                'price' => 'required|numeric|min:0',
                'total_quantity' => 'required|integer|min:1',
            ]);

            return TicketType::create([
                'event_id' => $event->id,
                'name' => $validatedData['name'],
                'description' => $validatedData['description'],
                'price' => $validatedData['price'],
                'total_quantity' => $validatedData['total_quantity'],
                'available_quantity' => $validatedData['total_quantity'],
            ]);
        } catch (\Exception $e) {
            $this->handleException($e, 'Add Ticket Type');
            throw $e;
        }
    }


    /**
     * Search events - FIXED VERSION
     */
    public function searchEvents(array $searchParams): LengthAwarePaginator
    {
        try {
            $validatedData = $this->validate($searchParams, [
                'q' => 'required|string|min:1|max:255',
                'page' => 'sometimes|integer|min:1',
                'per_page' => 'sometimes|integer|min:1|max:50',
                'location' => 'sometimes|string|max:255',
                'category' => 'sometimes|string|max:255',
                'date_from' => 'sometimes|date|date_format:Y-m-d',
                'date_to' => 'sometimes|date|date_format:Y-m-d|after_or_equal:date_from',
                'on_sale' => 'sometimes|boolean',
            ]);

            $validatedData['on_sale'] = $validatedData['on_sale'] ?? true;

            $query = $this->buildFilteredEventsQuery($validatedData);

            $query->orderByRaw('CASE WHEN name LIKE ? THEN 1 ELSE 2 END', [$validatedData['q'].'%'])
                ->orderBy('event_date', 'asc');

            $perPage = min($validatedData['per_page'] ?? 10, 50);
            $events = $query->paginate($perPage);

            $events->getCollection()->transform(function ($event) {
                $event->min_price = $event->ticketTypes->min('price') ?? 0;
                $event->max_price = $event->ticketTypes->max('price') ?? 0;
                $event->has_available_tickets = $event->ticketTypes->some(function ($ticketType) {
                    return $ticketType->available_quantity > 0;
                });
                $event->days_until_event = now()->diffInDays($event->event_date, false);
                return $event;
            });

            return $events;
        } catch (\Exception $e) {
            $this->handleException($e, 'Search Events');
            throw $e;
        }
    }

    /**
     * Get search suggestions
     */
    public function getSearchSuggestions(string $searchTerm, int $limit = 5): array
    {
        try {
            $suggestions = collect();

            // Get event suggestions
            $events = DB::table('events')
                ->where('name', 'LIKE', '%' . $searchTerm . '%')
                ->where('event_date', '>=', now())
                ->select('name', 'location', 'event_date')
                ->orderByRaw("CASE WHEN name LIKE ? THEN 1 ELSE 2 END", [$searchTerm . '%'])
                ->limit($limit)
                ->get();

            foreach ($events as $event) {
                $suggestions->push([
                    'type' => 'event',
                    'text' => $event->name,
                    'subtitle' => $event->location . ' • ' . \Carbon\Carbon::parse($event->event_date)->format('M d, Y'),
                    'value' => $event->name
                ]);
            }

            // Get location suggestions if we have space
            if ($suggestions->count() < $limit) {
                $remainingLimit = $limit - $suggestions->count();

                $locations = DB::table('events')
                    ->where('location', 'LIKE', '%' . $searchTerm . '%')
                    ->where('event_date', '>=', now())
                    ->select('location')
                    ->distinct()
                    ->limit($remainingLimit)
                    ->get();

                foreach ($locations as $location) {
                    $suggestions->push([
                        'type' => 'location',
                        'text' => $location->location,
                        'subtitle' => 'Location',
                        'value' => $location->location
                    ]);
                }
            }

            return $suggestions->take($limit)->values()->toArray();
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Search Suggestions');
            throw $e;
        }
    }
}
