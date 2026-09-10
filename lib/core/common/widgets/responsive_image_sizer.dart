import 'package:flutter/material.dart';

class ResponsiveImageSizer extends StatelessWidget {
  final Widget child;
  final double mobileHeight;

  const ResponsiveImageSizer({
    super.key,
    required this.child,
    this.mobileHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600
        ? AspectRatio(aspectRatio: 16 / 9, child: child)
        : SizedBox(height: mobileHeight, width: double.infinity, child: child);
  }
}
