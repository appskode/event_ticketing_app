import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.confirmation_number_rounded,
                size: 64.sp,
                color: colorScheme.primary,
              ),
            ),
            verticalSpaceMedium,
            Text(
              'Event Tickets',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            verticalSpaceTiny,
            Text(
              'Find your next experience',
              style: TextStyle(
                fontSize: 15.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            verticalSpaceMedium,
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
