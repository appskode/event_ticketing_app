import 'package:event_ticket_app/services/connectivity_service.dart';
import 'package:event_ticket_app/services/offline_cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// `true` when the device has a network interface; defaults to true until first check.
final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onlineStream;
});

final offlineCacheServiceProvider = Provider<OfflineCacheService>((ref) {
  return OfflineCacheService();
});
