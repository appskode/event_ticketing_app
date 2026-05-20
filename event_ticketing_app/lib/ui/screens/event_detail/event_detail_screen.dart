import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/providers/connectivity_provider.dart';
import 'package:event_ticket_app/providers/event_detail_provider.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/widgets/event_hero_image.dart';
import 'package:event_ticket_app/ui/widgets/meta_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends ConsumerWidget {
  final int eventId;
  final Event? previewEvent;

  const EventDetailScreen({
    super.key,
    required this.eventId,
    this.previewEvent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    return eventAsync.when(
      loading: () {
        if (previewEvent != null) {
          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            body: _EventDetailScroll(event: previewEvent!, isOnline: isOnline),
            bottomNavigationBar:
                _BottomCheckoutBar(event: previewEvent!, isOnline: isOnline),
          );
        }
        return Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: _buildError(context, ref, error),
      ),
      data: (event) => Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: _EventDetailScroll(event: event, isOnline: isOnline),
        bottomNavigationBar: _BottomCheckoutBar(event: event, isOnline: isOnline),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final colorScheme = context.colorScheme;
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: context.pop,
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 56.sp, color: colorScheme.error),
                    verticalSpaceSmall,
                    Text(
                      '$error',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    verticalSpaceSmall,
                    FilledButton(
                      onPressed: () =>
                          ref.refresh(eventDetailProvider(eventId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetailScroll extends StatelessWidget {
  const _EventDetailScroll({
    required this.event,
    required this.isOnline,
  });

  final Event event;
  final bool isOnline;

  String _formatCategory(String key) =>
      key.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final eventDate = DateTime.parse(event.eventDate);
    final dateStr = DateFormat('EEE, MMM d').format(eventDate);
    final timeStr = DateFormat('h:mm a').format(eventDate);
    final availableTypes =
        event.ticketTypes.where((t) => t.availableQuantity > 0).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300.h,
          pinned: true,
          stretch: true,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.all(8.w),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: context.pop,
                icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            background: Stack(
              fit: StackFit.expand,
              children: [
                EventHeroImage(
                  eventId: event.id,
                  imageUrl: event.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: 36.h,
                  child: Text(
                    event.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.15,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Colors.black45),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: verticalSpaceSmall,
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -28.h),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _formatCategory(event.category),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    verticalSpaceSmall,
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        MetaChip(
                          icon: Icons.calendar_month_outlined,
                          label: dateStr,
                        ),
                        MetaChip(
                          icon: Icons.schedule_outlined,
                          label: timeStr,
                        ),
                      ],
                    ),
                    verticalSpaceSmall,
                    MetaChip(
                      icon: Icons.place_outlined,
                      label: event.location,
                      expanded: true,
                    ),
                    verticalSpaceMedium,
                    _SectionTitle(
                      icon: Icons.info_outline,
                      title: 'About this event',
                    ),
                    verticalSpaceTiny,
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.55,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    verticalSpaceMedium,
                    _SectionTitle(
                      icon: Icons.confirmation_number_outlined,
                      title: 'Choose your ticket',
                    ),
                    verticalSpaceSmall,
                    if (event.ticketTypes.isEmpty)
                      Text(
                        'No ticket types available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      ...event.ticketTypes.map(
                        (t) => _TicketTierCard(ticketType: t),
                      ),
                    if (availableTypes.isEmpty && event.ticketTypes.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'All ticket types are currently sold out.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colorScheme.primary),
        horizontalSpaceSmall,
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _TicketTierCard extends StatelessWidget {
  const _TicketTierCard({required this.ticketType});

  final TicketType ticketType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final available = ticketType.availableQuantity;
    final isAvailable = available > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isAvailable
              ? colorScheme.primary.withValues(alpha: 0.25)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5.w,
              decoration: BoxDecoration(
                color: isAvailable ? colorScheme.primary : colorScheme.outline,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticketType.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          verticalSpaceTiny,
                          Text(
                            'per ticket',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${ticketType.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                          ),
                        ),
                        verticalSpaceTiny,
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: (isAvailable
                                    ? appColors.success
                                    : colorScheme.error)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            isAvailable ? '$available left' : 'Sold out',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: isAvailable
                                  ? appColors.success
                                  : colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomCheckoutBar extends StatelessWidget {
  const _BottomCheckoutBar({
    required this.event,
    required this.isOnline,
  });

  final Event event;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final available = event.ticketTypes
        .where((t) => t.availableQuantity > 0)
        .toList();
    final minPrice = available.isEmpty
        ? null
        : available.map((t) => t.price).reduce((a, b) => a < b ? a : b);
    final canBuy =
        available.isNotEmpty && isOnline && event.isSaleActive;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      minPrice != null
                          ? 'From \$${minPrice.toStringAsFixed(2)}'
                          : 'Sold out',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      !event.isSaleActive
                          ? 'Ticket sales are not open'
                          : isOnline
                              ? '${available.length} tier${available.length == 1 ? '' : 's'} available'
                              : 'Connect to purchase',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpaceSmall,
              FilledButton(
                onPressed: canBuy
                    ? () => context.push('/purchase/${event.id}')
                    : !isOnline && available.isNotEmpty
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Purchases require an internet connection.',
                                ),
                              ),
                            );
                          }
                        : null,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  canBuy
                      ? 'Get tickets'
                      : !event.isSaleActive
                          ? 'Sales closed'
                          : isOnline
                              ? 'Sold out'
                          : 'Offline',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
