import 'package:event_ticket_app/services/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseRefreshToken', () {
    test('returns token from refresh response map', () {
      expect(
        parseRefreshToken({'success': true, 'token': 'jwt-token'}),
        'jwt-token',
      );
    });

    test('returns null when token key is missing', () {
      expect(parseRefreshToken({'success': true}), isNull);
    });

    test('returns null for non-map data', () {
      expect(parseRefreshToken('invalid'), isNull);
      expect(parseRefreshToken(null), isNull);
    });
  });
}
