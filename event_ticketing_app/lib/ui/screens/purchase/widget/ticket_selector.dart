import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class TicketSelector extends StatelessWidget {
  final TicketType ticketType;
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const TicketSelector({
    super.key,
    required this.ticketType,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final available = ticketType.availableQuantity > 0;
    final isSelected = quantity > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.35)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  '\$',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            horizontalSpaceSmall,
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
                  Text(
                    '\$${ticketType.price.toStringAsFixed(2)} each',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (!available)
                    Text(
                      'Sold out',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            if (available)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: quantity > 0 ? onDecrement : null,
                    ),
                    Container(
                      width: 36.w,
                      alignment: Alignment.center,
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    _QtyButton(icon: Icons.add, onTap: onIncrement),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final enabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Icon(
            icon,
            size: 20.sp,
            color: enabled
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}
