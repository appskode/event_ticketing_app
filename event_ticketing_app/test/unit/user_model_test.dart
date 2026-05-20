import 'package:event_ticket_app/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('isAdmin is true when role is admin', () {
      const user = User(
        id: 1,
        name: 'Admin',
        email: 'admin@test.com',
        createdAt: '2025-01-01',
        updatedAt: '2025-01-01',
        role: UserRole.admin,
      );

      expect(user.isAdmin, isTrue);
    });

    test('isAdmin is false for regular users', () {
      const user = User(
        id: 2,
        name: 'User',
        email: 'user@test.com',
        createdAt: '2025-01-01',
        updatedAt: '2025-01-01',
        role: UserRole.user,
      );

      expect(user.isAdmin, isFalse);
    });
  });
}
