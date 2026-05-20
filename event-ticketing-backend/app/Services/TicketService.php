<?php

namespace App\Services;

use App\Models\Ticket;
use App\Exceptions\TicketCancellationException;

class TicketService extends BaseService
{
    /**
     * Get user tickets
     */
    public function getUserTickets(int $userId, ?string $status = null, int $perPage = 10)
    {
        try {
            $query = Ticket::where('user_id', $userId)
                ->with(['event', 'ticketType', 'purchase'])
                ->orderBy('purchased_at', 'desc');

            if ($status) {
                $query->where('status', $status);
            }

            return $query->paginate($perPage);
        } catch (\Exception $e) {
            $this->handleException($e, 'Get User Tickets');
            throw $e;
        }
    }

    /**
     * Get single ticket
     */
    public function getTicket(int $ticketId, int $userId): array
    {
        try {
            $ticket = Ticket::with(['event', 'ticketType', 'purchase'])
                ->where('user_id', $userId)
                ->find($ticketId);

            if (!$ticket) {
                throw new \Illuminate\Database\Eloquent\ModelNotFoundException('Ticket not found');
            }

            return [
                'ticket' => $ticket,
                'qr_data' => $ticket->ticket_code,
                'can_cancel' => $ticket->canBeCancelled()
            ];
        } catch (\Exception $e) {
            $this->handleException($e, 'Get Ticket');
            throw $e;
        }
    }

    /**
     * Cancel ticket
     */
    public function cancelTicket(int $ticketId, int $userId): bool
    {
        try {
            $ticket = Ticket::where('user_id', $userId)->find($ticketId);

            if (!$ticket) {
                throw new \Illuminate\Database\Eloquent\ModelNotFoundException('Ticket not found');
            }

            if (!$ticket->canBeCancelled()) {
                if ($ticket->status !== 'active') {
                    throw new TicketCancellationException("Ticket is already {$ticket->status}");
                }

                if (!$ticket->event->allow_cancellation) {
                    throw new TicketCancellationException('This event does not allow cancellations');
                }

                if (!$ticket->event->can_be_cancelled) {
                    $hoursLeft = now()->diffInHours($ticket->event->event_date->subHours($ticket->event->cancellation_hours_before));
                    throw new TicketCancellationException("Cancellation deadline has passed. You needed to cancel at least {$ticket->event->cancellation_hours_before} hours before the event");
                }
            }

            return $ticket->cancel();
        } catch (\Exception $e) {
            $this->handleException($e, 'Cancel Ticket');
            throw $e;
        }
    }
}
