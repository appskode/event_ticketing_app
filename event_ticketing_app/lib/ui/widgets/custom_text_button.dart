import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isPrimary;
  final double fontSize;
  final double height;
  final double radius;
  final bool isLoading;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isPrimary = false,
    this.fontSize = 16,
    this.height = 48,
    this.radius = 12,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final bgColor = backgroundColor ??
        (isPrimary
            ? colorScheme.primary
            : (colorScheme.brightness == Brightness.light
                ? appColors.secondaryButtonBackground
                : colorScheme.surfaceContainerHigh));
    final fgColor = textColor ??
        (isPrimary
            ? colorScheme.onPrimary
            : (colorScheme.brightness == Brightness.light
                ? appColors.onSecondaryButton
                : colorScheme.onSurface));

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        minimumSize: Size(double.infinity, height.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fgColor,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                color: fgColor,
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
