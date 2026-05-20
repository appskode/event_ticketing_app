import 'package:event_ticket_app/ui/common/app_theme.dart';
import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDialogs {
  static void showSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'Continue',
    String? navigateTo,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _CustomDialog(
        icon: Icons.check_circle,
        iconColor: context.appColors.success,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: () {
          Navigator.of(context).pop();
          if (navigateTo != null) {
            context.go(navigateTo);
          }
        },
      ),
    );
  }

  static void showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _CustomDialog(
        icon: Icons.error,
        iconColor: context.colorScheme.error,
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    Color? confirmButtonColor,
    required VoidCallback onConfirm,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => _ConfirmationDialog(
        icon: Icons.warning_rounded,
        iconColor: context.appColors.warning,
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmButtonColor: confirmButtonColor ?? context.colorScheme.error,
        onConfirm: onConfirm,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
}

class _CustomDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const _CustomDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  State<_CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<_CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        contentPadding: EdgeInsets.all(SMALL_PADDING.w + 14.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(SMALL_PADDING.w + 6.w),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 48.sp,
              ),
            ),
            verticalSpaceSmall,
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpaceTiny,
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpaceMedium,
            ElevatedButton(
              onPressed: widget.onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.iconColor,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 32.w,
                  vertical: 12.h,
                ),
                elevation: 0,
              ),
              child: Text(
                widget.buttonText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmButtonColor;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmationDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.cancelText,
    required this.confirmText,
    required this.confirmButtonColor,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<_ConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
        contentPadding: EdgeInsets.all(SMALL_PADDING.w + 14.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(SMALL_PADDING.w + 6.w),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 48.sp,
              ),
            ),
            verticalSpaceSmall,
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpaceTiny,
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 16.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsPadding: EdgeInsets.only(
          bottom: SMALL_PADDING.w + 6.w,
          left: SMALL_PADDING.w + 6.w,
          right: SMALL_PADDING.w + 6.w,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    side: BorderSide(color: colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    widget.cancelText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              horizontalSpaceSmall,
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.confirmButtonColor,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.confirmText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
