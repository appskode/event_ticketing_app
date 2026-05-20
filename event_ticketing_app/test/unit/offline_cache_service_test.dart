import 'package:event_ticket_app/services/offline_cache_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('eventsCacheKey encodes filter parameters', () {
    expect(
      OfflineCacheService.eventsCacheKey(category: 'music'),
      'music||',
    );
    expect(
      OfflineCacheService.eventsCacheKey(
        dateFrom: '2026-05-20',
        dateTo: '2026-06-30',
      ),
      '|2026-05-20|2026-06-30',
    );
  });
}
