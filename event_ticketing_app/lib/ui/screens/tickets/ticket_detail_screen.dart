import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:event_ticket_app/providers/ticket_detail_provider.dart';
import 'package:event_ticket_app/providers/tickets_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/dialogs/app_dialogs.dart';
import 'package:event_ticket_app/ui/widgets/ticket_perforation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetailScreen extends ConsumerWidget {
  final int ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketDetailProvider(ticketId));
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: ticketAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, ref, error),
        data: (ticket) => _buildTicketDetail(context, ref, ticket),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: context.pop,
              icon: const Icon(Icons.close),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('$error', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetail(
    BuildContext context,
    WidgetRef ref,
    Ticket ticket,
  ) {
    final event = ticket.event;
    if (event == null) {
      return const Center(child: Text('Event information not available'));
    }

    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final eventDate = DateTime.parse(event.eventDate);
    final formattedDate = DateFormat('EEEE, MMM d').format(eventDate);
    final formattedTime = DateFormat('h:mm a').format(eventDate);

    final (statusColor, statusText, statusIcon) = switch (ticket.status) {
      'active' => (appColors.success, 'Valid for entry', Icons.verified_outlined),
      'used' => (appColors.info, 'Already used', Icons.check_circle_outline),
      'cancelled' => (colorScheme.error, 'Cancelled', Icons.cancel_outlined),
      _ => (colorScheme.outline, ticket.status ?? 'Unknown', Icons.help_outline),
    };

    final canCancel = ticket.status == 'active' &&
        event.allowCancellation &&
        eventDate.isAfter(
          DateTime.now().add(
            Duration(hours: event.cancellationHoursBefore ?? 24),
          ),
        );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.all(8.w),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.95),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: context.pop,
                icon: Icon(Icons.close, size: 20.sp),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => ref.refresh(ticketDetailProvider(ticketId)),
              icon: Icon(Icons.refresh, size: 22.sp),
            ),
            SizedBox(width: 4.w),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 56.w, bottom: 14.h),
            title: Text(
              'Your ticket',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _StatusBanner(
                color: statusColor,
                text: statusText,
                icon: statusIcon,
              ),
              verticalSpaceSmall,
              _WalletTicket(
                eventName: event.name,
                ticketType: ticket.ticketType?.name ?? 'General',
                formattedDate: formattedDate,
                formattedTime: formattedTime,
                location: event.location,
                price: ticket.ticketType?.price,
                ticketNumber: ticket.ticketNumber,
              ),
              if (ticket.status == 'active') ...[
                verticalSpaceMedium,
                _QrSection(
                  ticketNumber: ticket.ticketNumber ?? '',
                ),
              ],
              verticalSpaceMedium,
              _DetailsPanel(
                ticket: ticket,
              ),
              if (canCancel) ...[
                verticalSpaceMedium,
                OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(context, ref, ticket),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel ticket'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, Ticket ticket) {
    CustomDialogs.showConfirmationDialog(
      context: context,
      title: 'Cancel Ticket',
      message:
          'Are you sure you want to cancel this ticket? This action cannot be undone.',
      cancelText: 'Keep Ticket',
      confirmText: 'Cancel Ticket',
      onConfirm: () async {
        Navigator.of(context).pop();
        final success =
            await ref.read(ticketsProvider.notifier).cancelTicket(ticket.id);
        if (success && context.mounted) {
          ref.invalidate(ticketDetailProvider(ticket.id));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ticket cancelled successfully')),
          );
        } else if (!success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to cancel ticket')),
          );
        }
      },
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.color,
    required this.text,
    required this.icon,
  });

  final Color color;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22.sp),
          horizontalSpaceSmall,
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletTicket extends StatelessWidget {
  const _WalletTicket({
    required this.eventName,
    required this.ticketType,
    required this.formattedDate,
    required this.formattedTime,
    required this.location,
    this.price,
    this.ticketNumber,
  });

  final String eventName;
  final String ticketType;
  final String formattedDate;
  final String formattedTime;
  final String location;
  final double? price;
  final String? ticketNumber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            Color.lerp(colorScheme.primary, colorScheme.primaryContainer, 0.5)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticketType.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: colorScheme.onPrimary.withValues(alpha: 0.75),
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    eventName,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimary,
                      height: 1.15,
                    ),
                  ),
                  verticalSpaceMedium,
                  Row(
                    children: [
                      _TicketFact(
                        label: 'Date',
                        value: formattedDate,
                        onPrimary: colorScheme.onPrimary,
                      ),
                      _TicketFact(
                        label: 'Time',
                        value: formattedTime,
                        onPrimary: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TicketPerforation(),
            Container(
              width: double.infinity,
              color: colorScheme.onPrimary.withValues(alpha: 0.12),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VENUE',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: colorScheme.onPrimary.withValues(alpha: 0.65),
                    ),
                  ),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  if (price != null) ...[
                    verticalSpaceSmall,
                    Text(
                      'Paid \$${price!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                  if (ticketNumber != null) ...[
                    verticalSpaceTiny,
                    Text(
                      '#$ticketNumber',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'monospace',
                        color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketFact extends StatelessWidget {
  const _TicketFact({
    required this.label,
    required this.value,
    required this.onPrimary,
  });

  final String label;
  final String value;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: onPrimary.withValues(alpha: 0.65),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: onPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection({required this.ticketNumber});

  final String ticketNumber;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text(
            'Scan at the door',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          verticalSpaceTiny,
          Text(
            'Brightness up · hold steady',
            style: TextStyle(
              fontSize: 13.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          verticalSpaceMedium,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: QrImageView(
              data: ticketNumber,
              version: QrVersions.auto,
              size: 200.w,
              backgroundColor: Colors.white,
            ),
          ),
          verticalSpaceSmall,
          SelectableText(
            ticketNumber,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  const _DetailsPanel({required this.ticket});

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          verticalSpaceSmall,
          if (ticket.createdAt != null)
            _DetailRow(
              label: 'Purchased',
              value: DateFormat('MMM d, yyyy')
                  .format(DateTime.parse(ticket.createdAt!)),
            ),
          if (ticket.usedAt != null)
            _DetailRow(
              label: 'Used',
              value: DateFormat('MMM d, yyyy · h:mm a')
                  .format(DateTime.parse(ticket.usedAt!)),
            ),
          if (ticket.cancelledAt != null)
            _DetailRow(
              label: 'Cancelled',
              value: DateFormat('MMM d, yyyy · h:mm a')
                  .format(DateTime.parse(ticket.cancelledAt!)),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
