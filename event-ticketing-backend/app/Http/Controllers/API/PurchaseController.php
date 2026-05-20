<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Event;
use App\Models\TicketType;
use App\Models\Purchase;
use App\Models\Ticket;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Exceptions\InsufficientStockException;
use App\Exceptions\EventExpiredException;
use App\Services\PurchaseService;


/**
 * @OA\Tag(
 *     name="Purchases",
 *     description="API Endpoints for ticket purchasing"
 * )
 */
class PurchaseController extends Controller
{
    protected $purchaseService;

    public function __construct(PurchaseService $purchaseService)
    {
        $this->purchaseService = $purchaseService;
    }

    /**
     * @OA\Post(
     *     path="/api/purchase",
     *     operationId="purchaseTickets",
     *     tags={"Purchases"},
     *     summary="Purchase tickets for an event",
     *     security={{"bearerAuth":{}}},
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             required={"event_id","tickets"},
     *             @OA\Property(property="event_id", type="integer", example=1),
     *             @OA\Property(
     *                 property="tickets",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     required={"ticket_type_id","quantity"},
     *                     @OA\Property(property="ticket_type_id", type="integer", example=1),
     *                     @OA\Property(property="quantity", type="integer", example=2)
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=201,
     *         description="Tickets purchased successfully"
     *     )
     * )
     */
    public function purchase(Request $request)
    {
        try {
            $userId = auth('api')->id();
            $result = $this->purchaseService->purchaseTickets($request->all(), $userId);

            return response()->json([
                'success' => true,
                'data' => $result,
                'payment_simulated' => true,
                'message' => 'Tickets purchased successfully (payment simulated)',
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $e->validator->errors()
            ], 422);
        } catch (InsufficientStockException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Insufficient stock',
                'error' => $e->getMessage()
            ], 400);
        } catch (\InvalidArgumentException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Purchase failed',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/purchases",
     *     operationId="getPurchases",
     *     tags={"Purchases"},
     *     summary="Get user's purchase history",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="Page number",
     *         required=false,
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Purchases retrieved successfully"
     *     )
     * )
     */
    public function index(Request $request)
    {
        try {
            $userId = auth('api')->id();
            $perPage = $request->get('per_page', 10);

            $purchases = $this->purchaseService->getUserPurchases($userId, $perPage);

            return response()->json([
                'success' => true,
                'data' => $purchases,
                'message' => 'Purchases retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve purchases',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * @OA\Get(
     *     path="/api/purchases/{id}",
     *     operationId="getPurchase",
     *     tags={"Purchases"},
     *     summary="Get single purchase details",
     *     security={{"bearerAuth":{}}},
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         description="Purchase ID",
     *         required=true,
     *         @OA\Schema(type="integer")
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Purchase retrieved successfully"
     *     )
     * )
     */
    public function show($id)
    {
        try {
            $userId = auth('api')->id();
            $purchase = $this->purchaseService->getPurchase($id, $userId);

            return response()->json([
                'success' => true,
                'data' => $purchase,
                'message' => 'Purchase retrieved successfully'
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Purchase not found'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve purchase',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }
}
