import 'package:event_ticket_app/models/event_category.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:event_ticket_app/services/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventCategoriesProvider =
    FutureProvider.autoDispose<List<EventCategory>>((ref) async {
  final cache = ref.watch(offlineCacheServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final eventService = ref.watch(eventServiceProvider);

  final online = await connectivity.isOnline;
  if (!online) {
    return await cache.getCategories() ?? [];
  }

  try {
    final data = await eventService.getCategories();
    final categories = data
        .map((e) => EventCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    await cache.saveCategories(categories);
    return categories;
  } catch (e) {
    if (isNetworkError(e)) {
      return await cache.getCategories() ?? [];
    }
    rethrow;
  }
});
