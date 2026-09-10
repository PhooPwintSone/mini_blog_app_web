import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientBtn extends StatelessWidget {
  final String btnText;
  final VoidCallback onTap;
  const AuthGradientBtn({
    super.key,
    required this.btnText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
            AppPallete.gradient3,
          ],
          begin: AlignmentGeometry.bottomLeft,
          end: AlignmentGeometry.topRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          fixedSize: const Size(480, 55),

          backgroundColor: AppPallete.transparentColor,
          elevation: 0,
          shadowColor: AppPallete.transparentColor,
        ),

        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: AppPallete.textColor,
          ),
        ),
      ),
    );
  }
}
