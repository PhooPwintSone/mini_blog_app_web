import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomBorder;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          color: AppPallete.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ),
            ]
          : null,
      bottom: showBottomBorder
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: AppPallete.borderColor.withValues(alpha: 0.6),
                height: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
