<?php

namespace App\Services;

use App\Models\Event;
use App\Models\TicketType;
use App\Models\Purchase;
use App\Models\Ticket;
use Illuminate\Support\Facades\DB;
use App\Exceptions\InsufficientStockException;

class PurchaseService extends BaseService
{
    /**
     * Purchase tickets. Payment is simulated — no gateway is called;
     * purchases are marked completed immediately after stock validation.
     */
    public function purchaseTickets(array $data, int $userId): array
    {
        try {
            $validatedData = $this->validate($data, [
                'event_id' => 'required|exists:events,id',
                'tickets' => 'required|array|min:1',
                'tickets.*.ticket_type_id' => 'required|exists:ticket_types,id',
                'tickets.*.quantity' => 'required|integer|min:1|max:10',
            ]);

            $event = Event::find($validatedData['event_id']);

            if (!$event->is_sale_active) {
                throw new \InvalidArgumentException('Ticket sales are not active for this event');
            }

            return DB::transaction(function () use ($validatedData, $event, $userId) {
                $totalAmount = 0;
                $purchaseDetails = [];
                $ticketsToCreate = [];

                // Validate and reserve tickets
                foreach ($validatedData['tickets'] as $ticketRequest) {
                    $ticketType = TicketType::lockForUpdate()->find($ticketRequest['ticket_type_id']);

                    if (!$ticketType || $ticketType->event_id !== $event->id) {
                        throw new \InvalidArgumentException('Invalid ticket type for this event');
                    }

                    if (!$ticketType->is_active) {
                        throw new \InvalidArgumentException("Ticket type '{$ticketType->name}' is not available");
                    }

                    if ($ticketType->available_quantity < $ticketRequest['quantity']) {
                        throw new InsufficientStockException(
                            $ticketType->name,
                            $ticketType->available_quantity,
                            $ticketRequest['quantity']
                        );
                    }

                    // Reserve tickets
                    $ticketType->decrement('available_quantity', $ticketRequest['quantity']);

                    $subtotal = $ticketType->price * $ticketRequest['quantity'];
                    $totalAmount += $subtotal;

                    $purchaseDetails[] = [
                        'ticket_type_id' => $ticketType->id,
                        'ticket_type_name' => $ticketType->name,
                        'quantity' => $ticketRequest['quantity'],
                        'unit_price' => $ticketType->price,
                        'subtotal' => $subtotal
                    ];

                    // Prepare tickets for creation
                    for ($i = 0; $i < $ticketRequest['quantity']; $i++) {
                        $ticketsToCreate[] = [
                            'user_id' => $userId,
                            'event_id' => $event->id,
                            'ticket_type_id' => $ticketType->id,
                            'price_paid' => $ticketType->price,
                        ];
                    }
                }

                // Create purchase record
                $purchase = Purchase::create([
                    'user_id' => $userId,
                    'total_amount' => $totalAmount,
                    'status' => 'completed',
                    'purchase_details' => $purchaseDetails,
                ]);

                // Create individual tickets linked to this purchase
                $createdTickets = [];
                foreach ($ticketsToCreate as $ticketData) {
                    $createdTickets[] = Ticket::create([
                        ...$ticketData,
                        'purchase_id' => $purchase->id,
                    ]);
                }

                return [
                    'purchase' => $purchase,
                    'tickets' => $createdTickets,
                    'total_tickets' => count($createdTickets),
                    'payment_simulated' => true,
                ];
            });
        } catch (\Exception $e) {
            $this->handleException($e, 'Purchase Tickets');
            throw $e;
        }
    }

    /**
     * Get user purchases
     */
    public function getUserPurchases(int $userId, int $perPage = 10)
    {
        try {
            return Purchase::where('user_id', $userId)
                ->orderBy('created_at', 'desc')
                ->paginate($perPage);
        } catch (\Exception $e) {
            $this->handleException($e, 'Get User Purchases');
            throw $e;
        }
    }

    /**
     * Get single purchase
     */
    public function getPurchase(int $purchaseId, int $userId): Purchase
    {
        try {
            $purchase = Purchase::with(['tickets.event', 'tickets.ticketType'])
                ->where('user_id', $userId)
                ->find($purchaseId);

            if (!$purchase) {
                throw new \Illuminate\Database\Eloquent\ModelNotFoundException('Purchase not found');
            }

            return $purchase;
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Purchase');
            throw $e;
        }
    }
}
