import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventDetailProvider = FutureProvider.family<Event, int>((
  ref,
  eventId,
) async {
  final cache = ref.watch(offlineCacheServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final eventService = ref.watch(eventServiceProvider);

  final online = await connectivity.isOnline;

  if (!online) {
    final cached = await cache.getEventDetail(eventId);
    if (cached != null) return cached;
    throw Exception(
      'You\'re offline and this event isn\'t cached. Open it once while online.',
    );
  }

  try {
    final response = await eventService.getEvent(eventId);
    final event = Event.fromJson(response['data']);
    await cache.saveEventDetail(event);
    return event;
  } catch (e) {
    if (isNetworkError(e)) {
      final cached = await cache.getEventDetail(eventId);
      if (cached != null) return cached;
    }
    rethrow;
  }
});
