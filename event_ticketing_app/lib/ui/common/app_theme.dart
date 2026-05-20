import 'package:flutter/material.dart';

class AppTheme {
  static const seedColor = Color(0xFF0BBBB6);

  static ThemeData get lightTheme => _buildTheme(Brightness.light);

  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ).copyWith(
      primary: const Color(0xFF0BBBB6),
    );
    final appColors = brightness == Brightness.light
        ? AppColorsExtension.light
        : AppColorsExtension.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        errorStyle: TextStyle(color: colorScheme.error),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primary.withValues(alpha: 0.18),
        labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 13),
        secondaryLabelStyle: TextStyle(color: colorScheme.primary),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: colorScheme.onSurface, height: 1.45),
        bodyMedium: TextStyle(color: colorScheme.onSurface, height: 1.45),
        bodySmall: TextStyle(color: colorScheme.onSurfaceVariant, height: 1.4),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceContainerHighest;
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      extensions: [appColors],
    );
  }
}

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.success,
    required this.info,
    required this.warning,
    required this.imagePlaceholder,
    required this.onImagePlaceholder,
    required this.secondaryButtonBackground,
    required this.onSecondaryButton,
    required this.mutedText,
  });

  final Color success;
  final Color info;
  final Color warning;
  final Color imagePlaceholder;
  final Color onImagePlaceholder;
  final Color secondaryButtonBackground;
  final Color onSecondaryButton;
  final Color mutedText;

  static const light = AppColorsExtension(
    success: Color(0xFF2E7D32),
    info: Color(0xFF1565C0),
    warning: Color(0xFFF57C00),
    imagePlaceholder: Color(0xFFE0E0E0),
    onImagePlaceholder: Color(0xFF757575),
    secondaryButtonBackground: Color(0xFFDBE8F2),
    onSecondaryButton: Color(0xFF121417),
    mutedText: Color(0xFF6B7582),
  );

  static const dark = AppColorsExtension(
    success: Color(0xFF81C784),
    info: Color(0xFF64B5F6),
    warning: Color(0xFFFFB74D),
    imagePlaceholder: Color(0xFF424242),
    onImagePlaceholder: Color(0xFFBDBDBD),
    secondaryButtonBackground: Color(0xFF1E3A40),
    onSecondaryButton: Color(0xFFE0E0E0),
    mutedText: Color(0xFF9E9E9E),
  );

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? info,
    Color? warning,
    Color? imagePlaceholder,
    Color? onImagePlaceholder,
    Color? secondaryButtonBackground,
    Color? onSecondaryButton,
    Color? mutedText,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      onImagePlaceholder: onImagePlaceholder ?? this.onImagePlaceholder,
      secondaryButtonBackground:
          secondaryButtonBackground ?? this.secondaryButtonBackground,
      onSecondaryButton: onSecondaryButton ?? this.onSecondaryButton,
      mutedText: mutedText ?? this.mutedText,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other == null) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      imagePlaceholder: Color.lerp(imagePlaceholder, other.imagePlaceholder, t)!,
      onImagePlaceholder:
          Color.lerp(onImagePlaceholder, other.onImagePlaceholder, t)!,
      secondaryButtonBackground: Color.lerp(
        secondaryButtonBackground,
        other.secondaryButtonBackground,
        t,
      )!,
      onSecondaryButton: Color.lerp(onSecondaryButton, other.onSecondaryButton, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ?? AppColorsExtension.light;
}
