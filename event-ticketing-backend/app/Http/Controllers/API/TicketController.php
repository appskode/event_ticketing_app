<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ticket;
use App\Services\TicketService;
use App\Exceptions\TicketCancellationException;

/**
 * @OA\Tag(
 *     name="Tickets",
 *     description="API Endpoints for ticket management"
 * )
 */
class TicketController extends Controller
{
    protected $ticketService;

    public function __construct(TicketService $ticketService)
    {
        $this->ticketService = $ticketService;
    }

    /**
     * @OA\Get(
     *     path="/api/my-tickets",
     *     operationId="getMyTickets",
     *     tags={"Tickets"},
     *     summary="Get current user's tickets",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="Page number",
     *         required=false,
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Parameter(
     *         name="status",
     *         in="query",
     *         description="Filter by ticket status",
     *         required=false,
     *         @OA\Schema(type="string", enum={"active", "used", "cancelled"})
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Tickets retrieved successfully"
     *     )
     * )
     */
    public function myTickets(Request $request)
    {
        try {
            $userId = auth('api')->id();
            $status = $request->input('status');
            $perPage = $request->get('per_page', 10);

            $tickets = $this->ticketService->getUserTickets($userId, $status, $perPage);

            return response()->json([
                'success' => true,
                'data' => $tickets,
                'message' => 'Tickets retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve tickets',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/tickets/{id}",
     *     operationId="getTicket",
     *     tags={"Tickets"},
     *     summary="Get single ticket details",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="Ticket ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Ticket retrieved successfully"
     *     )
     * )
     */
    public function show($id)
    {
        try {
            $userId = auth('api')->id();
            $ticketData = $this->ticketService->getTicket($id, $userId);

            return response()->json([
                'success' => true,
                'data' => $ticketData,
                'message' => 'Ticket retrieved successfully'
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Ticket not found'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve ticket',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Post(
     *     path="/api/tickets/{id}/cancel",
     *     operationId="cancelTicket",
     *     tags={"Tickets"},
     *     summary="Cancel a ticket",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="Ticket ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Ticket cancelled successfully"
     *     )
     * )
     */
    public function cancel($id)
    {
         try {
            $userId = auth('api')->id();
            $cancelled = $this->ticketService->cancelTicket($id, $userId);

            if ($cancelled) {
                return response()->json([
                    'success' => true,
                    'message' => 'Ticket cancelled successfully'
                ]);
            } else {
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to cancel ticket'
                ], 400);
            }
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Ticket not found'
            ], 404);
        } catch (TicketCancellationException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to cancel ticket',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }
}
