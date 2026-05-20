import 'package:event_ticket_app/models/event_model.dart';
import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:event_ticket_app/ui/widgets/app_surface_card.dart';
import 'package:event_ticket_app/ui/widgets/event_hero_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final String? categoryLabel;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final eventDate = DateTime.parse(event.eventDate);
    final formattedDate = DateFormat('EEE, MMM d • h:mm a').format(eventDate);

    return AppSurfaceCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventHeroImage(
            eventId: event.id,
            imageUrl: event.imageUrl,
            width: double.infinity,
            height: 148.h,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (categoryLabel != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        categoryLabel!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                Text(
                  event.name,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpaceTiny,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20.sp,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
