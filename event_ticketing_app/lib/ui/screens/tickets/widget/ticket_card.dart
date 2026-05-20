import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_ticket_app/models/ticket_model.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/widgets/ticket_perforation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;
  final bool isPast;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final event = ticket.event;
    if (event == null) return const SizedBox.shrink();

    final eventDate = DateTime.parse(event.eventDate);
    final formattedDate = DateFormat('EEE, MMM d').format(eventDate);
    final formattedTime = DateFormat('h:mm a').format(eventDate);
    final daysUntil = eventDate.difference(DateTime.now()).inDays;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.r),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isPast
                    ? colorScheme.outlineVariant.withValues(alpha: 0.5)
                    : colorScheme.primary.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                children: [
                  Container(
                    color: isPast
                        ? colorScheme.surfaceContainerHighest
                        : colorScheme.primaryContainer
                            .withValues(alpha: 0.35),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl ?? '',
                            width: 88.w,
                            height: 88.h,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 88.w,
                              height: 88.h,
                              color: appColors.imagePlaceholder,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 88.w,
                              height: 88.h,
                              color: appColors.imagePlaceholder,
                              child: Icon(Icons.event, color: appColors.onImagePlaceholder),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Text(
                                        ticket.ticketType?.name ?? 'Ticket',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w800,
                                          color: colorScheme.primary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (!isPast && daysUntil >= 0)
                                      Text(
                                        daysUntil == 0
                                            ? 'Today'
                                            : 'In $daysUntil d',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                  ],
                                ),
                                verticalSpaceTiny,
                                Text(
                                  event.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                    height: 1.2,
                                  ),
                                ),
                                verticalSpaceTiny,
                                Text(
                                  '$formattedDate · $formattedTime',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const TicketPerforation(),
                  Container(
                    width: double.infinity,
                    color: colorScheme.surfaceContainerLow,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 16.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        horizontalSpaceTiny,
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.qr_code_2,
                          size: 20.sp,
                          color: colorScheme.primary,
                        ),
                        horizontalSpaceTiny,
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
