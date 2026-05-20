import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final List<TicketType> ticketTypes;
  final Map<int, int> ticketQuantities;
  final double total;

  const OrderSummary({
    super.key,
    required this.ticketTypes,
    required this.ticketQuantities,
    required this.total,
  });

  int get _itemCount =>
      ticketQuantities.values.fold(0, (sum, q) => sum + q);

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final hasItems = _itemCount > 0;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: hasItems
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 20.sp, color: colorScheme.primary),
              horizontalSpaceSmall,
              Text(
                'Order summary',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          verticalSpaceSmall,
          if (!hasItems)
            Text(
              'Select at least one ticket to continue',
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else ...[
            ...ticketTypes.map((ticketType) {
              final quantity = ticketQuantities[ticketType.id] ?? 0;
              if (quantity <= 0) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 28.w,
                      height: 28.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$quantity×',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    horizontalSpaceSmall,
                    Expanded(
                      child: Text(
                        ticketType.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      '\$${(ticketType.price * quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }),
            Divider(height: 24.h, color: colorScheme.outlineVariant),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ($_itemCount ticket${_itemCount == 1 ? '' : 's'})',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
