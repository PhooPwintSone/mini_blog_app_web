import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = AppPallete.borderColor]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    // Form Text Field Theme
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(18),
      // Border when field is enabled but not focused
      enabledBorder: _border(),
      // Border when field is focused
      focusedBorder: _border(AppPallete.greyColor),
      // Border when validation fails (unfocused)
      errorBorder: _border(AppPallete.errorColor),
      // Border when validation fails and user focuses the field
      focusedErrorBorder: _border(AppPallete.errorColor),
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
    ),

    // Chip Theme
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      selectedColor: AppPallete.gradient1,
      side: BorderSide.none,
    ),

    // drawerTheme: DrawerThemeData(scrimColor: Colors.amber),
  );
}
