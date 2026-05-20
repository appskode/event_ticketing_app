<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\EventService;


/**
 * @OA\Tag(
 *     name="Events",
 *     description="API Endpoints for event management"
 * )
 */
class EventController extends Controller
{

    protected $eventService;

    public function __construct(EventService $eventService)
    {
        $this->eventService = $eventService;
    }

    /**
     * @OA\Get(
     *     path="/api/events",
     *     operationId="getEvents",
     *     tags={"Events"},
     *     summary="Get paginated list of events",
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="Page number",
     *         required=false,
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Parameter(
     *         name="per_page",
     *         in="query",
     *         description="Items per page",
     *         required=false,
     *         @OA\Schema(type="integer", example=10)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Events retrieved successfully"
     *     )
     * )
     */
    public function index(Request $request)
    {
        try {
            $events = $this->eventService->getEvents($request->all());

            return response()->json([
                'success' => true,
                'data' => $events,
                'message' => 'Events retrieved successfully',
                'filters_applied' => array_filter($request->only([
                    'category', 'location', 'date_from', 'date_to',
                    'on_sale', 'upcoming', 'past', 'q', 'sort', 'sort_dir',
                ])),
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve events',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/events/{id}",
     *     operationId="getEvent",
     *     tags={"Events"},
     *     summary="Get single event with ticket types",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="Event ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Event retrieved successfully"
     *     )
     * )
     */
    public function categories()
    {
        try {
            return response()->json([
                'success' => true,
                'data' => $this->eventService->getCategories(),
                'message' => 'Categories retrieved successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve categories',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error',
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $event = $this->eventService->getEvent($id);

            return response()->json([
                'success' => true,
                'data' => $event,
                'message' => 'Event retrieved successfully'
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Event not found'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve event',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Post(
     *     path="/api/events",
     *     operationId="createEvent",
     *     tags={"Events"},
     *     summary="Create event (Admin only)",
     *     security={{"bearerAuth":{}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"name","description","location","event_date","sale_start_date","sale_end_date"},
     *             @OA\Property(property="name", type="string", example="Summer Music Festival"),
     *             @OA\Property(property="description", type="string", example="Annual summer music festival"),
     *             @OA\Property(property="location", type="string", example="Central Park, New York"),
     *             @OA\Property(property="image_url", type="string", example="https://example.com/image.jpg"),
     *             @OA\Property(property="event_date", type="string", format="datetime", example="2025-07-15 18:00:00"),
     *             @OA\Property(property="sale_start_date", type="string", format="datetime", example="2025-06-01 10:00:00"),
     *             @OA\Property(property="sale_end_date", type="string", format="datetime", example="2025-07-14 23:59:59"),
     *             @OA\Property(property="allow_cancellation", type="boolean", example=true),
     *             @OA\Property(property="cancellation_hours_before", type="integer", example=24)
     *         )
     *     ),
     *     @OA\Response(
     *         response=201,
     *         description="Event created successfully"
     *     )
     * )
     */
    public function store(Request $request)
    {
        try {
            $event = $this->eventService->createEvent($request->all());

            return response()->json([
                'success' => true,
                'data' => $event,
                'message' => 'Event created successfully'
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->validator->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create event',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Post(
     *     path="/api/events/{id}/ticket-types",
     *     operationId="addTicketType",
     *     tags={"Events"},
     *     summary="Add ticket type to event (Admin only)",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="Event ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"name","price","total_quantity"},
     *             @OA\Property(property="name", type="string", example="VIP"),
     *             @OA\Property(property="description", type="string", example="VIP access with premium amenities"),
     *             @OA\Property(property="price", type="number", format="float", example=199.99),
     *             @OA\Property(property="total_quantity", type="integer", example=100)
     *         )
     *     ),
     *     @OA\Response(
     *         response=201,
     *         description="Ticket type added successfully"
     *     )
     * )
     */
    public function addTicketType(Request $request, $id)
    {
        try {
            $ticketType = $this->eventService->addTicketType($id, $request->all());

            return response()->json([
                'success' => true,
                'data' => $ticketType,
                'message' => 'Ticket type added successfully'
            ], 201);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Event not found'
            ], 404);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->validator->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to add ticket type',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/events/search",
     *     operationId="searchEvents",
     *     tags={"Events"},
     *     summary="Search events by name",
     *     @OA\Parameter(
     *         name="q",
     *         in="query",
     *         description="Search query (event name)",
     *         required=true,
     *         @OA\Schema(type="string", example="Summer Music")
     *     ),
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="Page number",
     *         required=false,
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Parameter(
     *         name="per_page",
     *         in="query",
     *         description="Items per page (max 50)",
     *         required=false,
     *         @OA\Schema(type="integer", example=10)
     *     ),
     *     @OA\Parameter(
     *         name="location",
     *         in="query",
     *         description="Filter by location",
     *         required=false,
     *         @OA\Schema(type="string", example="New York")
     *     ),
     *     @OA\Parameter(
     *         name="date_from",
     *         in="query",
     *         description="Filter events from this date (Y-m-d)",
     *         required=false,
     *         @OA\Schema(type="string", format="date", example="2025-07-01")
     *     ),
     *     @OA\Parameter(
     *         name="date_to",
     *         in="query",
     *         description="Filter events until this date (Y-m-d)",
     *         required=false,
     *         @OA\Schema(type="string", format="date", example="2025-12-31")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Events found successfully",
     *         @OA\JsonContent(
     *             @OA\Property(property="success", type="boolean", example=true),
     *             @OA\Property(property="message", type="string", example="Events found successfully"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(property="current_page", type="integer"),
     *                 @OA\Property(property="data", type="array", @OA\Items(type="object")),
     *                 @OA\Property(property="total", type="integer"),
     *                 @OA\Property(property="per_page", type="integer"),
     *                 @OA\Property(property="last_page", type="integer")
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Bad request - missing search query"
     *     )
     * )
     */
    public function search(Request $request)
    {
        try {
            $events = $this->eventService->searchEvents($request->all());

            return response()->json([
                'success' => true,
                'message' => 'Events found successfully',
                'data' => $events,
                'search_query' => $request->input('q'),
                'filters_applied' => [
                    'category' => $request->input('category'),
                    'location' => $request->input('location'),
                    'date_from' => $request->input('date_from'),
                    'date_to' => $request->input('date_to'),
                    'on_sale' => $request->input('on_sale'),
                ]
            ], 200);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $e->validator->errors()
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to search events',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/events/search-suggestions",
     *     operationId="getSearchSuggestions",
     *     tags={"Events"},
     *     summary="Get search suggestions for autocomplete",
     *     @OA\Parameter(
     *         name="q",
     *         in="query",
     *         description="Partial search query",
     *         required=true,
     *         @OA\Schema(type="string", example="sum")
     *     ),
     *     @OA\Parameter(
     *         name="limit",
     *         in="query",
     *         description="Maximum number of suggestions",
     *         required=false,
     *         @OA\Schema(type="integer", example=5, maximum=10)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Search suggestions retrieved successfully"
     *     )
     * )
     */
    public function searchSuggestions(Request $request)
    {
        try {
            $searchTerm = $request->input('q');
            $limit = min($request->input('limit', 5), 10);

            if (empty($searchTerm) || strlen($searchTerm) < 1) {
                return response()->json([
                    'success' => false,
                    'message' => 'Search query is required'
                ], 400);
            }

            $suggestions = $this->eventService->getSearchSuggestions($searchTerm, $limit);

            return response()->json([
                'success' => true,
                'message' => 'Search suggestions retrieved successfully',
                'data' => $suggestions,
                'query' => $searchTerm,
                'count' => count($suggestions)
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to get search suggestions',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }
}
