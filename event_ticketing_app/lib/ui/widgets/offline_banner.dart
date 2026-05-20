import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global banner shown when the device has no network connection.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineAsync = ref.watch(isOnlineProvider);
    final isOnline = onlineAsync.value ?? true;

    if (isOnline) return const SizedBox.shrink();

    final colorScheme = context.colorScheme;
    final appColors = context.appColors;

    return Material(
      color: appColors.warning.withValues(alpha: 0.15),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(Icons.wifi_off_rounded, size: 18.sp, color: appColors.warning),
            horizontalSpaceSmall,
            Expanded(
              child: Text(
                'You\'re offline — showing saved data where available',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thin strip for list screens when showing cached data while offline.
class CachedDataBanner extends StatelessWidget {
  const CachedDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: colorScheme.primaryContainer.withValues(alpha: 0.35),
      child: Row(
        children: [
          Icon(Icons.cloud_download_outlined,
              size: 16.sp, color: colorScheme.primary),
          horizontalSpaceSmall,
          Expanded(
            child: Text(
              'Showing saved copy — may be out of date',
              style: TextStyle(
                fontSize: 12.sp,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
