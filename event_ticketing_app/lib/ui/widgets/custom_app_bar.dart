import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.hasBackButton = false,
    this.actions = const [],
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool hasBackButton;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      leading: hasBackButton
          ? IconButton(
              onPressed: context.pop,
              icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
            )
          : null,
      actions: actions,
      title: subtitle == null
          ? Text(title, style: theme.appBarTheme.titleTextStyle)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.appBarTheme.titleTextStyle),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Divider(
          height: 1.h,
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, subtitle == null ? 56.h : 64.h);
}
