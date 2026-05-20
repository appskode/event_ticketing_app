import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

/// Shown when a list failed to load and has no cached items to display.
class ListErrorView extends StatelessWidget {
  const ListErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      children: [
        SizedBox(height: screenHeight(context) * 0.22),
        Icon(Icons.cloud_off_outlined, size: 64.sp, color: colorScheme.error),
        verticalSpaceSmall,
        Text(
          'Something went wrong',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        verticalSpaceTiny,
        Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        verticalSpaceSmall,
        Center(
          child: FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ),
      ],
    );
  }
}
