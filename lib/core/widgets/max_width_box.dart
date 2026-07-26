import 'package:flutter/material.dart';

class MaxWidthBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthBox({super.key, required this.child, this.maxWidth = 1200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}