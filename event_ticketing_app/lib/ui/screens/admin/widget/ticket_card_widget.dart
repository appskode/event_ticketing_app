import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class TicketTypeCardWidget extends StatelessWidget {
  final Map<String, dynamic> ticketType;
  final int index;
  final VoidCallback onRemove;

  const TicketTypeCardWidget({
    super.key,
    required this.ticketType,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(SMALL_PADDING.w + 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticketType['name'] ?? 'Unnamed Ticket',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete,
                    color: colorScheme.error,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
            if (ticketType['description']?.isNotEmpty == true) ...[
              verticalSpaceTiny,
              Text(
                ticketType['description'],
                style: TextStyle(
                  fontSize: 16.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            verticalSpaceTiny,
            Row(
              children: [
                Text(
                  'Price: \$${ticketType['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: colorScheme.onSurface,
                  ),
                ),
                horizontalSpaceMedium,
                Text(
                  'Quantity: ${ticketType['quantity'] ?? 0}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
