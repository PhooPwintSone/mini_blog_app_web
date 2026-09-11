import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppPallete.errorColor, // Make it pop!
      behavior: SnackBarBehavior.floating,
    ),
  );
}
