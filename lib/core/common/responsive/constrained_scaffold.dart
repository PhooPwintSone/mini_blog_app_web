import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final double maxWidth;

  final Color? backgroundColor;
  final Widget? drawer;

  const ConstrainedScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.maxWidth = 750,

    this.backgroundColor,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: body,
        ),
      ),
    );
  }
}
