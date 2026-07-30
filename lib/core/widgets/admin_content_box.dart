import 'package:flutter/material.dart';

class AdminContentBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AdminContentBox({super.key, required this.child, this.maxWidth = 1000});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      heightFactor: 1.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}