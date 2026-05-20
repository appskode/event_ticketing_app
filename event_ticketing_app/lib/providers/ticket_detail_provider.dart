import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ticketDetailProvider =
    FutureProvider.family<Ticket, int>((ref, ticketId) async {
  final cache = ref.watch(offlineCacheServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final ticketService = ref.watch(ticketServiceProvider);

  final online = await connectivity.isOnline;

  if (!online) {
    final cached = await cache.getTicketDetail(ticketId);
    if (cached != null) return cached;
    throw Exception(
      'You\'re offline and this ticket isn\'t cached. Open it once while online.',
    );
  }

  try {
    final response = await ticketService.getTicket(ticketId);
    final ticket = Ticket.fromJson(response['data']['ticket']);
    await cache.saveTicketDetail(ticket);
    return ticket;
  } catch (e) {
    if (isNetworkError(e)) {
      final cached = await cache.getTicketDetail(ticketId);
      if (cached != null) return cached;
    }
    rethrow;
  }
});
