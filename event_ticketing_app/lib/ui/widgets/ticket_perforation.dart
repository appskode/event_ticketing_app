import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

/// Dashed tear line between ticket stub sections.
class TicketPerforation extends StatelessWidget {
  const TicketPerforation({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return SizedBox(
      height: 24.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -10.w,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: colorScheme.surface,
            ),
          ),
          Positioned(
            right: -10.w,
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: colorScheme.surface,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, 1.sp),
                  painter: _DashedLinePainter(
                    color: colorScheme.outlineVariant,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dashWidth = 6.0.w;
    final dashSpace = 5.0.w;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    double start = 0;
    while (start < size.width) {
      canvas.drawLine(
        Offset(start, 0),
        Offset(start + dashWidth, 0),
        paint,
      );
      start += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
