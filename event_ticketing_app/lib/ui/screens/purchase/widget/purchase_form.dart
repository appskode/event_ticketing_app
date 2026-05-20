import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/screens/purchase/widget/order_summary.dart';
import 'package:event_ticket_app/ui/screens/purchase/widget/ticket_selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseForm extends StatelessWidget {
  final Event event;
  final double total;
  final Map<int, int> ticketQuantities;
  final bool isLoading;
  final VoidCallback? onPurchase;
  final VoidCallback Function(TicketType) onIncrement;
  final VoidCallback Function(TicketType) onDecrement;

  const PurchaseForm({
    super.key,
    required this.event,
    required this.total,
    required this.ticketQuantities,
    required this.isLoading,
    this.onPurchase,
    required this.onIncrement,
    required this.onDecrement,
  });

  int get _selectedCount =>
      ticketQuantities.values.fold(0, (sum, q) => sum + q);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final eventDate = DateTime.parse(event.eventDate);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CheckoutSteps(currentStep: 1),
                verticalSpaceMedium,
                _EventHeader(
                  event: event,
                  eventDate: eventDate,
                  appColors: appColors,
                ),
                verticalSpaceMedium,
                Text(
                  'How many tickets?',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                verticalSpaceTiny,
                Text(
                  'Max 10 per type · payment is simulated',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                verticalSpaceSmall,
                ...event.ticketTypes.map(
                  (ticketType) => TicketSelector(
                    ticketType: ticketType,
                    quantity: ticketQuantities[ticketType.id] ?? 0,
                    onIncrement: onIncrement(ticketType),
                    onDecrement: onDecrement(ticketType),
                  ),
                ),
                verticalSpaceMedium,
                OrderSummary(
                  ticketTypes: event.ticketTypes,
                  ticketQuantities: ticketQuantities,
                  total: total,
                ),
              ],
            ),
          ),
        ),
        _CheckoutBar(
          total: total,
          itemCount: _selectedCount,
          isLoading: isLoading,
          onPurchase: _selectedCount > 0 && !isLoading ? onPurchase : null,
        ),
      ],
    );
  }
}

class _CheckoutSteps extends StatelessWidget {
  const _CheckoutSteps({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      children: [
        _StepDot(
          label: 'Select',
          active: currentStep >= 1,
          colorScheme: colorScheme,
        ),
        Expanded(
          child: Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            color: currentStep >= 2
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
        ),
        _StepDot(
          label: 'Pay',
          active: currentStep >= 2,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.active,
    required this.colorScheme,
  });

  final String label;
  final bool active;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: active ? colorScheme.primary : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            active ? Icons.check : Icons.circle_outlined,
            size: 16.sp,
            color: active ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
        verticalSpaceTiny,
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: active ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({
    required this.event,
    required this.eventDate,
    required this.appColors,
  });

  final Event event;
  final DateTime eventDate;
  final AppColorsExtension appColors;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: event.imageUrl ?? '',
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 72.w,
                height: 72.w,
                color: appColors.imagePlaceholder,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 72.w,
                height: 72.w,
                color: appColors.imagePlaceholder,
                child: Icon(Icons.event),
              ),
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                verticalSpaceTiny,
                Text(
                  DateFormat('EEE, MMM d · h:mm a').format(eventDate),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.total,
    required this.itemCount,
    required this.isLoading,
    this.onPurchase,
  });

  final double total;
  final int itemCount;
  final bool isLoading;
  final VoidCallback? onPurchase;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

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
                      '\$${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      itemCount == 0
                          ? 'Nothing selected'
                          : '$itemCount ticket${itemCount == 1 ? '' : 's'}',
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
                onPressed: onPurchase,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Complete purchase',
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
