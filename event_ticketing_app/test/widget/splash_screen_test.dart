import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SplashScreen shows app title and loading indicator',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: ScreenUtilConfig.designSize,
          builder: (_, __) => MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Event Tickets'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
