import 'package:event_ticket_app/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 16.sp,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          color: inputTheme.hintStyle?.color,
        ),
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: SMALL_PADDING.w + 2.w,
        ),
      ).applyDefaults(inputTheme),
      validator: validator,
    );
  }
}
