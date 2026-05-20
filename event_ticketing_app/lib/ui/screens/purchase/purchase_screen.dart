import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/providers/events_provider.dart';
import 'package:event_ticket_app/providers/event_detail_provider.dart';
import 'package:event_ticket_app/providers/tickets_provider.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/dialogs/app_dialogs.dart';
import 'package:event_ticket_app/ui/screens/purchase/widget/purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PurchaseScreen extends ConsumerStatefulWidget {
  final int eventId;

  const PurchaseScreen({super.key, required this.eventId});

  @override
  ConsumerState<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen> {
  final Map<int, int> _ticketQuantities = {};
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.eventId));
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, error),
        data: (event) => PurchaseForm(
          event: event,
          total: _calculateTotal(event.ticketTypes),
          ticketQuantities: _ticketQuantities,
          isLoading: _isLoading,
          onPurchase: () => _purchaseTickets(event),
          onIncrement: (ticketType) => ticketType.availableQuantity >
                      (_ticketQuantities[ticketType.id] ?? 0) &&
                  (_ticketQuantities[ticketType.id] ?? 0) < 10
              ? () => setState(() {
                    _ticketQuantities[ticketType.id] =
                        (_ticketQuantities[ticketType.id] ?? 0) + 1;
                  })
              : () {},
          onDecrement: (ticketType) =>
              (_ticketQuantities[ticketType.id] ?? 0) > 0
                  ? () => setState(() {
                        _ticketQuantities[ticketType.id] =
                            (_ticketQuantities[ticketType.id] ?? 0) - 1;
                        if (_ticketQuantities[ticketType.id] == 0) {
                          _ticketQuantities.remove(ticketType.id);
                        }
                      })
                  : () {},
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final colorScheme = context.colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56.sp, color: colorScheme.error),
            verticalSpaceSmall,
            Text('$error', textAlign: TextAlign.center),
            verticalSpaceSmall,
            FilledButton(
              onPressed: () =>
                  ref.refresh(eventDetailProvider(widget.eventId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal(List<TicketType> ticketTypes) {
    double total = 0;
    for (final ticketType in ticketTypes) {
      final quantity = _ticketQuantities[ticketType.id] ?? 0;
      total += ticketType.price * quantity;
    }
    return total;
  }

  Future<void> _purchaseTickets(Event event) async {
    if (!event.isSaleActive) {
      _showErrorDialog('Ticket sales are not active for this event.');
      return;
    }

    final online = ref.read(isOnlineProvider).value ?? true;
    if (!online) {
      _showErrorDialog(
        'You\'re offline. Connect to the internet to complete a purchase.',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final tickets = <Map<String, dynamic>>[];
      for (final entry in _ticketQuantities.entries) {
        if (entry.value > 0) {
          tickets.add({'ticket_type_id': entry.key, 'quantity': entry.value});
        }
      }

      if (tickets.isEmpty) {
        _showErrorDialog('Select at least one ticket.');
        return;
      }

      await ref
          .read(purchaseServiceProvider)
          .purchaseTickets(widget.eventId, tickets);

      ref.read(ticketsProvider.notifier).loadTickets(refresh: true);
      ref.read(eventsProvider.notifier).loadEvents(refresh: true);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(userFacingError(e));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    CustomDialogs.showSuccessDialog(
      context: context,
      title: 'You\'re all set!',
      message:
          'Your tickets are ready. Show the QR code at the venue entrance.',
      buttonText: 'View my tickets',
      navigateTo: '/home?tab=1',
    );
  }

  void _showErrorDialog(String error) {
    CustomDialogs.showErrorDialog(
      context: context,
      title: 'Purchase failed',
      message: error,
      buttonText: 'OK',
    );
  }
}
